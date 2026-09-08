import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/hadits_data.dart';
import '../../theme/app_theme.dart';

class HaditsScreen extends StatelessWidget {
  const HaditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Hadits Pilihan',
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
        itemCount: HaditsData.arbain.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final h = HaditsData.arbain[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.isDark
                            ? AppColors.darkCardElevated
                            : const Color(0xFF0F3A26),
                        borderRadius: BorderRadius.circular(8),
                        border: context.isDark ? Border.all(color: context.borderColor) : null,
                      ),
                      child: Text(
                        'Hadits #${h.number}',
                        style: TextStyle(
                          color: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy_rounded, size: 18, color: context.textSecondary),
                      tooltip: 'Salin Hadits',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: '${h.title}\n\n${h.arabic}\n\nArtinya: ${h.translation}\n(${h.narrator})',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Hadits disalin ke papan klip'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  h.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  h.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    color: context.arabicColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  h.translation,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  h.narrator,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: context.latinColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
