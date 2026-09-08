import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/quran_provider.dart';
import '../../models/quran_models.dart';
import '../../data/juz_data.dart';
import '../../services/bookmark_service.dart';
import '../../theme/app_theme.dart';
import '../surah_detail_screen.dart';

class QuranTabScreen extends ConsumerStatefulWidget {
  const QuranTabScreen({super.key});

  @override
  ConsumerState<QuranTabScreen> createState() => _QuranTabScreenState();
}

class _QuranTabScreenState extends ConsumerState<QuranTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<BookmarkModel> _bookmarks = [];
  LastReadModel? _lastRead;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookmarksAndHistory();
  }

  Future<void> _loadBookmarksAndHistory() async {
    final b = await BookmarkService.getBookmarks();
    final l = await BookmarkService.getLastRead();
    if (mounted) {
      setState(() {
        _bookmarks = b;
        _lastRead = l;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Al-Qur\'an Al-Karim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDarkSecondary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: context.textPrimary, fontSize: 14),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari surah atau terjemahan...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: context.primaryAdaptive),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 18, color: context.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              // TabBar: Surah, Juz, Bookmark, Terakhir Dibaca
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFE2B75A),
                indicatorWeight: 3,
                labelColor: const Color(0xFFE2B75A),
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Bookmark'),
                  Tab(text: 'Terakhir'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _searchQuery.isNotEmpty
          ? _buildSearchResults()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSurahTab(chaptersAsync),
                _buildJuzTab(chaptersAsync),
                _buildBookmarkTab(),
                _buildLastReadTab(),
              ],
            ),
    );
  }

  Widget _buildSearchResults() {
    final isDark = context.isDark;
    final searchAsync = ref.watch(searchQuranProvider(_searchQuery));

    return searchAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: context.textSecondary),
                const SizedBox(height: 12),
                Text(
                  'Tidak ditemukan hasil untuk "$_searchQuery"',
                  style: TextStyle(color: context.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final row = results[index];
            final surahNumber = row['surah_number'] as int;
            final verseNumber = row['verse_number'] as int;
            final surahLatin = row['surah_name_latin'] as String? ?? '';
            final translation = row['translation_id'] as String? ?? '';
            final latin = row['verse_latin'] as String? ?? '';

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahDetailScreen(
                      surahNumber: surahNumber,
                      surahName: surahLatin,
                    ),
                  ),
                ).then((_) => _loadBookmarksAndHistory());
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$surahLatin : $verseNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (latin.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        latin,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: context.latinColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      translation,
                      style: TextStyle(fontSize: 13, color: context.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: context.primaryAdaptive),
      ),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSurahTab(AsyncValue<List<Chapter>> chaptersAsync) {
    final isDark = context.isDark;

    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) {
          return Center(child: Text('Tidak ada data surah.', style: TextStyle(color: context.textSecondary)));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: chapters.length,
          separatorBuilder: (_, _) => Divider(height: 1, indent: 76, color: context.borderColor),
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2B75A).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2B75A).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    '${chapter.surahNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                    ),
                  ),
                ),
                title: Text(
                  chapter.surahNameLatin,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${chapter.revelationPlace.toUpperCase()} • ${chapter.numVerses} AYAT',
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
                trailing: Text(
                  chapter.surahName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.arabicColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(
                        surahNumber: chapter.surahNumber,
                        surahName: chapter.surahNameLatin,
                      ),
                    ),
                  ).then((_) => _loadBookmarksAndHistory());
                },
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: context.primaryAdaptive),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildJuzTab(AsyncValue<List<Chapter>> chaptersAsync) {
    final isDark = context.isDark;

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: JuzData.list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final juz = JuzData.list[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurahDetailScreen(
                  surahNumber: juz.startSurah,
                  surahName: juz.startSurahName,
                ),
              ),
            ).then((_) => _loadBookmarksAndHistory());
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${juz.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Juz ${juz.number}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mulai: ${juz.startSurahName} ayat ${juz.startVerse}',
                        style: TextStyle(fontSize: 12, color: context.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  juz.nameArabic,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE2B75A),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookmarkTab() {
    final isDark = context.isDark;

    if (_bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: context.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Belum ada ayat yang ditandai',
              style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Tekan ikon bookmark pada ayat untuk menyimpannya di sini',
              style: TextStyle(color: context.textSecondary, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final b = _bookmarks[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${b.surahNameLatin} : ${b.verseNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () async {
                      await BookmarkService.removeBookmark(b.surahNumber, b.verseNumber);
                      _loadBookmarksAndHistory();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Penanda ayat dihapus'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                b.arabicText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.8,
                  fontWeight: FontWeight.bold,
                  color: context.arabicColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                b.translation,
                style: TextStyle(fontSize: 13, color: context.textSecondary),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Buka Surah'),
                  style: TextButton.styleFrom(
                    foregroundColor: context.primaryAdaptive,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(
                          surahNumber: b.surahNumber,
                          surahName: b.surahNameLatin,
                        ),
                      ),
                    ).then((_) => _loadBookmarksAndHistory());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLastReadTab() {
    if (_lastRead == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: context.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Belum ada riwayat membaca',
              style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3A26), Color(0xFF1E5B3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time_filled, color: Color(0xFFE2B75A), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Terakhir Dibaca',
                      style: TextStyle(
                        color: Color(0xFFE2B75A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _lastRead!.surahNameLatin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ayat ke-${_lastRead!.verseNumber}',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2B75A),
                    foregroundColor: const Color(0xFF0F3A26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text(
                    'Lanjutkan Membaca',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(
                          surahNumber: _lastRead!.surahNumber,
                          surahName: _lastRead!.surahNameLatin,
                        ),
                      ),
                    ).then((_) => _loadBookmarksAndHistory());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
