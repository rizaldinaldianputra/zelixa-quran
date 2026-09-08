import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import 'surah_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: chaptersAsync.when(
        data: (chapters) {
          if (chapters.isEmpty) {
            return const Center(child: Text('Tidak ada data surah.'));
          }
          return ListView.separated(
            itemCount: chapters.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final surahNumber = chapter['surah_number'] as int;
              final surahName = chapter['surah_name'] as String;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE2B75A).withValues(alpha: 0.2),
                  foregroundColor: const Color(0xFF0F3A26),
                  child: Text('$surahNumber'),
                ),
                title: Text(
                  surahName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
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
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
