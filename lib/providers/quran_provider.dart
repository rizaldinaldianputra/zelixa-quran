import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_helper.dart';
import '../services/bookmark_service.dart';
import '../models/quran_models.dart';

final databaseHelperProvider = Provider<DatabaseHelper>(
  (ref) => DatabaseHelper.instance,
);

final databaseInitProvider = FutureProvider<void>((ref) async {
  final dbHelper = ref.read(databaseHelperProvider);
  await dbHelper.database;
});

final chaptersProvider = FutureProvider<List<Chapter>>((ref) async {
  await ref.watch(databaseInitProvider.future);
  final dbHelper = ref.read(databaseHelperProvider);
  return dbHelper.getChapters();
});

final surahVersesProvider = FutureProvider.family<List<Verse>, int>((
  ref,
  surahNumber,
) async {
  await ref.watch(databaseInitProvider.future);
  final dbHelper = ref.read(databaseHelperProvider);
  return dbHelper.getAllVerses(surahNumber);
});

final searchQuranProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      query,
    ) async {
      await ref.watch(databaseInitProvider.future);
      final dbHelper = ref.read(databaseHelperProvider);
      return dbHelper.searchQuran(query);
    });

final lastReadProvider = FutureProvider<LastReadModel?>((ref) async {
  return await BookmarkService.getLastRead();
});

final bookmarksProvider = FutureProvider<List<BookmarkModel>>((ref) async {
  return await BookmarkService.getBookmarks();
});
