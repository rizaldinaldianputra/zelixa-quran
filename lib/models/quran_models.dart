class Chapter {
  final int surahNumber;
  final String surahName;
  final String surahNameLatin;
  final String translation;
  final String revelationPlace;
  final int numVerses;

  Chapter({
    required this.surahNumber,
    required this.surahName,
    required this.surahNameLatin,
    required this.translation,
    required this.revelationPlace,
    required this.numVerses,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      surahNumber: map['surah_number'] as int,
      surahName: map['surah_name'] as String,
      surahNameLatin: map['surah_name_latin'] as String,
      translation: map['translation'] as String,
      revelationPlace: map['revelation_place'] as String,
      numVerses: map['num_verses'] as int,
    );
  }
}

class Verse {
  final int surahNumber;
  final int verseNumber;
  final String translationId;
  final String latin;
  final String audioUrl;
  final List<Word> words;

  Verse({
    required this.surahNumber,
    required this.verseNumber,
    required this.translationId,
    required this.latin,
    required this.audioUrl,
    this.words = const [],
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      surahNumber: map['surah_number'] as int,
      verseNumber: map['verse_number'] as int,
      translationId: map['translation_id'] as String,
      latin: map['latin'] as String,
      audioUrl: map['audio_url'] as String,
    );
  }

  Verse copyWith({List<Word>? words}) {
    return Verse(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      translationId: translationId,
      latin: latin,
      audioUrl: audioUrl,
      words: words ?? this.words,
    );
  }
}

class Word {
  final int wordIndex;
  final String wordKey;
  final String text;
  final String simpleText;
  final int surahNumber;
  final int verseNumber;
  final int lineNumber;
  final bool firstWord;
  final bool lastWord;

  Word({
    required this.wordIndex,
    required this.wordKey,
    required this.text,
    required this.simpleText,
    required this.surahNumber,
    required this.verseNumber,
    required this.lineNumber,
    required this.firstWord,
    required this.lastWord,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      wordIndex: map['word_index'] as int,
      wordKey: map['word_key'] as String,
      text: map['text'] as String,
      simpleText: map['simple_text'] as String,
      surahNumber: map['surah_number'] as int,
      verseNumber: map['verse_number'] as int,
      lineNumber: map['line_number'] as int,
      firstWord: (map['firstword'] as int) == 1,
      lastWord: (map['lastword'] as int) == 1,
    );
  }
}
