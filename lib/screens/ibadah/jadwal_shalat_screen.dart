import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/prayer_service.dart';

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
    _loadSchedule();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    if (_schedule == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF0F3A26))),
      );
    }

    final dhuha = _schedule!.terbit.add(const Duration(minutes: 20));

    final items = [
      {'name': 'Imsak', 'time': _schedule!.imsak, 'icon': Icons.nightlight_round},
      {'name': 'Subuh', 'time': _schedule!.subuh, 'icon': Icons.wb_twilight},
      {'name': 'Terbit', 'time': _schedule!.terbit, 'icon': Icons.wb_sunny_outlined},
      {'name': 'Dhuha', 'time': dhuha, 'icon': Icons.wb_sunny},
      {'name': 'Dzuhur', 'time': _schedule!.dzuhur, 'icon': Icons.sunny},
      {'name': 'Ashar', 'time': _schedule!.ashar, 'icon': Icons.wb_twilight},
      {'name': 'Maghrib', 'time': _schedule!.maghrib, 'icon': Icons.bedtime_outlined},
      {'name': 'Isya', 'time': _schedule!.isya, 'icon': Icons.bedtime},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Jadwal Shalat Lengkap', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'Ganti Kota',
            onPressed: _pickCity,
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
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(color: Color(0xFFE2B75A), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nextPrayer != null ? 'Menuju ${_nextPrayer!.name}' : 'Waktu Shalat',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nextPrayer != null ? _formatDuration(_nextPrayer!.remaining) : '--:--:--',
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
                      style: const TextStyle(color: Color(0xFFE2B75A), fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date navigation row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                      _loadSchedule();
                    });
                  },
                ),
                Text(
                  '${_selectedDate.day} ${_getMonth(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F3A26)),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                      _loadSchedule();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Prayer Time Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isNext = _nextPrayer != null && _nextPrayer!.name == item['name'];
                final dt = item['time'] as DateTime;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isNext ? const Color(0xFF0F3A26) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isNext ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isNext ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _format(dt),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isNext ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                        ),
                      ),
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
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kota',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      title: Text(c.name),
                      trailing: isSel ? const Icon(Icons.check, color: Color(0xFF0F3A26)) : null,
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
        );
      },
    );
  }

  static String _getMonth(int m) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[m - 1];
  }
}
