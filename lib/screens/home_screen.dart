import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../theme/app_theme.dart';
import 'surah_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Al-Quran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.isDark ? AppColors.darkTextPrimary : Colors.white,
          ),
        ),
        backgroundColor: context.isDark ? AppColors.darkCardSurface : const Color(0xFF0F3A26),
        foregroundColor: context.isDark ? AppColors.darkTextPrimary : Colors.white,
        elevation: 0,
      ),
      body: chaptersAsync.when(
        data: (chapters) {
          if (chapters.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data surah.',
                style: TextStyle(color: context.textSecondary),
              ),
            );
          }
          return ListView.separated(
            itemCount: chapters.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: context.borderColor),
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final surahNumber = chapter['surah_number'] as int;
              final surahName = chapter['surah_name'] as String;

              return Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.isDark
                        ? AppColors.darkCardElevated
                        : const Color(0xFFE2B75A).withValues(alpha: 0.2),
                    foregroundColor: context.isDark ? AppColors.gold : const Color(0xFF0F3A26),
                    child: Text(
                      '$surahNumber',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    surahName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: context.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(
                          surahNumber: surahNumber,
                          surahName: surahName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(color: context.textSecondary),
          ),
        ),
      ),
    );
  }
}
