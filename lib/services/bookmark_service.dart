import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadModel {
  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final String surahNameLatin;
  final DateTime timestamp;

  LastReadModel({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    required this.surahNameLatin,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'surahNumber': surahNumber,
    'verseNumber': verseNumber,
    'surahName': surahName,
    'surahNameLatin': surahNameLatin,
    'timestamp': timestamp.toIso8601String(),
  };

  factory LastReadModel.fromMap(Map<String, dynamic> map) => LastReadModel(
    surahNumber: map['surahNumber'] as int,
    verseNumber: map['verseNumber'] as int,
    surahName: map['surahName'] as String,
    surahNameLatin: map['surahNameLatin'] as String,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );
}

class BookmarkModel {
  final int surahNumber;
  final int verseNumber;
  final String surahNameLatin;
  final String arabicText;
  final String translation;
  final DateTime createdAt;

  BookmarkModel({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameLatin,
    required this.arabicText,
    required this.translation,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'surahNumber': surahNumber,
    'verseNumber': verseNumber,
    'surahNameLatin': surahNameLatin,
    'arabicText': arabicText,
    'translation': translation,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BookmarkModel.fromMap(Map<String, dynamic> map) => BookmarkModel(
    surahNumber: map['surahNumber'] as int,
    verseNumber: map['verseNumber'] as int,
    surahNameLatin: map['surahNameLatin'] as String,
    arabicText: map['arabicText'] as String,
    translation: map['translation'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}

class BookmarkService {
  static const String _keyLastRead = 'zelixa_last_read';
  static const String _keyBookmarks = 'zelixa_bookmarks';

  static Future<void> saveLastRead({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
    required String surahNameLatin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final model = LastReadModel(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      surahName: surahName,
      surahNameLatin: surahNameLatin,
      timestamp: DateTime.now(),
    );
    await prefs.setString(_keyLastRead, jsonEncode(model.toMap()));
  }

  static Future<LastReadModel?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLastRead);
    if (raw == null) return null;
    try {
      return LastReadModel.fromMap(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<List<BookmarkModel>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    return list
        .map((e) {
          try {
            return BookmarkModel.fromMap(jsonDecode(e));
          } catch (_) {
            return null;
          }
        })
        .whereType<BookmarkModel>()
        .toList();
  }

  static Future<bool> isBookmarked(int surahNumber, int verseNumber) async {
    final list = await getBookmarks();
    return list.any(
      (b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber,
    );
  }

  static Future<bool> toggleBookmark(BookmarkModel bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final index = bookmarks.indexWhere(
      (b) =>
          b.surahNumber == bookmark.surahNumber &&
          b.verseNumber == bookmark.verseNumber,
    );

    bool nowBookmarked = false;
    if (index >= 0) {
      bookmarks.removeAt(index);
      nowBookmarked = false;
    } else {
      bookmarks.insert(0, bookmark);
      nowBookmarked = true;
    }

    final rawList = bookmarks.map((b) => jsonEncode(b.toMap())).toList();
    await prefs.setStringList(_keyBookmarks, rawList);
    return nowBookmarked;
  }

  static Future<void> removeBookmark(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere(
      (b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber,
    );
    final rawList = bookmarks.map((b) => jsonEncode(b.toMap())).toList();
    await prefs.setStringList(_keyBookmarks, rawList);
  }
}
