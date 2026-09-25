import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String adhanChannelId = 'adhan_channel_v4';
  static const String defaultChannelId = 'default_channel_v4';

  Future<void> init() async {
    _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // Create and register notification channels upfront for Android
    await _createNotificationChannels();
  }

  void _configureLocalTimeZone() {
    tz.initializeTimeZones();
    try {
      final offsetHours = DateTime.now().timeZoneOffset.inHours;
      if (offsetHours == 9) {
        tz.setLocalLocation(tz.getLocation('Asia/Jayapura'));
      } else if (offsetHours == 8) {
        tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
      } else {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      }
    } catch (e) {
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      } catch (_) {}
    }
  }

  Future<void> _createNotificationChannels() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Clean up legacy channels if present
      try {
        await androidImplementation.deleteNotificationChannel(channelId: 'adhan_channel_id');
        await androidImplementation.deleteNotificationChannel(channelId: 'default_channel_id');
        await androidImplementation.deleteNotificationChannel(channelId: 'adhan_channel_v3');
        await androidImplementation.deleteNotificationChannel(channelId: 'default_channel_v3');
      } catch (_) {}

      // Adzan channel with high priority and alarm audio attributes
      const AndroidNotificationChannel adhanChannel = AndroidNotificationChannel(
        adhanChannelId,
        'Waktu Shalat (Adzan)',
        description: 'Notifikasi waktu shalat dengan lantunan suara Adzan',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('adzan'),
        playSound: true,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      );

      // Default ringtone channel with alarm attributes
      const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
        defaultChannelId,
        'Waktu Shalat (Nada Bawaan)',
        description: 'Notifikasi waktu shalat dengan nada dering bawaan',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      );

      await androidImplementation.createNotificationChannel(adhanChannel);
      await androidImplementation.createNotificationChannel(defaultChannel);
    }
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> schedulePrayerNotification(
    int id,
    String prayerName,
    DateTime prayerTime, {
    bool useAdzanSound = true,
    String? customBody,
  }) async {
    final scheduledTime = tz.TZDateTime(
      tz.local,
      prayerTime.year,
      prayerTime.month,
      prayerTime.day,
      prayerTime.hour,
      prayerTime.minute,
    );

    // Only schedule if time is strictly in the future
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    final AndroidNotificationDetails androidPlatformChannelSpecifics = useAdzanSound
        ? const AndroidNotificationDetails(
            adhanChannelId,
            'Waktu Shalat (Adzan)',
            channelDescription: 'Notifikasi waktu shalat dengan lantunan suara Adzan',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('adzan'),
            playSound: true,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
          )
        : const AndroidNotificationDetails(
            defaultChannelId,
            'Waktu Shalat (Nada Bawaan)',
            channelDescription: 'Notifikasi waktu shalat dengan nada dering bawaan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
          );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final body = customBody ?? 'Telah masuk waktu shalat $prayerName. Mari tunaikan shalat.';

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: 'Waktu $prayerName',
        body: body,
        scheduledDate: scheduledTime,
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: prayerName,
      );
      debugPrint('Scheduled $prayerName (ID: $id) exact at $scheduledTime');
    } catch (e) {
      debugPrint('Exact alarm failed for $prayerName ($e), falling back to inexactAllowWhileIdle');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: 'Waktu $prayerName',
          body: body,
          scheduledDate: scheduledTime,
          notificationDetails: platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: prayerName,
        );
      } catch (e2) {
        debugPrint('Failed to schedule notification $prayerName: $e2');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
    debugPrint('Canceled notification ID: $id');
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> recreateChannels() async {
    await _createNotificationChannels();
  }

  Future<void> showTestNotification({bool useAdzanSound = true}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = useAdzanSound
        ? const AndroidNotificationDetails(
            adhanChannelId,
            'Waktu Shalat (Adzan)',
            channelDescription: 'Notifikasi waktu shalat dengan lantunan suara Adzan',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('adzan'),
            playSound: true,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
          )
        : const AndroidNotificationDetails(
            defaultChannelId,
            'Waktu Shalat (Nada Bawaan)',
            channelDescription: 'Notifikasi waktu shalat dengan nada dering bawaan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
          );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 999,
      title: 'Uji Coba Notifikasi Shalat',
      body: useAdzanSound
          ? 'Memutar lantunan suara Adzan Zelixa.'
          : 'Memutar nada notifikasi bawaan.',
      notificationDetails: platformChannelSpecifics,
      payload: 'test_notification',
    );
  }
}
