import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class CityLocation {
  final String name;
  final double latitude;
  final double longitude;
  final double timezone;

  const CityLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });
}

class PrayerSchedule {
  final String cityName;
  final DateTime date;
  final DateTime imsak;
  final DateTime subuh;
  final DateTime terbit;
  final DateTime dzuhur;
  final DateTime ashar;
  final DateTime maghrib;
  final DateTime isya;

  PrayerSchedule({
    required this.cityName,
    required this.date,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });
}

class NextPrayerInfo {
  final String name;
  final DateTime time;
  final Duration remaining;

  NextPrayerInfo({
    required this.name,
    required this.time,
    required this.remaining,
  });
}

class PrayerService {
  static const String _keyCityIndex = 'zelixa_prayer_city_index';

  static const List<CityLocation> cities = [
    CityLocation(name: 'Jakarta', latitude: -6.2088, longitude: 106.8456, timezone: 7.0),
    CityLocation(name: 'Surabaya', latitude: -7.2575, longitude: 112.7521, timezone: 7.0),
    CityLocation(name: 'Bandung', latitude: -6.9175, longitude: 107.6191, timezone: 7.0),
    CityLocation(name: 'Medan', latitude: 3.5952, longitude: 98.6722, timezone: 7.0),
    CityLocation(name: 'Makassar', latitude: -5.1477, longitude: 119.4327, timezone: 8.0),
    CityLocation(name: 'Semarang', latitude: -6.9667, longitude: 110.4167, timezone: 7.0),
    CityLocation(name: 'Palembang', latitude: -2.9909, longitude: 104.7565, timezone: 7.0),
    CityLocation(name: 'Yogyakarta', latitude: -7.7956, longitude: 110.3695, timezone: 7.0),
    CityLocation(name: 'Denpasar', latitude: -8.6705, longitude: 115.2126, timezone: 8.0),
    CityLocation(name: 'Banda Aceh', latitude: 5.5483, longitude: 95.3238, timezone: 7.0),
  ];

  static Future<CityLocation> getSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_keyCityIndex) ?? 0;
    if (index >= 0 && index < cities.length) {
      return cities[index];
    }
    return cities[0];
  }

  static Future<void> setSelectedCity(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCityIndex, index);
  }

  static PrayerSchedule calculatePrayers(CityLocation city, [DateTime? targetDate]) {
    final date = targetDate ?? DateTime.now();
    final lat = city.latitude;
    final lng = city.longitude;
    final tz = city.timezone;

    final julianDay = _julianDate(date.year, date.month, date.day);
    final d = julianDay - 2451545.0;

    // Mean anomaly and solar longitude
    final g = (357.529 + 0.98560028 * d) % 360;
    final q = (280.459 + 0.98564736 * d) % 360;
    final l = (q + 1.915 * math.sin(_degToRad(g)) + 0.020 * math.sin(_degToRad(2 * g))) % 360;

    final e = 23.439 - 0.00000036 * d; // Obliquity
    final dec = _radToDeg(math.asin(math.sin(_degToRad(e)) * math.sin(_degToRad(l))));

    // Equation of time in minutes
    final ra = _radToDeg(math.atan2(math.cos(_degToRad(e)) * math.sin(_degToRad(l)), math.cos(_degToRad(l)))) / 15;
    final eqt = (q / 15 - (ra % 24)) * 60;

    // Solar noon (Dzuhur) in hours
    final noonHours = 12 + tz - (lng / 15) - (eqt / 60);

    // Sun angle calculation for Subuh (20 deg below horizon) and Isya (18 deg)
    double angleHour(double angle) {
      final val = (-math.sin(_degToRad(angle)) - math.sin(_degToRad(lat)) * math.sin(_degToRad(dec))) /
          (math.cos(_degToRad(lat)) * math.cos(_degToRad(dec)));
      if (val < -1 || val > 1) return 0;
      return _radToDeg(math.acos(val)) / 15;
    }

    // Ashar shadow formula
    double asrHour() {
      final t = math.tan(_degToRad((lat - dec).abs()));
      final val = (math.sin(_degToRad(90 - _radToDeg(math.atan(1 + t)))) -
              math.sin(_degToRad(lat)) * math.sin(_degToRad(dec))) /
          (math.cos(_degToRad(lat)) * math.cos(_degToRad(dec)));
      if (val < -1 || val > 1) return 0;
      return _radToDeg(math.acos(val)) / 15;
    }

    final subuhDiff = angleHour(20.0);
    final sunriseDiff = angleHour(0.833);
    final asrDiff = asrHour();
    final sunsetDiff = angleHour(0.833);
    final isyaDiff = angleHour(18.0);

    DateTime toDateTime(double decimalHours) {
      int totalMinutes = (decimalHours * 60).round();
      int h = (totalMinutes ~/ 60) % 24;
      int m = totalMinutes % 60;
      return DateTime(date.year, date.month, date.day, h, m);
    }

    final dzuhur = toDateTime(noonHours + (2 / 60)); // safety +2 min
    final subuh = toDateTime(noonHours - subuhDiff + (2 / 60));
    final imsak = subuh.subtract(const Duration(minutes: 10));
    final terbit = toDateTime(noonHours - sunriseDiff);
    final ashar = toDateTime(noonHours + asrDiff + (2 / 60));
    final maghrib = toDateTime(noonHours + sunsetDiff + (2 / 60));
    final isya = toDateTime(noonHours + isyaDiff + (2 / 60));

    return PrayerSchedule(
      cityName: city.name,
      date: date,
      imsak: imsak,
      subuh: subuh,
      terbit: terbit,
      dzuhur: dzuhur,
      ashar: ashar,
      maghrib: maghrib,
      isya: isya,
    );
  }

  static NextPrayerInfo getNextPrayer(PrayerSchedule schedule) {
    final now = DateTime.now();
    final prayers = [
      MapEntry('Subuh', schedule.subuh),
      MapEntry('Dzuhur', schedule.dzuhur),
      MapEntry('Ashar', schedule.ashar),
      MapEntry('Maghrib', schedule.maghrib),
      MapEntry('Isya', schedule.isya),
    ];

    for (var p in prayers) {
      if (p.value.isAfter(now)) {
        return NextPrayerInfo(
          name: p.key,
          time: p.value,
          remaining: p.value.difference(now),
        );
      }
    }

    // If past Isya, next is tomorrow's Subuh
    final tomorrowSubuh = schedule.subuh.add(const Duration(days: 1));
    return NextPrayerInfo(
      name: 'Subuh',
      time: tomorrowSubuh,
      remaining: tomorrowSubuh.difference(now),
    );
  }

  static double _julianDate(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() + (30.6001 * (month + 1)).floor() + day + b - 1524.5;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
  static double _radToDeg(double rad) => rad * (180.0 / math.pi);
}
