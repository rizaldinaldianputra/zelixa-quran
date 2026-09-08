import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String _dbName = 'quran.db';
  static const String _downloadUrl = 'https://raw.githubusercontent.com/rizaldinaldianputra/quran-data/main/quran.db';
  Database? _db;

  Future<void> initDatabase(Function(double) onProgress) async {
    final dbPath = await _getDatabasePath();
    final exists = await File(dbPath).exists();

    if (!exists) {
      await _downloadDatabase(dbPath, onProgress);
    } else {
      onProgress(1.0); // Already downloaded
    }

    await _openDb(dbPath);
  }

  Future<String> _getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, _dbName);
  }

  Future<void> _downloadDatabase(String path, Function(double) onProgress) async {
    final dio = Dio();
    try {
      await dio.download(
        _downloadUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
    } catch (e) {
      throw Exception('Failed to download database: $e');
    }
  }

  Future<void> _openDb(String path) async {
    _db = await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getChapters() async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.query('chapters', orderBy: 'surah_number ASC');
  }

  Future<List<Map<String, dynamic>>> getWords(int surahNumber) async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.query(
      'words',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'verse_number ASC, word_index ASC',
    );
  }
}
