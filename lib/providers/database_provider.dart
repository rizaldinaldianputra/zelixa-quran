import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// A state provider to track the download progress
final downloadProgressProvider = StateProvider<double>((ref) => 0.0);

// A state provider to track if initialization is complete
final isDatabaseInitializedProvider = StateProvider<bool>((ref) => false);

// A provider to fetch chapters
final chaptersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getChapters();
});

// A provider family to fetch words for a specific surah
final wordsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((
  ref,
  surahNumber,
) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getWords(surahNumber);
});
