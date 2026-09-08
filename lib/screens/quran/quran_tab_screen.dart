import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/quran_models.dart';
import '../../providers/quran_provider.dart';
import '../../services/bookmark_service.dart';
import '../../data/juz_data.dart';
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
    final lr = await BookmarkService.getLastRead();
    if (mounted) {
      setState(() {
        _bookmarks = b;
        _lastRead = lr;
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
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Al-Qur\'an Al-Karim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F3A26),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari surah atau terjemahan...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0F3A26)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
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
    final searchAsync = ref.watch(searchQuranProvider(_searchQuery));

    return searchAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'Tidak ditemukan ayat untuk "$_searchQuery"',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final row = results[index];
            final surahNumber = row['surah_number'] as int;
            final verseNumber = row['verse_number'] as int;
            final surahLatin = row['surah_name_latin'] as String? ?? 'Surah';
            final translation = row['translation_id'] as String? ?? '';
            final latin = row['latin'] as String? ?? '';

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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
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
                            color: const Color(0xFF0F3A26),
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      translation,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0F3A26)),
      ),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSurahTab(AsyncValue<List<Chapter>> chaptersAsync) {
    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) {
          return const Center(child: Text('Tidak ada data surah.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: chapters.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return ListTile(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F3A26),
                  ),
                ),
              ),
              title: Text(
                chapter.surahNameLatin,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              subtitle: Text(
                '${chapter.revelationPlace.toUpperCase()} • ${chapter.numVerses} AYAT',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Text(
                chapter.surahName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A26),
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
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0F3A26)),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildJuzTab(AsyncValue<List<Chapter>> chaptersAsync) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
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
                    color: const Color(0xFF0F3A26),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3A26),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mulai: ${juz.startSurahName} ayat ${juz.startVerse}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    if (_bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Belum ada ayat yang ditandai',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tekan ikon bookmark pada ayat untuk menyimpannya di sini',
              style: TextStyle(color: Colors.grey, fontSize: 12),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3A26),
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
                    },
                  ),
                ],
              ),
              if (b.arabicText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  b.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                b.translation,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Buka Surah'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0F3A26),
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
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Belum ada riwayat membaca',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
