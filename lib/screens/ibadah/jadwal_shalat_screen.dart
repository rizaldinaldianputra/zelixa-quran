import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/prayer_service.dart';
import '../../services/notification_service.dart';
import '../../services/preferences_service.dart';
import '../../services/widget_service.dart';
import '../../theme/app_theme.dart';

class JadwalShalatScreen extends StatefulWidget {
  const JadwalShalatScreen({super.key});

  @override
  State<JadwalShalatScreen> createState() => _JadwalShalatScreenState();
}

class _JadwalShalatScreenState extends State<JadwalShalatScreen> {
  CityLocation _city = PrayerService.cities[0];
  DateTime _selectedDate = DateTime.now();
  PrayerSchedule? _schedule;
  NextPrayerInfo? _nextPrayer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    PreferencesService().addListener(_onPrefsChanged);
    _initNotifications();
    _loadSchedule();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _onPrefsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initNotifications() async {
    await NotificationService().requestPermissions();
    await PrayerService.scheduleAllNotifications();
  }

  @override
  void dispose() {
    PreferencesService().removeListener(_onPrefsChanged);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSchedule() async {
    final c = await PrayerService.getSelectedCity();
    final s = PrayerService.calculatePrayers(c, _selectedDate);
    if (mounted) {
      setState(() {
        _city = c;
        _schedule = s;
        _nextPrayer = PrayerService.getNextPrayer(s);
      });
      WidgetService.updateWidget(schedule: s, nextPrayer: _nextPrayer);
    }
  }

  void _tick() {
    if (_schedule != null && mounted) {
      setState(() {
        _nextPrayer = PrayerService.getNextPrayer(_schedule!);
      });
    }
  }

  String _format(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _togglePrayer(String prayerName) async {
    final prefs = PreferencesService();
    final currentlyOn = prefs.isPrayerNotificationEnabled(prayerName);
    final nextVal = !currentlyOn;

    await prefs.setPrayerNotificationEnabled(prayerName, nextVal);
    await PrayerService.scheduleAllNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.isDark ? AppColors.cardDarkSecondary : const Color(0xFF0F3A26),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(
                nextVal
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded,
                color: nextVal ? const Color(0xFFE2B75A) : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nextVal
                      ? 'Pengingat $prayerName diaktifkan (${prefs.useAdzanSound ? "Suara Adzan" : "Nada Bawaan"})'
                      : 'Pengingat $prayerName dimatikan',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _toggleAllPrayers(bool enable) async {
    final prefs = PreferencesService();
    await prefs.setAllPrayerNotifications(enable);
    await PrayerService.scheduleAllNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.isDark ? AppColors.cardDarkSecondary : const Color(0xFF0F3A26),
          duration: const Duration(seconds: 2),
          content: Text(
            enable
                ? 'Semua pengingat shalat dinyalakan'
                : 'Semua pengingat shalat dimatikan',
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> _toggleSoundType() async {
    final prefs = PreferencesService();
    final nextVal = !prefs.useAdzanSound;
    await prefs.setUseAdzanSound(nextVal);
    await NotificationService().recreateChannels();
    await PrayerService.scheduleAllNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.isDark ? AppColors.cardDarkSecondary : const Color(0xFF0F3A26),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(
                nextVal ? Icons.volume_up_rounded : Icons.music_note_rounded,
                color: const Color(0xFFE2B75A),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nextVal
                      ? 'Nada dering diubah ke Suara Adzan'
                      : 'Nada dering diubah ke Nada Bawaan',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (_schedule == null) {
      return Scaffold(
        backgroundColor: context.scaffoldBg,
        body: Center(
          child: CircularProgressIndicator(color: context.primaryAdaptive),
        ),
      );
    }

    final prefs = PreferencesService();
    final dhuha = _schedule!.terbit.add(const Duration(minutes: 20));

    final items = [
      {
        'name': 'Imsak',
        'time': _schedule!.imsak,
        'icon': Icons.nightlight_round,
        'canNotify': true,
      },
      {
        'name': 'Subuh',
        'time': _schedule!.subuh,
        'icon': Icons.wb_twilight,
        'canNotify': true,
      },
      {
        'name': 'Terbit',
        'time': _schedule!.terbit,
        'icon': Icons.wb_sunny_outlined,
        'canNotify': false,
      },
      {
        'name': 'Dhuha',
        'time': dhuha,
        'icon': Icons.wb_sunny,
        'canNotify': true,
      },
      {
        'name': 'Dzuhur',
        'time': _schedule!.dzuhur,
        'icon': Icons.sunny,
        'canNotify': true,
      },
      {
        'name': 'Ashar',
        'time': _schedule!.ashar,
        'icon': Icons.wb_twilight,
        'canNotify': true,
      },
      {
        'name': 'Maghrib',
        'time': _schedule!.maghrib,
        'icon': Icons.bedtime_outlined,
        'canNotify': true,
      },
      {
        'name': 'Isya',
        'time': _schedule!.isya,
        'icon': Icons.bedtime,
        'canNotify': true,
      },
    ];

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Jadwal Shalat Lengkap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'Ganti Kota',
            onPressed: _pickCity,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu Notifikasi',
            onSelected: (val) async {
              if (val == 'all_on') {
                await _toggleAllPrayers(true);
              } else if (val == 'all_off') {
                await _toggleAllPrayers(false);
              } else if (val == 'toggle_sound') {
                await _toggleSoundType();
              } else if (val == 'test_notif') {
                await NotificationService().showTestNotification(
                  useAdzanSound: prefs.useAdzanSound,
                );
              } else if (val == 'show_widget_guide') {
                _showWidgetGuideDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all_on',
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: context.primaryAdaptive,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text('Nyalakan Semua Notifikasi'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'all_off',
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('Matikan Semua Notifikasi'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle_sound',
                child: Row(
                  children: [
                    Icon(
                      prefs.useAdzanSound ? Icons.volume_up : Icons.music_note,
                      color: context.primaryAdaptive,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      prefs.useAdzanSound
                          ? 'Ganti ke Nada Bawaan'
                          : 'Ganti ke Suara Adzan',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test_notif',
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Color(0xFFE2B75A),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('Uji Coba Bunyi Notifikasi'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'show_widget_guide',
                child: Row(
                  children: [
                    Icon(
                      Icons.widgets_outlined,
                      color: context.primaryAdaptive,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text('Widget Home Screen HP'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Next Prayer Countdown Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3A26), Color(0xFF1E5B3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F3A26).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kota ${_city.name}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          color: Color(0xFFE2B75A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nextPrayer != null
                        ? 'Menuju ${_nextPrayer!.name}'
                        : 'Waktu Shalat',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nextPrayer != null
                        ? _formatDuration(_nextPrayer!.remaining)
                        : '--:--:--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_nextPrayer != null)
                    Text(
                      'Pukul ${_format(_nextPrayer!.time)} WIB',
                      style: const TextStyle(
                        color: Color(0xFFE2B75A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date navigation row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: context.textPrimary),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(
                        const Duration(days: 1),
                      );
                      _loadSchedule();
                    });
                  },
                ),
                Text(
                  '${_selectedDate.day} ${_getMonth(_selectedDate.month)} ${_selectedDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.primaryAdaptive,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: context.textPrimary),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        const Duration(days: 1),
                      );
                      _loadSchedule();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notification Quick Settings Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.badgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      prefs.useAdzanSound
                          ? Icons.volume_up_rounded
                          : Icons.notifications_active_rounded,
                      color: context.badgeIcon,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengingat Adzan & Shalat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ketuk ikon lonceng untuk atur tiap waktu shalat',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _toggleSoundType,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: prefs.useAdzanSound
                            ? (isDark ? const Color(0xFF3B2F15) : const Color(0xFFFEF3C7))
                            : context.cardSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: prefs.useAdzanSound
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            prefs.useAdzanSound
                                ? Icons.record_voice_over_rounded
                                : Icons.music_note_rounded,
                            size: 13,
                            color: prefs.useAdzanSound
                                ? const Color(0xFFD97706)
                                : context.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            prefs.useAdzanSound ? 'Adzan' : 'Bawaan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: prefs.useAdzanSound
                                  ? const Color(0xFFD97706)
                                  : context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Prayer Time Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final name = item['name'] as String;
                final canNotify = item['canNotify'] as bool;
                final isNext = _nextPrayer != null && _nextPrayer!.name == name;
                final dt = item['time'] as DateTime;
                final isNotifActive =
                    canNotify && prefs.isPrayerNotificationEnabled(name);

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isNext
                        ? (isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26))
                        : context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isNext
                          ? (isDark ? const Color(0xFF2A6E4F) : const Color(0xFF0F3A26))
                          : (isNotifActive
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                                : context.borderColor),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isNext
                            ? const Color(0xFF0F3A26).withValues(alpha: 0.2)
                            : (isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02)),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isNext
                              ? Colors.white.withValues(alpha: 0.12)
                              : context.badgeBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 20,
                          color: isNext
                              ? const Color(0xFFE2B75A)
                              : context.badgeIcon,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isNext
                                    ? Colors.white
                                    : context.textPrimary,
                              ),
                            ),
                            if (canNotify) ...[
                              const SizedBox(height: 2),
                              Text(
                                isNotifActive
                                    ? (prefs.useAdzanSound
                                          ? 'Pengingat Adzan Aktif'
                                          : 'Pengingat Aktif')
                                    : 'Pengingat Dimatikan',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isNotifActive
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isNext
                                      ? (isNotifActive
                                            ? const Color(0xFFE2B75A)
                                            : Colors.white54)
                                      : (isNotifActive
                                            ? const Color(0xFFD97706)
                                            : context.textSecondary),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        _format(dt),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isNext
                              ? const Color(0xFFE2B75A)
                              : context.primaryAdaptive,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (canNotify)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _togglePrayer(name),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isNotifActive
                                    ? (isNext
                                          ? const Color(0xFFE2B75A)
                                                .withValues(alpha: 0.25)
                                          : (isDark ? const Color(0xFF3A2D13) : const Color(0xFFFEF3C7)))
                                    : (isNext
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : context.cardSecondaryColor),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isNotifActive
                                      ? (isNext
                                            ? const Color(0xFFE2B75A)
                                                  .withValues(alpha: 0.6)
                                            : const Color(0xFFF59E0B)
                                                  .withValues(alpha: 0.4))
                                      : (isNext
                                            ? Colors.white.withValues(
                                                alpha: 0.1,
                                              )
                                            : context.borderColor),
                                  width: 1.2,
                                ),
                                boxShadow: isNotifActive
                                    ? [
                                        BoxShadow(
                                          color:
                                              (isNext
                                                      ? const Color(0xFFE2B75A)
                                                      : const Color(0xFFF59E0B))
                                                  .withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                isNotifActive
                                    ? Icons.notifications_active_rounded
                                    : Icons.notifications_off_outlined,
                                size: 20,
                                color: isNotifActive
                                    ? (isNext
                                          ? const Color(0xFFE2B75A)
                                          : const Color(0xFFD97706))
                                    : (isNext
                                          ? Colors.white38
                                          : context.textSecondary),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 36),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickCity() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: context.cardColor,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Kota',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: PrayerService.cities.length,
                    itemBuilder: (context, index) {
                      final c = PrayerService.cities[index];
                      final isSel = c.name == _city.name;
                      return ListTile(
                        title: Text(
                          c.name,
                          style: TextStyle(
                            color: isSel ? context.primaryAdaptive : context.textPrimary,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSel
                            ? Icon(Icons.check, color: context.primaryAdaptive)
                            : null,
                        onTap: () async {
                          await PrayerService.setSelectedCity(index);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          _loadSchedule();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWidgetGuideDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = context.isDark;
        return Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: context.borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.badgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.widgets_rounded,
                      color: context.badgeIcon,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Widget Jadwal Shalat di Home Screen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.primaryAdaptive,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Pasang jadwal shalat langsung di layar depan HP Anda tanpa perlu membuka aplikasi:',
                style: TextStyle(fontSize: 13, color: context.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildStepItem('1', 'Kembali ke Layar Utama (Home Screen) HP Anda.'),
              _buildStepItem('2', 'Tekan & tahan (long-press) pada bagian kosong layar.'),
              _buildStepItem('3', 'Pilih menu "Widgets" atau "Widget".'),
              _buildStepItem('4', 'Cari "Zelixa Islamic" lalu pilih "Jadwal Shalat Zelixa".'),
              _buildStepItem('5', 'Tarik widget dan posisikan di layar depan Anda.'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.sync_rounded),
                  label: const Text('Perbarui / Sinkronkan Data Widget'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (_schedule != null) {
                      await WidgetService.updateWidget(
                        schedule: _schedule,
                        nextPrayer: _nextPrayer,
                      );
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: isDark ? AppColors.cardDarkSecondary : const Color(0xFF0F3A26),
                          content: const Text('Data widget jadwal shalat berhasil disinkronkan!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepItem(String no, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE2B75A),
              shape: BoxShape.circle,
            ),
            child: Text(
              no,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3A26),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: context.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  static String _getMonth(int m) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[m - 1];
  }
}
