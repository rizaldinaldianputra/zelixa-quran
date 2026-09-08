import 'package:flutter/material.dart';

import 'jadwal_shalat_screen.dart';
import 'kiblat_screen.dart';
import 'kalender_hijriah_screen.dart';
import 'tasbih_screen.dart';

class IbadahTabScreen extends StatelessWidget {
  const IbadahTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'title': 'Jadwal Shalat',
        'subtitle': 'Waktu shalat harian & hitung mundur',
        'icon': Icons.access_time_filled,
        'screen': const JadwalShalatScreen(),
      },
      {
        'title': 'Arah Kiblat',
        'subtitle': 'Kompas penunjuk arah Ka\'bah',
        'icon': Icons.explore_rounded,
        'screen': const KiblatScreen(),
      },
      {
        'title': 'Kalender Hijriah',
        'subtitle': 'Penanggalan Islam & hari-hari besar',
        'icon': Icons.calendar_month_rounded,
        'screen': const KalenderHijriahScreen(),
      },
      {
        'title': 'Tasbih Digital',
        'subtitle': 'Penghitung dzikir dengan getar',
        'icon': Icons.fingerprint_rounded,
        'screen': const TasbihScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Ibadah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final mod = modules[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => mod['screen'] as Widget),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3A26).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      mod['icon'] as IconData,
                      color: const Color(0xFF0F3A26),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mod['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mod['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
