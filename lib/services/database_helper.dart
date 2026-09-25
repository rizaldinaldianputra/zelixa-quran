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

  Future<QuranSearchResult> searchQuran(String query) async {
    final raw = query.trim();
    if (raw.isEmpty) return const QuranSearchResult();

    final db = await instance.database;
    final allChapters = await getChapters();

    // 1. Search matching chapters
    final matchingChapters = <Chapter>[];
    final normQuery = _normalizeSearch(raw);
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final queryNumber = digitsOnly.isNotEmpty ? int.tryParse(digitsOnly) : null;

    for (var ch in allChapters) {
      bool match = false;
      // Match surah number directly if query contains a number and user isn't searching specific verse
      if (queryNumber != null && ch.surahNumber == queryNumber && !raw.contains(':') && !raw.toLowerCase().contains('ayat')) {
        match = true;
      }
      // Match latin name normalized
      final normLatin = _normalizeSearch(ch.surahNameLatin);
      if (normLatin.contains(normQuery) || (normQuery.length >= 3 && normLatin.startsWith(normQuery))) {
        match = true;
      }
      // Match translation / Indonesian meaning
      final normTrans = _normalizeSearch(ch.translation);
      if (normTrans.contains(normQuery)) {
        match = true;
      }
      // Match Arabic name
      if (ch.surahName.contains(raw)) {
        match = true;
      }

      if (match && !matchingChapters.any((c) => c.surahNumber == ch.surahNumber)) {
        matchingChapters.add(ch);
      }
    }

    // 2. Check for verse reference (e.g. "2:255", "2 255", "surah 2 ayat 255", "albaqarah 255", "ayat kursi")
    final specificVerses = <Map<String, dynamic>>[];

    // Check "ayat kursi"
    if (normQuery.contains('kursi')) {
      final res = await _getVerseRow(db, 2, 255);
      if (res != null) specificVerses.add(res);
    }

    // Check pattern "surah:verse" or "surah verse" or "surah ayat verse"
    final refMatch = RegExp(
      r'^(?:surah|surat|qs|q\.s\.?)?\s*(\d+)\s*(?::|ayat\s*|\s+)\s*(\d+)$',
      caseSensitive: false,
    ).firstMatch(raw);

    if (refMatch != null) {
      final sNum = int.tryParse(refMatch.group(1)!);
      final vNum = int.tryParse(refMatch.group(2)!);
      if (sNum != null && vNum != null) {
        final res = await _getVerseRow(db, sNum, vNum);
        if (res != null && !specificVerses.any((r) => r['surah_number'] == sNum && r['verse_number'] == vNum)) {
          specificVerses.add(res);
        }
      }
    } else {
      // Check pattern like "al baqarah 255" or "baqarah: 255" or "yasin 1"
      final nameVerseMatch = RegExp(
        r'^(?:surah|surat)?\s*([a-zA-Z\s\-]+?)\s*(?::|ayat\s*|\s+)\s*(\d+)$',
        caseSensitive: false,
      ).firstMatch(raw);

      if (nameVerseMatch != null) {
        final sName = _normalizeSearch(nameVerseMatch.group(1)!);
        final vNum = int.tryParse(nameVerseMatch.group(2)!);
        if (vNum != null) {
          final matchedCh = allChapters.where((ch) {
            final n = _normalizeSearch(ch.surahNameLatin);
            return n == sName || n.contains(sName) || sName.contains(n);
          }).firstOrNull;
          if (matchedCh != null) {
            final res = await _getVerseRow(db, matchedCh.surahNumber, vNum);
            if (res != null && !specificVerses.any((r) => r['surah_number'] == matchedCh.surahNumber && r['verse_number'] == vNum)) {
              specificVerses.add(res);
            }
          }
        }
      }
    }

    // 3. Search matching verses
    final matchingVerses = <Map<String, dynamic>>[...specificVerses];

    // Check if query is Arabic
    final bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(raw);

    if (isArabic) {
      final cleanArabic = raw.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), ''); // remove harakat
      final sql = '''
        SELECT DISTINCT v.surah_number, v.verse_number, v.translation_id, v.latin,
               c.surah_name, c.surah_name_latin,
               (SELECT group_concat(text, ' ') FROM words w2 WHERE w2.surah_number = v.surah_number AND w2.verse_number = v.verse_number ORDER BY w2.word_index ASC) as arabic_text
        FROM words w
        JOIN verses v ON w.surah_number = v.surah_number AND w.verse_number = v.verse_number
        JOIN chapters c ON v.surah_number = c.surah_number
        WHERE w.text LIKE ? OR w.simple_text LIKE ?
        ORDER BY v.surah_number ASC, v.verse_number ASC
        LIMIT 60
      ''';
      final rows = await db.rawQuery(sql, ['%$raw%', '%$cleanArabic%']);
      for (var r in rows) {
        if (!matchingVerses.any((m) => m['surah_number'] == r['surah_number'] && m['verse_number'] == r['verse_number'])) {
          matchingVerses.add(r);
        }
      }
    } else {
      // Split into terms (ignoring small filler words if multiple words present)
      final terms = raw
          .toLowerCase()
          .replaceAll(RegExp(r"['’\-]"), '') // remove apostrophes and dashes
          .replaceAll(RegExp(r'[^\w\s]'), ' ')
          .split(RegExp(r'\s+'))
          .where((t) => t.isNotEmpty && t != 'surah' && t != 'surat' && t != 'ayat')
          .toList();

      if (terms.isNotEmpty) {
        final whereClauses = <String>[];
        final whereArgs = <dynamic>[];

        for (final t in terms) {
          whereClauses.add('(v.translation_id LIKE ? OR v.latin LIKE ?)');
          whereArgs.add('%$t%');
          whereArgs.add('%$t%');
        }

        final sql = '''
          SELECT v.surah_number, v.verse_number, v.translation_id, v.latin,
                 c.surah_name, c.surah_name_latin,
                 (SELECT group_concat(text, ' ') FROM words WHERE surah_number = v.surah_number AND verse_number = v.verse_number ORDER BY word_index ASC) as arabic_text
          FROM verses v
          JOIN chapters c ON v.surah_number = c.surah_number
          WHERE ${whereClauses.join(' AND ')}
          ORDER BY v.surah_number ASC, v.verse_number ASC
          LIMIT 100
        ''';

        final rows = await db.rawQuery(sql, whereArgs);
        for (var r in rows) {
          if (!matchingVerses.any((m) => m['surah_number'] == r['surah_number'] && m['verse_number'] == r['verse_number'])) {
            matchingVerses.add(r);
          }
        }
      }
    }

    return QuranSearchResult(
      chapters: matchingChapters,
      verses: matchingVerses,
    );
  }

  String _normalizeSearch(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'^(?:surah|surat|qs|q\.s\.?)\s*'), '')
        .replaceAll(RegExp(r"['`\-\s\.]"), '')
        .replaceAll('al', '')
        .replaceAll('sh', 'sy')
        .replaceAll('ts', 's')
        .replaceAll('dz', 'z')
        .replaceAll('dh', 'd')
        .replaceAll('th', 't')
        .replaceAll('aa', 'a')
        .replaceAll('ii', 'i')
        .replaceAll('uu', 'u');
  }

  Future<Map<String, dynamic>?> _getVerseRow(Database db, int surahNumber, int verseNumber) async {
    final sql = '''
      SELECT v.surah_number, v.verse_number, v.translation_id, v.latin,
             c.surah_name, c.surah_name_latin,
             (SELECT group_concat(text, ' ') FROM words WHERE surah_number = v.surah_number AND verse_number = v.verse_number ORDER BY word_index ASC) as arabic_text
      FROM verses v
      JOIN chapters c ON v.surah_number = c.surah_number
      WHERE v.surah_number = ? AND v.verse_number = ?
      LIMIT 1
    ''';
    final res = await db.rawQuery(sql, [surahNumber, verseNumber]);
    if (res.isNotEmpty) return res.first;
    return null;
  }
}
