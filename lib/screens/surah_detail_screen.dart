import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/quran_provider.dart';
import '../models/quran_models.dart';
import '../services/bookmark_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final int initialVerseIndex;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.initialVerseIndex = 0,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingVerse;
  bool _isPlaying = false;
  final Set<int> _bookmarkedVerses = {};

  double _fontSize = 24.0;
  bool _showLatin = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadBookmarks();
    _saveLastReadInitial();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingVerse = null;
          });
        }
      }
    });
  }

  Future<void> _loadSettings() async {
    final size = await SettingsService.getArabicFontSize();
    final latin = await SettingsService.getShowLatin();
    final trans = await SettingsService.getShowTranslation();
    if (mounted) {
      setState(() {
        _fontSize = size;
        _showLatin = latin;
        _showTranslation = trans;
      });
    }
  }

  Future<void> _saveLastReadInitial() async {
    await BookmarkService.saveLastRead(
      surahNumber: widget.surahNumber,
      verseNumber: widget.initialVerseIndex + 1,
      surahName: widget.surahName,
      surahNameLatin: widget.surahName,
    );
  }

  Future<void> _loadBookmarks() async {
    final list = await BookmarkService.getBookmarks();
    if (mounted) {
      setState(() {
        _bookmarkedVerses.clear();
        for (var b in list) {
          if (b.surahNumber == widget.surahNumber) {
            _bookmarkedVerses.add(b.verseNumber);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(int verseNumber, String? audioUrl) async {
    if (audioUrl == null || audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio tidak tersedia untuk ayat ini.')),
      );
      return;
    }

    if (_playingVerse == verseNumber && _isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      try {
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
        setState(() {
          _playingVerse = verseNumber;
          _isPlaying = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memutar audio: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleBookmark(Verse verse, String arabicText) async {
    final isBookmarked = _bookmarkedVerses.contains(verse.verseNumber);
    if (isBookmarked) {
      await BookmarkService.removeBookmark(
        widget.surahNumber,
        verse.verseNumber,
      );
      setState(() {
        _bookmarkedVerses.remove(verse.verseNumber);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penanda ayat dihapus'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      await BookmarkService.toggleBookmark(
        BookmarkModel(
          surahNumber: widget.surahNumber,
          verseNumber: verse.verseNumber,
          surahNameLatin: widget.surahName,
          arabicText: arabicText,
          translation: verse.translationId,
          createdAt: DateTime.now(),
        ),
      );
      setState(() {
        _bookmarkedVerses.add(verse.verseNumber);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ayat ditambahkan ke bookmark'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _copyVerse(Verse verse, String arabicText) {
    Clipboard.setData(
      ClipboardData(
        text:
            'QS. ${widget.surahName}: ${verse.verseNumber}\n\n$arabicText\n\n"${verse.translationId}"',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayat disalin ke papan klip'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final versesAsync = ref.watch(surahVersesProvider(widget.surahNumber));

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: 'Ukuran Font',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: context.cardColor,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ukuran Teks Arab',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                              Slider(
                                value: _fontSize,
                                min: 18.0,
                                max: 36.0,
                                divisions: 9,
                                label: '${_fontSize.toInt()}',
                                activeColor: context.primaryAdaptive,
                                onChanged: (val) {
                                  setModalState(() => _fontSize = val);
                                  setState(() => _fontSize = val);
                                  SettingsService.setArabicFontSize(val);
                                },
                              ),
                              SwitchListTile(
                                title: Text('Tampilkan Latin', style: TextStyle(color: context.textPrimary)),
                                value: _showLatin,
                                activeThumbColor: context.primaryAdaptive,
                                onChanged: (val) {
                                  setModalState(() => _showLatin = val);
                                  setState(() => _showLatin = val);
                                  SettingsService.setShowLatin(val);
                                },
                              ),
                              SwitchListTile(
                                title: Text('Tampilkan Terjemahan', style: TextStyle(color: context.textPrimary)),
                                value: _showTranslation,
                                activeThumbColor: context.primaryAdaptive,
                                onChanged: (val) {
                                  setModalState(() => _showTranslation = val);
                                  setState(() => _showTranslation = val);
                                  SettingsService.setShowTranslation(val);
                                },
                              ),
                            ],
                          ),
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
            return Center(child: Text('Tidak ada data ayat.', style: TextStyle(color: context.textSecondary)));
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
                    color: isDark
                        ? AppColors.cardDarkSecondary
                        : const Color(0xFF0F3A26).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2B75A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.arabicColor,
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
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
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
                        color: isDark
                            ? AppColors.cardDarkSecondary
                            : const Color(0xFF0F3A26).withValues(alpha: 0.06),
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
                              color: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
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
                              color: isThisPlaying
                                  ? const Color(0xFFE2B75A)
                                  : (isDark ? Colors.white70 : const Color(0xFF0F3A26)),
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
                                  : context.textSecondary,
                            ),
                            onPressed: () => _toggleBookmark(verse, arabicText),
                          ),
                          // Copy
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            color: context.textSecondary,
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
                                color: context.arabicColor,
                              ),
                            ),
                          const SizedBox(height: 12),
                          // Latin Transliteration
                          if (_showLatin && verse.latin.isNotEmpty) ...[
                            Text(
                              verse.latin,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: context.latinColor,
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
                                color: context.textSecondary,
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
        loading: () => Center(
          child: CircularProgressIndicator(color: context.primaryAdaptive),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
