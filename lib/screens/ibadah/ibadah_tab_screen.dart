import 'package:flutter/material.dart';

import 'jadwal_shalat_screen.dart';
import 'kiblat_screen.dart';
import 'kalender_hijriah_screen.dart';
import 'tasbih_screen.dart';
import '../shalat/panduan_shalat_screen.dart';
import '../zakat/kalkulator_zakat_screen.dart';
import '../../theme/app_theme.dart';

class IbadahTabScreen extends StatelessWidget {
  const IbadahTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final modules = [
      {
        'title': 'Kalkulator Zakat',
        'subtitle': 'Hitung Zakat Fitrah, Penghasilan & Maal otomatis',
        'icon': Icons.calculate_rounded,
        'screen': const KalkulatorZakatScreen(),
      },
      {
        'title': 'Panduan Shalat Lengkap',
        'subtitle': 'Tata cara, bacaan, gerakan & semua jenis shalat',
        'icon': Icons.accessibility_new_rounded,
        'screen': const PanduanShalatScreen(),
      },
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
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Ibadah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
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
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
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
                      color: context.badgeBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      mod['icon'] as IconData,
                      color: context.badgeIcon,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mod['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: context.textSecondary,
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
