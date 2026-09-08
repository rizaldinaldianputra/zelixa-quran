import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // Default to Jakarta if local timezone isn't easily obtained without extra packages
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> schedulePrayerNotification(int id, String prayerName, DateTime prayerTime, {bool useAdzanSound = true, String? customBody}) async {
    // Only schedule if the time is in the future
    if (prayerTime.isBefore(DateTime.now())) return;

    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    final AndroidNotificationDetails androidPlatformChannelSpecifics = useAdzanSound
        ? const AndroidNotificationDetails(
            'adhan_channel_id',
            'Waktu Shalat (Adzan)',
            channelDescription: 'Notifikasi waktu shalat dengan suara Adzan',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('adzan'),
            playSound: true,
            enableVibration: true,
          )
        : const AndroidNotificationDetails(
            'default_channel_id',
            'Waktu Shalat',
            channelDescription: 'Notifikasi waktu shalat dengan suara bawaan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final body = customBody ?? 'Telah masuk waktu shalat $prayerName. Mari tunaikan shalat.';

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: 'Waktu $prayerName',
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: prayerName,
    );
    
    debugPrint('Scheduled $prayerName at $scheduledTime (ID: $id)');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
    debugPrint('Canceled notification ID: $id');
  }
  
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> recreateChannels() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.deleteNotificationChannel(channelId: 'adhan_channel_id');
      await androidImplementation.deleteNotificationChannel(channelId: 'default_channel_id');
    }
  }

  Future<void> showTestNotification({bool useAdzanSound = true}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = useAdzanSound
        ? const AndroidNotificationDetails(
            'adhan_channel_id',
            'Waktu Shalat (Adzan)',
            channelDescription: 'Notifikasi waktu shalat dengan suara Adzan',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('adzan'),
            playSound: true,
            enableVibration: true,
          )
        : const AndroidNotificationDetails(
            'default_channel_id',
            'Waktu Shalat',
            channelDescription: 'Notifikasi waktu shalat dengan suara bawaan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 999,
      title: 'Uji Coba Notifikasi Shalat',
      body: useAdzanSound
          ? 'Ini adalah contoh notifikasi shalat dengan suara Adzan.'
          : 'Ini adalah contoh notifikasi shalat dengan nada dering bawaan.',
      notificationDetails: platformChannelSpecifics,
      payload: 'test_notification',
    );
  }
}
