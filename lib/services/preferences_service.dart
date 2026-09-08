import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService extends ChangeNotifier {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  late SharedPreferences _prefs;

  bool _isNotificationEnabled = true;
  bool _useAdzanSound = true;
  bool _isFirstTimeFeatureDiscovery = true;
  ThemeMode _themeMode = ThemeMode.system;

  final Map<String, bool> _prayerNotifications = {
    'Imsak': false,
    'Subuh': true,
    'Dhuha': false,
    'Dzuhur': true,
    'Ashar': true,
    'Maghrib': true,
    'Isya': true,
  };

  bool get isNotificationEnabled => _isNotificationEnabled;
  bool get useAdzanSound => _useAdzanSound;
  bool get isFirstTimeFeatureDiscovery => _isFirstTimeFeatureDiscovery;
  ThemeMode get themeMode => _themeMode;

  bool isPrayerNotificationEnabled(String prayerName) {
    if (!_isNotificationEnabled) return false;
    return _prayerNotifications[prayerName] ?? true;
  }

  bool isPrayerConfiguredOn(String prayerName) {
    return _prayerNotifications[prayerName] ?? true;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = _prefs.getBool('isNotificationEnabled') ?? true;
    _useAdzanSound = _prefs.getBool('useAdzanSound') ?? true;
    _isFirstTimeFeatureDiscovery = _prefs.getBool('isFirstTimeFeatureDiscovery') ?? true;

    final savedTheme = _prefs.getString('zelixa_theme_mode') ?? 'system';
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    for (var key in _prayerNotifications.keys) {
      final defaultValue = (key == 'Imsak' || key == 'Dhuha') ? false : true;
      _prayerNotifications[key] =
          _prefs.getBool('notif_prayer_$key') ?? defaultValue;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String val = 'system';
    if (mode == ThemeMode.dark) val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    await _prefs.setString('zelixa_theme_mode', val);
    notifyListeners();
  }

  Future<void> setNotificationEnabled(bool value) async {
    _isNotificationEnabled = value;
    await _prefs.setBool('isNotificationEnabled', value);
    notifyListeners();
  }

  Future<void> setUseAdzanSound(bool value) async {
    _useAdzanSound = value;
    await _prefs.setBool('useAdzanSound', value);
    notifyListeners();
  }

  Future<void> setFeatureDiscoveryShown() async {
    _isFirstTimeFeatureDiscovery = false;
    await _prefs.setBool('isFirstTimeFeatureDiscovery', false);
    notifyListeners();
  }

  Future<void> setPrayerNotificationEnabled(
    String prayerName,
    bool value,
  ) async {
    _prayerNotifications[prayerName] = value;
    await _prefs.setBool('notif_prayer_$prayerName', value);
    // If turning on a prayer while master is off, automatically enable master
    if (value && !_isNotificationEnabled) {
      _isNotificationEnabled = true;
      await _prefs.setBool('isNotificationEnabled', true);
    }
    notifyListeners();
  }

  Future<void> setAllPrayerNotifications(bool value) async {
    _isNotificationEnabled = value;
    await _prefs.setBool('isNotificationEnabled', value);
    for (var key in _prayerNotifications.keys) {
      if (key == 'Imsak' || key == 'Dhuha') {
        _prayerNotifications[key] = value;
      } else {
        _prayerNotifications[key] = value;
      }
      await _prefs.setBool('notif_prayer_$key', value);
    }
    notifyListeners();
  }
}
