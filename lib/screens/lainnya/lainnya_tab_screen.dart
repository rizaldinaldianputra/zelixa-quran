import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'hadits_screen.dart';
import 'pengaturan_screen.dart';
import 'tentang_aplikasi_screen.dart';
import '../zakat/kalkulator_zakat_screen.dart';

class LainnyaTabScreen extends StatelessWidget {
  const LainnyaTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'Kalkulator Zakat',
        'subtitle': 'Hitung Zakat Fitrah, Penghasilan & Maal',
        'icon': Icons.calculate_rounded,
        'screen': const KalkulatorZakatScreen(),
      },
      {
        'title': 'Hadits Pilihan',
        'subtitle': 'Kumpulan Hadits Arbain Nawawi & makna',
        'icon': Icons.menu_book_rounded,
        'screen': const HaditsScreen(),
      },
      {
        'title': 'Pengaturan',
        'subtitle': 'Tema, ukuran teks Arab, terjemahan, dan latin',
        'icon': Icons.settings_rounded,
        'screen': const PengaturanScreen(),
      },
      {
        'title': 'Tentang Aplikasi',
        'subtitle': 'Versi aplikasi, profil, dan sumber data',
        'icon': Icons.info_outline_rounded,
        'screen': const TentangAplikasiScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Lainnya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.isDark ? AppColors.darkTextPrimary : Colors.white,
          ),
        ),
        backgroundColor: context.isDark ? AppColors.darkCardSurface : const Color(0xFF0F3A26),
        foregroundColor: context.isDark ? AppColors.darkTextPrimary : Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item['screen'] as Widget),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.darkCardElevated
                          : const Color(0xFF0F3A26).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: context.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
