import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../models/quran_models.dart';
import '../providers/quran_provider.dart';
import '../services/bookmark_service.dart';
import '../services/settings_service.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  late AudioPlayer _audioPlayer;
  int? _playingVerse;
  bool _isPlaying = false;
  double _fontSize = 24.0;
  bool _showLatin = true;
  bool _showTranslation = true;
  final Set<int> _bookmarkedVerses = {};

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing && state.processingState != ProcessingState.completed;
          if (state.processingState == ProcessingState.completed) {
            _playingVerse = null;
          }
        });
      }
    });

    _loadSettingsAndBookmarks();
    _recordLastRead(1);
  }

  Future<void> _loadSettingsAndBookmarks() async {
    final size = await SettingsService.getArabicFontSize();
    final latin = await SettingsService.getShowLatin();
    final trans = await SettingsService.getShowTranslation();
    final bookmarks = await BookmarkService.getBookmarks();

    if (mounted) {
      setState(() {
        _fontSize = size;
        _showLatin = latin;
        _showTranslation = trans;
        for (var b in bookmarks) {
          if (b.surahNumber == widget.surahNumber) {
            _bookmarkedVerses.add(b.verseNumber);
          }
        }
      });
    }
  }

  Future<void> _recordLastRead(int verseNumber) async {
    await BookmarkService.saveLastRead(
      surahNumber: widget.surahNumber,
      verseNumber: verseNumber,
      surahName: widget.surahName,
      surahNameLatin: widget.surahName,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(int verseNumber, String audioUrl) async {
    try {
      if (_playingVerse == verseNumber && _isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _playingVerse = verseNumber;
          _isPlaying = true;
        });
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memutar audio: $e')),
        );
      }
    }
  }

  Future<void> _toggleBookmark(Verse verse, String arabicText) async {
    final bookmark = BookmarkModel(
      surahNumber: widget.surahNumber,
      verseNumber: verse.verseNumber,
      surahNameLatin: widget.surahName,
      arabicText: arabicText,
      translation: verse.translationId,
      createdAt: DateTime.now(),
    );

    final result = await BookmarkService.toggleBookmark(bookmark);
    setState(() {
      if (result) {
        _bookmarkedVerses.add(verse.verseNumber);
      } else {
        _bookmarkedVerses.remove(verse.verseNumber);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result
                ? 'Ayat ${verse.verseNumber} berhasil disimpan ke Bookmark'
                : 'Bookmark ayat ${verse.verseNumber} dihapus',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _copyVerse(Verse verse, String arabicText) {
    final text =
        '$arabicText\n\n"${verse.latin}"\n\nArtinya: ${verse.translationId}\n(QS. ${widget.surahName}: ${verse.verseNumber})';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayat disalin ke papan klip'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final versesAsync = ref.watch(surahVersesProvider(widget.surahNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: 'Ukuran Font',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ukuran Teks Arab',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Slider(
                              value: _fontSize,
                              min: 18.0,
                              max: 36.0,
                              divisions: 9,
                              label: '${_fontSize.toInt()}',
                              activeColor: const Color(0xFF0F3A26),
                              onChanged: (val) {
                                setModalState(() => _fontSize = val);
                                setState(() => _fontSize = val);
                                SettingsService.setArabicFontSize(val);
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Tampilkan Latin'),
                              value: _showLatin,
                              activeThumbColor: const Color(0xFF0F3A26),
                              onChanged: (val) {
                                setModalState(() => _showLatin = val);
                                setState(() => _showLatin = val);
                                SettingsService.setShowLatin(val);
                              },
                            ),
                            SwitchListTile(
                              title: const Text('Tampilkan Terjemahan'),
                              value: _showTranslation,
                              activeThumbColor: const Color(0xFF0F3A26),
                              onChanged: (val) {
                                setModalState(() => _showTranslation = val);
                                setState(() => _showTranslation = val);
                                SettingsService.setShowTranslation(val);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: versesAsync.when(
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(child: Text('Tidak ada data ayat.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: verses.length + 1, // +1 for Bismillah banner
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header Bismillah
                if (widget.surahNumber == 1 || widget.surahNumber == 9) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3A26).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2B75A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F3A26),
                      ),
                    ),
                  ),
                );
              }

              final verse = verses[index - 1];
              final arabicText = verse.words.isNotEmpty
                  ? verse.words.map((w) => w.text).join(' ')
                  : '';
              final isBookmarked = _bookmarkedVerses.contains(verse.verseNumber);
              final isThisPlaying =
                  _playingVerse == verse.verseNumber && _isPlaying;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Action Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3A26).withValues(alpha: 0.06),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F3A26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${widget.surahNumber}:${verse.verseNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Play Audio
                          IconButton(
                            icon: Icon(
                              isThisPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_outline,
                              color: const Color(0xFF0F3A26),
                            ),
                            onPressed: () => _playAudio(
                              verse.verseNumber,
                              verse.audioUrl,
                            ),
                          ),
                          // Bookmark
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked
                                  ? const Color(0xFFE2B75A)
                                  : Colors.grey[700],
                            ),
                            onPressed: () => _toggleBookmark(verse, arabicText),
                          ),
                          // Copy
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            color: Colors.grey[700],
                            onPressed: () => _copyVerse(verse, arabicText),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Arabic text
                          if (arabicText.isNotEmpty)
                            Text(
                              arabicText,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: _fontSize,
                                height: 2.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          const SizedBox(height: 12),
                          // Latin Transliteration
                          if (_showLatin && verse.latin.isNotEmpty) ...[
                            Text(
                              verse.latin,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF059669),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          // Translation
                          if (_showTranslation &&
                              verse.translationId.isNotEmpty) ...[
                            Text(
                              verse.translationId,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF0F3A26)),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
