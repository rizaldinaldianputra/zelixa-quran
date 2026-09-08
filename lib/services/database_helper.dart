import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/quran_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quran_lengkap_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    bool dbExists = await File(path).exists();

    if (!dbExists) {
      // First attempt to copy from local asset (offline instant load)
      bool copiedFromAsset = false;
      try {
        final byteData = await rootBundle.load('assets/quran_lengkap.db');
        final buffer = byteData.buffer;
        await File(path).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          flush: true,
        );
        copiedFromAsset = true;
      } catch (_) {
        copiedFromAsset = false;
      }

      // If asset copy wasn't available, download from remote
      if (!copiedFromAsset) {
        try {
          final dio = Dio();
          await dio.download(
            'https://raw.githubusercontent.com/rizaldinaldianputra/quran-data/edb7d81e9aba7f743d4a768e9b870a12ac7c2f21/quran_lengkap.db',
            path,
          );
        } catch (e) {
          throw Exception('Failed to initialize database: $e');
        }
      }
    }

    return await openDatabase(path, version: 1);
  }

  Future<List<Chapter>> getChapters() async {
    final db = await instance.database;
    final result = await db.query('chapters', orderBy: 'surah_number ASC');
    return result.map((json) => Chapter.fromMap(json)).toList();
  }

  Future<Chapter?> getChapter(int surahNumber) async {
    final db = await instance.database;
    final result = await db.query(
      'chapters',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Chapter.fromMap(result.first);
    }
    return null;
  }

  Future<List<Verse>> getVerses(
    int surahNumber, {
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await instance.database;
    final result = await db.query(
      'verses',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'verse_number ASC',
      limit: limit,
      offset: offset,
    );

    List<Verse> verses = [];
    for (var v in result) {
      Verse verse = Verse.fromMap(v);
      final wordsResult = await db.query(
        'words',
        where: 'surah_number = ? AND verse_number = ?',
        whereArgs: [surahNumber, verse.verseNumber],
        orderBy: 'word_index ASC',
      );
      List<Word> words = wordsResult.map((w) => Word.fromMap(w)).toList();
      verses.add(verse.copyWith(words: words));
    }

    return verses;
  }

  Future<List<Verse>> getAllVerses(int surahNumber) async {
    final db = await instance.database;
    final result = await db.query(
      'verses',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'verse_number ASC',
    );

    // Fetch all words for this surah in one fast query
    final wordsResult = await db.query(
      'words',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'word_index ASC',
    );

    final Map<int, List<Word>> wordsByVerse = {};
    for (var w in wordsResult) {
      final word = Word.fromMap(w);
      wordsByVerse.putIfAbsent(word.verseNumber, () => []).add(word);
    }

    List<Verse> verses = [];
    for (var v in result) {
      Verse verse = Verse.fromMap(v);
      verses.add(verse.copyWith(words: wordsByVerse[verse.verseNumber] ?? []));
    }

    return verses;
  }

  Future<Verse?> getSingleVerse(int surahNumber, int verseNumber) async {
    final db = await instance.database;
    final result = await db.query(
      'verses',
      where: 'surah_number = ? AND verse_number = ?',
      whereArgs: [surahNumber, verseNumber],
      limit: 1,
    );
    if (result.isEmpty) return null;

    final wordsResult = await db.query(
      'words',
      where: 'surah_number = ? AND verse_number = ?',
      whereArgs: [surahNumber, verseNumber],
      orderBy: 'word_index ASC',
    );
    final words = wordsResult.map((w) => Word.fromMap(w)).toList();
    return Verse.fromMap(result.first).copyWith(words: words);
  }

  Future<List<Map<String, dynamic>>> searchQuran(String query) async {
    if (query.trim().isEmpty) return [];
    final db = await instance.database;
    final clean = '%${query.trim()}%';

    final sql = '''
      SELECT v.surah_number, v.verse_number, v.translation_id, v.latin,
             c.surah_name, c.surah_name_latin
      FROM verses v
      JOIN chapters c ON v.surah_number = c.surah_number
      WHERE v.translation_id LIKE ? OR v.latin LIKE ? OR c.surah_name_latin LIKE ?
      ORDER BY v.surah_number ASC, v.verse_number ASC
      LIMIT 100
    ''';

    return await db.rawQuery(sql, [clean, clean, clean]);
  }
}
