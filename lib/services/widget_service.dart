import 'package:flutter/services.dart';
import 'prayer_service.dart';

class WidgetService {
  static const MethodChannel _channel =
      MethodChannel('com.zelixa.zelixaquran/widget');

  static String _format(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  /// Memperbarui data jadwal shalat pada Android Home Screen Widget
  static Future<void> updateWidget({
    PrayerSchedule? schedule,
    NextPrayerInfo? nextPrayer,
  }) async {
    try {
      final now = DateTime.now();
      final currentSchedule = schedule ?? await PrayerService.getTodaySchedule();
      final currentNextPrayer =
          nextPrayer ?? PrayerService.getNextPrayer(currentSchedule);

      final Map<String, String> widgetData = {
        'city': currentSchedule.cityName,
        'date': _formatDate(now),
        'nextPrayerName': currentNextPrayer.name,
        'nextPrayerTime': '${_format(currentNextPrayer.time)} WIB',
        'subuh': _format(currentSchedule.subuh),
        'dzuhur': _format(currentSchedule.dzuhur),
        'ashar': _format(currentSchedule.ashar),
        'maghrib': _format(currentSchedule.maghrib),
        'isya': _format(currentSchedule.isya),
      };

      await _channel.invokeMethod('updateWidgetData', widgetData);
    } catch (e) {
      // Ignored or logged if platform is not Android or widget not yet placed
    }
  }
}
