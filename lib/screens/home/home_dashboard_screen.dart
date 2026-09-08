import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/prayer_service.dart';
import '../../services/bookmark_service.dart';
import '../../data/doa_data.dart';
import '../surah_detail_screen.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  final Function(int) onNavigateTab;

  const HomeDashboardScreen({super.key, required this.onNavigateTab});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  Timer? _timer;
  CityLocation _selectedCity = PrayerService.cities[0];
  PrayerSchedule? _prayerSchedule;
  NextPrayerInfo? _nextPrayer;
  LastReadModel? _lastRead;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updatePrayerCountdown(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final city = await PrayerService.getSelectedCity();
    final schedule = PrayerService.calculatePrayers(city);
    final lastRead = await BookmarkService.getLastRead();

    if (mounted) {
      setState(() {
        _selectedCity = city;
        _prayerSchedule = schedule;
        _nextPrayer = PrayerService.getNextPrayer(schedule);
        _lastRead = lastRead;
      });
    }
  }

  void _updatePrayerCountdown() {
    if (_prayerSchedule != null && mounted) {
      setState(() {
        _nextPrayer = PrayerService.getNextPrayer(_prayerSchedule!);
      });
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Pick an inspirational doa or ayah for today
    final randomDoa = DoaData.doaHarian[9]; // Doa Sapu Jagat

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F3A26),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE2B75A).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book,
                color: Color(0xFFE2B75A),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Zelixa Quran',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: Colors.white70),
            tooltip: _selectedCity.name,
            onPressed: () {
              _showCityPicker();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting & Header
              _buildGreetingHeader(),
              const SizedBox(height: 16),

              // Card Lanjutkan Membaca
              _buildLastReadCard(),
              const SizedBox(height: 16),

              // Card Jadwal Shalat
              _buildPrayerScheduleCard(),
              const SizedBox(height: 16),

              // Quick Shortcuts Grid
              _buildQuickActions(),
              const SizedBox(height: 16),

              // Card Ayat / Doa Pilihan
              _buildDailyInspirationCard(randomDoa),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assalāmu ‘alaikum,',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Semoga Harimu Penuh Berkah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A26),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_city, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${_selectedCity.name}, Indonesia',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3A26).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mosque, color: Color(0xFF0F3A26), size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildLastReadCard() {
    final hasLastRead = _lastRead != null;
    final surahName = hasLastRead ? _lastRead!.surahNameLatin : 'Al-Fatihah';
    final verseNum = hasLastRead ? _lastRead!.verseNumber : 1;
    final surahNum = hasLastRead ? _lastRead!.surahNumber : 1;

    return Container(
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
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: Color(0xFFE2B75A), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Lanjutkan Membaca',
                style: TextStyle(
                  color: Color(0xFFE2B75A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasLastRead ? 'Terakhir Dibaca' : 'Mulai Membaca',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            surahName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ayat No. $verseNum',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE2B75A),
              foregroundColor: const Color(0xFF0F3A26),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text(
              'Lanjutkan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurahDetailScreen(
                    surahNumber: surahNum,
                    surahName: surahName,
                  ),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerScheduleCard() {
    if (_prayerSchedule == null) return const SizedBox.shrink();

    final next = _nextPrayer;
    final remainingText = next != null
        ? _formatDuration(next.remaining)
        : '--:--:--';
    final nextName = next?.name ?? 'Shalat';

    final scheduleList = [
      {'name': 'Subuh', 'time': _prayerSchedule!.subuh},
      {'name': 'Dzuhur', 'time': _prayerSchedule!.dzuhur},
      {'name': 'Ashar', 'time': _prayerSchedule!.ashar},
      {'name': 'Maghrib', 'time': _prayerSchedule!.maghrib},
      {'name': 'Isya', 'time': _prayerSchedule!.isya},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_filled,
                    color: Color(0xFF0F3A26),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Jadwal Shalat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0F3A26),
                    ),
                  ),
                ],
              ),
              Text(
                'Menuju $nextName: -$remainingText',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE2B75A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: scheduleList.map((item) {
              final isTarget = item['name'] == nextName;
              final dt = item['time'] as DateTime;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isTarget
                      ? const Color(0xFF0F3A26)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      item['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isTarget ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(dt),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isTarget
                            ? const Color(0xFFE2B75A)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.menu_book_rounded, 'label': 'Al-Qur\'an', 'tab': 1},
      {
        'icon': Icons.volunteer_activism_rounded,
        'label': 'Doa & Dzikir',
        'tab': 2,
      },
      {'icon': Icons.explore_rounded, 'label': 'Arah Kiblat', 'tab': 3},
      {'icon': Icons.fingerprint_rounded, 'label': 'Tasbih', 'tab': 3},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return InkWell(
          onTap: () => widget.onNavigateTab(act['tab'] as int),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: (MediaQuery.of(context).size.width - 32 - 36) / 4,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3A26).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    act['icon'] as IconData,
                    color: const Color(0xFF0F3A26),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  act['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyInspirationCard(DoaItem doa) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2B75A).withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFE2B75A),
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ayat / Doa Pilihan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0F3A26),
                ),
              ),
              const Spacer(),
              Text(
                doa.source,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            doa.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 20,
              height: 1.8,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F3A26),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            doa.latin,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '"${doa.translation}"',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  void _showCityPicker() {
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
                'Pilih Kota untuk Jadwal Shalat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: PrayerService.cities.length,
                  itemBuilder: (context, index) {
                    final c = PrayerService.cities[index];
                    final isSelected = c.name == _selectedCity.name;
                    return ListTile(
                      title: Text(c.name),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF0F3A26))
                          : null,
                      onTap: () async {
                        await PrayerService.setSelectedCity(index);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _loadData();
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
}
