import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyFontSize = 'zelixa_font_size';
  static const String _keyShowLatin = 'zelixa_show_latin';
  static const String _keyShowTranslation = 'zelixa_show_translation';
  static const String _keyThemeMode = 'zelixa_theme_mode';

  static Future<double> getArabicFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyFontSize) ?? 24.0;
  }

  static Future<void> setArabicFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, size);
  }

  static Future<bool> getShowLatin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowLatin) ?? true;
  }

  static Future<void> setShowLatin(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowLatin, show);
  }

  static Future<bool> getShowTranslation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowTranslation) ?? true;
  }

  static Future<void> setShowTranslation(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowTranslation, show);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_keyThemeMode);
    if (mode == 'dark') return ThemeMode.dark;
    if (mode == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String val = 'system';
    if (mode == ThemeMode.dark) val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    await prefs.setString(_keyThemeMode, val);
  }
}
