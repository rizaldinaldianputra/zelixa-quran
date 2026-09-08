import 'package:flutter/material.dart';

import '../../services/settings_service.dart';
import '../../services/preferences_service.dart';
import '../../services/prayer_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  double _fontSize = 24.0;
  bool _showLatin = true;
  bool _showTranslation = true;

  bool _isNotificationEnabled = true;
  bool _useAdzanSound = true;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    final prefs = PreferencesService();
    _isNotificationEnabled = prefs.isNotificationEnabled;
    _useAdzanSound = prefs.useAdzanSound;
    _themeMode = prefs.themeMode;
    prefs.addListener(_onPrefsChanged);
  }

  void _onPrefsChanged() {
    if (mounted) {
      setState(() {
        final prefs = PreferencesService();
        _isNotificationEnabled = prefs.isNotificationEnabled;
        _useAdzanSound = prefs.useAdzanSound;
        _themeMode = prefs.themeMode;
      });
    }
  }

  @override
  void dispose() {
    PreferencesService().removeListener(_onPrefsChanged);
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final size = await SettingsService.getArabicFontSize();
    final latin = await SettingsService.getShowLatin();
    final trans = await SettingsService.getShowTranslation();

    if (mounted) {
      setState(() {
        _fontSize = size;
        _showLatin = latin;
        _showTranslation = trans;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBg = context.cardColor;
    final textPrim = context.textPrimary;
    final textSec = context.textSecondary;
    final primAdaptive = context.primaryAdaptive;
    final borderCol = context.borderColor;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Text(
            'Tema & Tampilan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primAdaptive,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilihan Mode Tampilan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrim,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildThemeOption(
                        title: 'Terang',
                        icon: Icons.light_mode_rounded,
                        mode: ThemeMode.light,
                        isSelected: _themeMode == ThemeMode.light,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemeOption(
                        title: 'Gelap',
                        icon: Icons.dark_mode_rounded,
                        mode: ThemeMode.dark,
                        isSelected: _themeMode == ThemeMode.dark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemeOption(
                        title: 'Sistem',
                        icon: Icons.brightness_auto_rounded,
                        mode: ThemeMode.system,
                        isSelected: _themeMode == ThemeMode.system,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Preview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pratinjau Teks Al-Qur\'an',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textSec,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: context.arabicColor,
                  ),
                ),
                if (_showLatin) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Bismillāhir-raḥmānir-raḥīm(i)',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: context.latinColor,
                    ),
                  ),
                ],
                if (_showTranslation) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang.',
                    style: TextStyle(fontSize: 13, color: textSec),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tampilan Al-Quran Section
          Text(
            'Teks & Huruf Al-Qur\'an',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primAdaptive,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ukuran Font Arab',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textPrim,
                              ),
                            ),
                            Text(
                              '${_fontSize.toInt()} pt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primAdaptive,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _fontSize,
                          min: 18.0,
                          max: 36.0,
                          divisions: 9,
                          activeColor: primAdaptive,
                          onChanged: (val) {
                            setState(() => _fontSize = val);
                            SettingsService.setArabicFontSize(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderCol),
                  SwitchListTile(
                    title: Text(
                      'Tampilkan Teks Latin (Transliterasi)',
                      style: TextStyle(fontSize: 14, color: textPrim),
                    ),
                    value: _showLatin,
                    activeThumbColor: primAdaptive,
                    onChanged: (val) {
                      setState(() => _showLatin = val);
                      SettingsService.setShowLatin(val);
                    },
                  ),
                  Divider(height: 1, color: borderCol),
                  SwitchListTile(
                    title: Text(
                      'Tampilkan Terjemahan Bahasa Indonesia',
                      style: TextStyle(fontSize: 14, color: textPrim),
                    ),
                    value: _showTranslation,
                    activeThumbColor: primAdaptive,
                    onChanged: (val) {
                      setState(() => _showTranslation = val);
                      SettingsService.setShowTranslation(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Pengaturan Notifikasi Adzan
          Text(
            'Pengaturan Notifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primAdaptive,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Aktifkan Pengingat Waktu Shalat',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrim),
                    ),
                    subtitle: Text(
                      'Master pengingat notifikasi shalat harian',
                      style: TextStyle(fontSize: 12, color: textSec),
                    ),
                    value: _isNotificationEnabled,
                    activeThumbColor: primAdaptive,
                    onChanged: (val) async {
                      await PreferencesService().setNotificationEnabled(val);
                      await PrayerService.scheduleAllNotifications();
                    },
                  ),
                  Divider(height: 1, color: borderCol),
                  SwitchListTile(
                    title: Text(
                      'Gunakan Suara Adzan',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrim),
                    ),
                    subtitle: Text(
                      _useAdzanSound ? 'Memutar lantunan Adzan' : 'Menggunakan nada dering bawaan HP',
                      style: TextStyle(fontSize: 12, color: textSec),
                    ),
                    value: _useAdzanSound,
                    activeThumbColor: primAdaptive,
                    onChanged: _isNotificationEnabled
                        ? (val) async {
                            await PreferencesService().setUseAdzanSound(val);
                            await NotificationService().recreateChannels();
                            await PrayerService.scheduleAllNotifications();
                          }
                        : null,
                  ),
                  if (_isNotificationEnabled) ...[
                    Divider(height: 1, color: borderCol),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pilihan Jadwal Shalat',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primAdaptive),
                          ),
                          Text(
                            'Aktifkan shalat tertentu',
                            style: TextStyle(fontSize: 11, color: textSec),
                          ),
                        ],
                      ),
                    ),
                    ...['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya', 'Imsak', 'Dhuha'].map((prayer) {
                      final isPrayerOn = PreferencesService().isPrayerConfiguredOn(prayer);
                      return CheckboxListTile(
                        dense: true,
                        activeColor: primAdaptive,
                        title: Text(prayer, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textPrim)),
                        subtitle: Text(
                          isPrayerOn ? 'Notifikasi aktif' : 'Dinonaktifkan',
                          style: TextStyle(fontSize: 11, color: isPrayerOn ? context.latinColor : textSec),
                        ),
                        secondary: Icon(
                          isPrayerOn ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                          size: 20,
                          color: isPrayerOn ? AppColors.accentGold : Colors.grey.shade400,
                        ),
                        value: isPrayerOn,
                        onChanged: (val) async {
                          await PreferencesService().setPrayerNotificationEnabled(prayer, val ?? false);
                          await PrayerService.scheduleAllNotifications();
                        },
                      );
                    }),
                    Divider(height: 1, color: borderCol),
                    ListTile(
                      leading: const Icon(Icons.play_circle_outline, color: AppColors.accentGold),
                      title: Text(
                        'Uji Coba Bunyi Notifikasi',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrim),
                      ),
                      subtitle: Text(
                        _useAdzanSound ? 'Tes dengarkan suara Adzan' : 'Tes dengarkan nada bawaan',
                        style: TextStyle(fontSize: 11, color: textSec),
                      ),
                      trailing: Icon(Icons.chevron_right, size: 18, color: textSec),
                      onTap: () async {
                        await NotificationService().showTestNotification(useAdzanSound: _useAdzanSound);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: isDark ? AppColors.cardDarkSecondary : AppColors.primaryLight,
                              content: const Text(
                                'Notifikasi uji coba dikirimkan ke bilah notifikasi.',
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    final isDark = context.isDark;
    final activeBg = isDark
        ? AppColors.accentGold.withValues(alpha: 0.18)
        : const Color(0xFF0F3A26).withValues(alpha: 0.1);
    final activeBorder = isDark ? AppColors.accentGold : const Color(0xFF0F3A26);
    final activeText = isDark ? AppColors.accentGold : const Color(0xFF0F3A26);

    return InkWell(
      onTap: () async {
        await PreferencesService().setThemeMode(mode);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeBorder : context.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? activeText : context.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeText : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
