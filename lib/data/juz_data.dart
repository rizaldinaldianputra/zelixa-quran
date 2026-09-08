class JuzInfo {
  final int number;
  final String nameArabic;
  final String nameLatin;
  final int startSurah;
  final int startVerse;
  final int endSurah;
  final int endVerse;
  final String startSurahName;

  const JuzInfo({
    required this.number,
    required this.nameArabic,
    required this.nameLatin,
    required this.startSurah,
    required this.startVerse,
    required this.endSurah,
    required this.endVerse,
    required this.startSurahName,
  });
}

class JuzData {
  static const List<JuzInfo> list = [
    JuzInfo(number: 1, nameArabic: 'آلم', nameLatin: 'Alif Lam Mim', startSurah: 1, startVerse: 1, endSurah: 2, endVerse: 141, startSurahName: 'Al-Fatihah'),
    JuzInfo(number: 2, nameArabic: 'سَيَقُولُ', nameLatin: 'Sayaqulu', startSurah: 2, startVerse: 142, endSurah: 2, endVerse: 252, startSurahName: 'Al-Baqarah'),
    JuzInfo(number: 3, nameArabic: 'تِلْكَ الرُّسُلُ', nameLatin: 'Tilkar Rusul', startSurah: 2, startVerse: 253, endSurah: 3, endVerse: 92, startSurahName: 'Al-Baqarah'),
    JuzInfo(number: 4, nameArabic: 'لَنْ تَنَالُوا', nameLatin: 'Lan Tana Lu', startSurah: 3, startVerse: 93, endSurah: 4, endVerse: 23, startSurahName: 'Ali \'Imran'),
    JuzInfo(number: 5, nameArabic: 'وَالْمُحْصَنَاتُ', nameLatin: 'Wal Muhsanat', startSurah: 4, startVerse: 24, endSurah: 4, endVerse: 147, startSurahName: 'An-Nisa\''),
    JuzInfo(number: 6, nameArabic: 'لَا يُحِبُّ اللَّهُ', nameLatin: 'La Yuhibbullah', startSurah: 4, startVerse: 148, endSurah: 5, endVerse: 81, startSurahName: 'An-Nisa\''),
    JuzInfo(number: 7, nameArabic: 'وَإِذَا سَمِعُوا', nameLatin: 'Wa Iza Sami\'u', startSurah: 5, startVerse: 82, endSurah: 6, endVerse: 110, startSurahName: 'Al-Ma\'idah'),
    JuzInfo(number: 8, nameArabic: 'وَلَوْ أَنَّنَا', nameLatin: 'Wa Lau Annana', startSurah: 6, startVerse: 111, endSurah: 7, endVerse: 87, startSurahName: 'Al-An\'am'),
    JuzInfo(number: 9, nameArabic: 'قَالَ الْمَلَأُ', nameLatin: 'Qalal Mala\'u', startSurah: 7, startVerse: 88, endSurah: 8, endVerse: 40, startSurahName: 'Al-A\'raf'),
    JuzInfo(number: 10, nameArabic: 'وَاعْلَمُوا', nameLatin: 'Wa\'lamu', startSurah: 8, startVerse: 41, endSurah: 9, endVerse: 92, startSurahName: 'Al-Anfal'),
    JuzInfo(number: 11, nameArabic: 'يَعْتَذِرُونَ', nameLatin: 'Ya\'tazirun', startSurah: 9, startVerse: 93, endSurah: 11, endVerse: 5, startSurahName: 'At-Taubah'),
    JuzInfo(number: 12, nameArabic: 'وَمَا مِنْ دَابَّةٍ', nameLatin: 'Wa Mamin Dabbah', startSurah: 11, startVerse: 6, endSurah: 12, endVerse: 52, startSurahName: 'Hud'),
    JuzInfo(number: 13, nameArabic: 'وَمَا أُبَرِّئُ', nameLatin: 'Wa Ma Ubarri\'u', startSurah: 12, startVerse: 53, endSurah: 14, endVerse: 52, startSurahName: 'Yusuf'),
    JuzInfo(number: 14, nameArabic: 'رُبَمَا', nameLatin: 'Rubama', startSurah: 15, startVerse: 1, endSurah: 16, endVerse: 128, startSurahName: 'Al-Hijr'),
    JuzInfo(number: 15, nameArabic: 'سُبْحَانَ الَّذِي', nameLatin: 'Subhanallazi', startSurah: 17, startVerse: 1, endSurah: 18, endVerse: 74, startSurahName: 'Al-Isra\''),
    JuzInfo(number: 16, nameArabic: 'قَالَ أَلَمْ', nameLatin: 'Qala Alam', startSurah: 18, startVerse: 75, endSurah: 20, endVerse: 135, startSurahName: 'Al-Kahf'),
    JuzInfo(number: 17, nameArabic: 'اقْتَرَبَ لِلنَّاسِ', nameLatin: 'Iqtaraba Lin Nasi', startSurah: 21, startVerse: 1, endSurah: 22, endVerse: 78, startSurahName: 'Al-Anbiya\''),
    JuzInfo(number: 18, nameArabic: 'قَدْ أَفْلَحَ', nameLatin: 'Qad Aflaha', startSurah: 23, startVerse: 1, endSurah: 25, endVerse: 20, startSurahName: 'Al-Mu\'minun'),
    JuzInfo(number: 19, nameArabic: 'وَقَالَ الَّذِينَ', nameLatin: 'Wa Qalal Lazina', startSurah: 25, startVerse: 21, endSurah: 27, endVerse: 55, startSurahName: 'Al-Furqan'),
    JuzInfo(number: 20, nameArabic: 'أَمَّنْ خَلَقَ', nameLatin: 'Amman Khalaq', startSurah: 27, startVerse: 56, endSurah: 29, endVerse: 45, startSurahName: 'An-Naml'),
    JuzInfo(number: 21, nameArabic: 'اتْلُ مَا أُوحِيَ', nameLatin: 'Utlu Ma Uhiya', startSurah: 29, startVerse: 46, endSurah: 33, endVerse: 30, startSurahName: 'Al-\'Ankabut'),
    JuzInfo(number: 22, nameArabic: 'وَمَنْ يَقْنُتْ', nameLatin: 'Wa Man Yaqnut', startSurah: 33, startVerse: 31, endSurah: 36, endVerse: 27, startSurahName: 'Al-Ahzab'),
    JuzInfo(number: 23, nameArabic: 'وَمَا أَنْزَلْنَا', nameLatin: 'Wa Maliya', startSurah: 36, startVerse: 28, endSurah: 39, endVerse: 31, startSurahName: 'Yasin'),
    JuzInfo(number: 24, nameArabic: 'فَمَنْ أَظْلَمُ', nameLatin: 'Faman Azlamu', startSurah: 39, startVerse: 32, endSurah: 41, endVerse: 46, startSurahName: 'Az-Zumar'),
    JuzInfo(number: 25, nameArabic: 'إِلَيْهِ يُرَدُّ', nameLatin: 'Ilaihi Yuraddu', startSurah: 41, startVerse: 47, endSurah: 45, endVerse: 37, startSurahName: 'Fussilat'),
    JuzInfo(number: 26, nameArabic: 'حم', nameLatin: 'Ha Mim', startSurah: 46, startVerse: 1, endSurah: 51, endVerse: 30, startSurahName: 'Al-Ahqaf'),
    JuzInfo(number: 27, nameArabic: 'قَالَ فَمَا خَطْبُكُمْ', nameLatin: 'Qala Fama Khatbukum', startSurah: 51, startVerse: 31, endSurah: 57, endVerse: 29, startSurahName: 'Az-Zariyat'),
    JuzInfo(number: 28, nameArabic: 'قَدْ سَمِعَ اللَّهُ', nameLatin: 'Qad Sami\'allah', startSurah: 58, startVerse: 1, endSurah: 66, endVerse: 12, startSurahName: 'Al-Mujadilah'),
    JuzInfo(number: 29, nameArabic: 'تَبَارَكَ الَّذِي', nameLatin: 'Tabarakallazi', startSurah: 67, startVerse: 1, endSurah: 77, endVerse: 50, startSurahName: 'Al-Mulk'),
    JuzInfo(number: 30, nameArabic: 'عَمَّ يَتَسَاءَلُونَ', nameLatin: '\'Amma Yatasa\'alun', startSurah: 78, startVerse: 1, endSurah: 114, endVerse: 6, startSurahName: 'An-Naba\''),
  ];
}
