import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryLight = Color(0xFF0F3A26);
  static const Color primaryDark = Color(0xFF10462F);
  static const Color accentGold = Color(0xFFE2B75A);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentEmeraldBright = Color(0xFF34D399);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F1713); // Deep Islamic slate-charcoal
  static const Color appBarDark = Color(0xFF131E18);

  // Cards & Surfaces
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF18241F); // Elevated dark surface
  static const Color cardDarkSecondary = Color(0xFF202E28); // Subtle nested card
  static const Color cardLightSecondary = Color(0xFFF1F5F9);

  // Borders
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF263830);

  // Typography
  static const Color textLightPrimary = Color(0xFF1E293B);
  static const Color textLightSecondary = Color(0xFF64748B);
  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  // Arabic & Quran Text
  static const Color arabicLight = Color(0xFF0F3A26);
  static const Color arabicDark = Color(0xFFFFFFFF);
  static const Color latinLight = Color(0xFF059669);
  static const Color latinDark = Color(0xFF34D399);

  // Legacy aliases
  static const Color emeraldLight = Color(0xFFD1FAE5);
  static const Color darkTextPrimary = textDarkPrimary;
  static const Color darkTextSecondary = textDarkSecondary;
  static const Color darkCardSurface = cardDark;
  static const Color darkCardElevated = cardDarkSecondary;
  static const Color darkBorder = borderDark;
  static const Color gold = accentGold;
}

extension ThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get scaffoldBg => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => isDark ? AppColors.cardDark : AppColors.cardLight;
  Color get cardSecondaryColor => isDark ? AppColors.cardDarkSecondary : AppColors.cardLightSecondary;
  Color get textPrimary => isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
  Color get textSecondary => isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
  Color get borderColor => isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get arabicColor => isDark ? AppColors.arabicDark : AppColors.arabicLight;
  Color get latinColor => isDark ? AppColors.latinDark : AppColors.latinLight;
  Color get primaryAdaptive => isDark ? AppColors.accentEmeraldBright : AppColors.primaryLight;
  Color get badgeBg => isDark
      ? AppColors.accentEmerald.withValues(alpha: 0.18)
      : AppColors.primaryLight.withValues(alpha: 0.08);
  Color get badgeIcon => isDark ? AppColors.accentEmeraldBright : AppColors.primaryLight;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        secondary: AppColors.accentGold,
        surface: AppColors.cardLight,
        onSurface: AppColors.textLightPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.accentGold.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
            );
          }
          return const TextStyle(fontSize: 12, color: Colors.black54);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight.withValues(alpha: 0.4);
          }
          return Colors.grey.shade300;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.transparent;
        }),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primaryLight,
        thumbColor: AppColors.primaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentEmerald,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentEmerald,
        secondary: AppColors.accentGold,
        surface: AppColors.cardDark,
        onSurface: AppColors.textDarkPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appBarDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.appBarDark,
        indicatorColor: AppColors.accentGold.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.accentGold,
            );
          }
          return const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentEmeraldBright;
          }
          return Colors.grey.shade600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentEmerald.withValues(alpha: 0.5);
          }
          return Colors.grey.shade800;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentEmerald;
          }
          return Colors.transparent;
        }),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accentEmerald,
        thumbColor: AppColors.accentEmerald,
      ),
    );
  }
}
