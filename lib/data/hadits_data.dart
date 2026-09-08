class HaditsItem {
  final int number;
  final String title;
  final String narrator;
  final String arabic;
  final String translation;

  const HaditsItem({
    required this.number,
    required this.title,
    required this.narrator,
    required this.arabic,
    required this.translation,
  });
}

class HaditsData {
  static const List<HaditsItem> arbain = [
    HaditsItem(
      number: 1,
      title: 'Niat Sebagai Penentu Amalan',
      narrator: 'HR. Bukhari & Muslim dari Umar bin Khattab r.a.',
      arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوِ امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ',
      translation: 'Sesungguhnya segala amalan tergantung pada niatnya, dan setiap orang akan mendapatkan balasan sesuai dengan apa yang diniatkannya. Barangsiapa hijrahnya karena Allah dan Rasul-Nya, maka hijrahnya kepada Allah dan Rasul-Nya. Dan barangsiapa hijrahnya karena urusan dunia yang ingin diraihnya atau karena wanita yang ingin dinikahinya, maka hijrahnya sesuai dengan niat hijrahnya tersebut.',
    ),
    HaditsItem(
      number: 2,
      title: 'Islam, Iman, dan Ihsan (Hadits Jibril)',
      narrator: 'HR. Muslim dari Umar bin Khattab r.a.',
      arabic: 'فَأَخْبِرْنِي عَنِ الإِسْلاَمِ؟ فَقَالَ رَسُولُ اللَّهِ ﷺ: الإِسْلاَمُ أَنْ تَشْهَدَ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَتُقِيمَ الصَّلاَةَ، وَتُؤْتِيَ الزَّكَاةَ، وَتَصُومَ رَمَضَانَ، وَتَحُجَّ الْبَيْتَ إِنِ اسْتَطَعْتَ إِلَيْهِ سَبِيلاً',
      translation: 'Jibril bertanya: Beritahukan kepadaku tentang Islam! Rasulullah ﷺ menjawab: Islam adalah engkau bersaksi bahwa tidak ada tuhan selain Allah dan Muhammad adalah utusan Allah, mendirikan shalat, menunaikan zakat, berpuasa di bulan Ramadhan, dan menunaikan haji ke Baitullah jika engkau mampu mengadakan perjalanan ke sana.',
    ),
    HaditsItem(
      number: 3,
      title: 'Rukun Islam',
      narrator: 'HR. Bukhari & Muslim dari Ibnu Umar r.a.',
      arabic: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ الْبَيْتِ، وَصَوْمِ رَمَضَانَ',
      translation: 'Islam dibangun di atas lima perkara: bersaksi bahwa tidak ada tuhan yang berhak disembah selain Allah dan sesungguhnya Muhammad adalah hamba dan utusan-Nya, mendirikan shalat, menunaikan zakat, haji ke Baitullah, dan puasa Ramadhan.',
    ),
    HaditsItem(
      number: 4,
      title: 'Penciptaan Manusia & Takdir',
      narrator: 'HR. Bukhari & Muslim dari Ibnu Mas\'ud r.a.',
      arabic: 'إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا نُطْفَةً، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ، ثُمَّ يُرْسَلُ إِلَيْهِ الْمَلَكُ فَيَنْفُخُ فِيهِ الرُّوحَ وَيُؤْمَرُ بِأَرْبَعِ كَلِمَاتٍ: بِكَتْبِ رِزْقِهِ وَأَجَلِهِ وَعَمَلِهِ وَشَقِيٌّ أَوْ سَعِيدٌ',
      translation: 'Sesungguhnya salah seorang di antara kalian dihimpun penciptaannya di dalam perut ibunya selama 40 hari berupa nuthfah (sperma), kemudian menjadi \'alaqah (gumpalan darah) semisal itu pula, kemudian menjadi mudhghah (segumpal daging) semisal itu pula, kemudian diutuslah malaikat kepadanya lalu ditiupkan ruh ke dalamnya dan diperintahkan mencatat empat perkara: rezekinya, ajalnya, amalnya, serta celaka atau bahagianya.',
    ),
    HaditsItem(
      number: 5,
      title: 'Larangan Berbuat Bid\'ah dalam Agama',
      narrator: 'HR. Bukhari & Muslim dari Ummul Mukminin Aisyah r.a.',
      arabic: 'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ',
      translation: 'Barangsiapa mengada-adakan perkara baru dalam urusan agama kami ini yang bukan bagian darinya, maka amalan tersebut tertolak.',
    ),
    HaditsItem(
      number: 6,
      title: 'Yang Halal dan Haram Sudah Jelas',
      narrator: 'HR. Bukhari & Muslim dari An-Nu\'man bin Basyir r.a.',
      arabic: 'إِنَّ الحَلاَلَ بَيِّنٌ وَإِنَّ الحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ لاَ يَعْلَمُهُنَّ كَثِيرٌ مِنَ النَّاسِ، فَمَنِ اتَّقَى الشُّبُهَاتِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ',
      translation: 'Sesungguhnya yang halal itu telah jelas dan yang haram pun telah jelas. Di antara keduanya ada perkara-perkara syubhat (samar) yang tidak diketahui oleh kebanyakan orang. Barangsiapa menjaga diri dari perkara syubhat, maka ia telah memelihara kesucian agama dan kehormatannya.',
    ),
    HaditsItem(
      number: 7,
      title: 'Agama Adalah Nasihat',
      narrator: 'HR. Muslim dari Tamim Ad-Dari r.a.',
      arabic: 'الدِّينُ النَّصِيحَةُ، قُلْنَا: لِمَنْ؟ قَالَ: لِلَّهِ وَلِكِتَابِهِ وَلِرَسُولِهِ وَلأَئِمَّةِ الْمُسْلِمِينَ وَعَامَّتِهِمْ',
      translation: 'Agama adalah nasihat. Kami bertanya: Untuk siapa wahai Rasulullah? Beliau bersabda: Untuk Allah, Kitab-Nya, Rasul-Nya, para pemimpin kaum muslimin, dan segenap kaum muslimin pada umumnya.',
    ),
    HaditsItem(
      number: 8,
      title: 'Menjaga Lisan atau Diam',
      narrator: 'HR. Bukhari & Muslim dari Abu Hurairah r.a.',
      arabic: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيُكْرِمْ جَارَهُ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيُكْرِمْ ضَيْفَهُ',
      translation: 'Barangsiapa beriman kepada Allah dan hari akhir, hendaklah ia berkata yang baik atau diam. Dan barangsiapa beriman kepada Allah dan hari akhir, hendaklah ia memuliakan tetangganya. Dan barangsiapa beriman kepada Allah dan hari akhir, hendaklah ia memuliakan tamunya.',
    ),
    HaditsItem(
      number: 9,
      title: 'Jangan Marah',
      narrator: 'HR. Bukhari dari Abu Hurairah r.a.',
      arabic: 'أَنَّ رَجُلاً قَالَ لِلنَّبِيِّ ﷺ: أَوْصِنِي، قَالَ: لاَ تَغْضَبْ. فَرَدَّدَ مِرَارًا، قَالَ: لاَ تَغْضَبْ',
      translation: 'Bahwa ada seorang laki-laki berkata kepada Nabi ﷺ: Berilah aku wasiat! Beliau bersabda: Janganlah engkau marah. Orang itu mengulangi permintaannya beberapa kali, dan Nabi ﷺ tetap bersabda: Janganlah engkau marah.',
    ),
    HaditsItem(
      number: 10,
      title: 'Mencintai Saudara Seperti Mencintai Diri Sendiri',
      narrator: 'HR. Bukhari & Muslim dari Anas bin Malik r.a.',
      arabic: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      translation: 'Tidaklah beriman seseorang di antara kalian sampai ia mencintai bagi saudaranya apa yang ia cintai bagi dirinya sendiri.',
    ),
  ];
}
