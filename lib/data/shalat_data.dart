import '../models/shalat_model.dart';

class ShalatData {
  // ==========================================
  // 1. TATA CARA & GERAKAN SHALAT STEP-BY-STEP
  // ==========================================
  static const List<GerakanShalatItem> gerakanShalatList = [
    GerakanShalatItem(
      order: 1,
      name: 'Berdiri Tegak Menghadap Kiblat (Qiyam)',
      description:
          'Berdiri tegak menghadap kiblat dengan pandangan mengarah ke tempat sujud. Meluruskan dan merapatkan shaf jika shalat berjamaah, serta berniat shalat di dalam hati berbarengan dengan Takbiratul Ihram.',
      imageAsset: 'assets/shalat/shalat_takbir.jpg',
      arabic: 'قَدْ أَفْلَحَ الْمُؤْمِنُونَ الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ',
      latin: 'Qad aflahal-mu’minuun, alladziina hum fii shalaatihim khaasyi’uun',
      translation:
          'Sungguh beruntung orang-orang yang beriman, (yaitu) orang yang khusyuk dalam shalatnya. (QS. Al-Mu’minun: 1-2)',
      tips:
          'Badan tegak relaks, kedua telapak kaki dibuka sejajar selebar bahu, dan jari-jari kaki mengarah ke kiblat.',
    ),
    GerakanShalatItem(
      order: 2,
      name: 'Takbiratul Ihram',
      description:
          'Mengangkat kedua tangan sejajar dengan bahu atau daun telinga dengan jari-jari direnggangkan sedikit dan telapak tangan menghadap kiblat seraya mengucap Takbir.',
      imageAsset: 'assets/shalat/shalat_takbir.jpg',
      arabic: 'اللهُ أَكْبَرُ',
      latin: 'Allahu Akbar',
      translation: 'Allah Maha Besar.',
      tips:
          'Saat takbir diucapkan secara lisan, hati menyatukan niat shalat yang sedang ditunaikan (Rukun Shalat).',
    ),
    GerakanShalatItem(
      order: 3,
      name: 'Bersedekap & Membaca Doa Iftitah',
      description:
          'Meletakkan tangan kanan di atas punggung telapak tangan kiri, pergelangan tangan, atau lengan di atas dada atau di bawah dada di atas pusar. Disunnahkan membaca Doa Iftitah.',
      imageAsset: 'assets/shalat/shalat_sedekap.jpg',
      arabic:
          'اللهُ أَكْبَرُ كَبِيْرًا، وَالْحَمْدُ لِلّٰهِ كَثِيْرًا، وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيْلًا. إِنِّيْ وَجَّهْتُ وَجْهِيَ لِلَّذِيْ فَطَرَ السَّمَاوَاتِ وَالْأَرْضَ حَنِيْفًا مُسْلِمًا وَمَا أَنَا مِنَ الْمُشْرِكِيْنَ، إِنَّ صَلَاتِيْ وَنُسُكِيْ وَمَحْيَايَ وَمَمَاتِيْ لِلّٰهِ رَبِّ الْعَالَمِيْنَ، لَا شَرِيْكَ لَهُ وَبِذٰلِكَ أُمِرْتُ وَأَنَا مِنَ الْمُسْلِمِيْنَ',
      latin:
          'Allahu akbaru kabiiraa, walhamdu lillaahi katsiiraa, wa subhaanallaahi bukratan wa ashiilaa. Innii wajjahtu wajhiya lilladzii fatharas-samaawaati wal ardha haniifan musliman wa maa ana minal musyrikiin. Inna shalaatii wa nusukii wa mahyaaya wa mamaatii lillaahi rabbil ‘aalamiin. Laa syariika lahu wa bidzaalika umirtu wa ana minal muslimiin.',
      translation:
          'Allah Maha Besar dengan sebesar-besarnya, segala puji bagi Allah dengan pujian yang banyak, dan Maha Suci Allah sepanjang pagi dan petang. Sesungguhnya aku hadapkan wajahku kepada Dzat yang menciptakan langit dan bumi dengan keadaan lurus lagi berserah diri, dan aku bukanlah dari golongan musyrik. Sesungguhnya shalatku, ibadahku, hidupku, dan matiku hanyalah untuk Allah Tuhan semesta alam. Tidak ada sekutu bagi-Nya dan dengan itulah aku diperintahkan dan aku termasuk orang-orang yang berserah diri.',
      tips:
          'Doa Iftitah dibaca pelan (sirr) setelah Takbiratul Ihram pada rakaat pertama sebelum membaca ta’awwudz.',
    ),
    GerakanShalatItem(
      order: 4,
      name: 'Membaca Al-Fatihah & Surah Pendek',
      description:
          'Membaca Surat Al-Fatihah yang merupakan rukun shalat (wajib dibaca di setiap rakaat), lalu disunnahkan membaca surah atau ayat Al-Qur’an pada rakaat pertama dan kedua.',
      imageAsset: 'assets/shalat/shalat_sedekap.jpg',
      arabic:
          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ (١) اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ (٢) الرَّحْمٰنِ الرَّحِيْمِ (٣) مٰلِكِ يَوْمِ الدِّيْنِ (٤) إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِيْنُ (٥) اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَ (٦) صِرَاطَ الَّذِيْنَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّآلِّيْنَ (٧)',
      latin:
          'Bismillaahir-rahmaanir-rahiim. Alhamdulillaahi rabbil ‘aalamiin. Ar-rahmaanir-rahiim. Maaliki yaumid-diin. Iyyaaka na’budu wa iyyaaka nasta’iin. Ihdinash-shiraathal mustaqiim. Shiraathalladziina an’amta ‘alaihim ghairil maghdhuubi ‘alaihim waladh-dhaalliin.',
      translation:
          'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang. Segala puji bagi Allah, Tuhan seluruh alam. Yang Maha Pengasih, Maha Penyayang. Pemilik hari pembalasan. Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan. Tunjukilah kami jalan yang lurus. (Yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya, bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.',
      tips:
          'Setelah ayat terakhir selesai dibaca, sunnah mengucapkan "Aamiin" (semoga Allah mengabulkan).',
    ),
    GerakanShalatItem(
      order: 5,
      name: 'Ruku’ dengan Thuma’ninah',
      description:
          'Mengangkat kedua tangan seraya bertakbir, lalu membungkukkan badan hingga punggung dan kepala rata sejajar, kedua tangan memegang lutut dengan jari-jari renggang, dan berhenti tenang sejenak (thuma’ninah).',
      imageAsset: 'assets/shalat/shalat_ruku.jpg',
      arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيْمِ وَبِحَمْدِهِ (٣×)',
      latin: 'Subhaana rabbiyal ‘azhiimi wa bihamdih (3x)',
      translation: 'Maha Suci Tuhanku Yang Maha Agung dan dengan memuji-Nya. (Dibaca 3 kali)',
      tips:
          'Punggung harus lurus sedemikian rupa sehingga jika ditaruh bejana berisi air di atasnya tidak akan tumpah.',
    ),
    GerakanShalatItem(
      order: 6,
      name: 'I’tidal (Bangkit dari Ruku’)',
      description:
          'Bangkit dari ruku’ seraya mengangkat kedua tangan sejajar bahu atau telinga seraya membaca tasmi’ (Sami’allahu liman hamidah), lalu berdiri tegak lurus seraya membaca tahmid.',
      imageAsset: 'assets/shalat/shalat_itidal.jpg',
      arabic: 'رَبَّنَا لَكَ الْحَمْدُ مِلْءَ السَّمَاوَاتِ وَمِلْءَ الْأَرْضِ وَمِلْءَ مَا شِئْتَ مِنْ شَيْءٍ بَعْدُ',
      latin: 'Rabbanaa lakal hamdu mil’us-samaawaati wa mil’ul ardhi wa mil’u maa syi’ta min syai’in ba’du.',
      translation:
          'Wahai Tuhan kami, bagi-Mu lah segala puji, sepenuh langit dan sepenuh bumi, serta sepenuh apa saja yang Engkau kehendaki sesudah itu.',
      tips:
          'Wajib thuma’ninah (diam sejenak hingga seluruh persendian kembali tegak lurus dan tenang).',
    ),
    GerakanShalatItem(
      order: 7,
      name: 'Sujud Pertama',
      description:
          'Bertakbir (tanpa mengangkat tangan) lalu turun bersujud dengan 7 anggota tubuh: dahi dan hidung menempel sajadah, kedua telapak tangan terbuka menghadap kiblat sejajar bahu/telinga, kedua lutut, dan ujung jari-jari kedua kaki ditekuk menghadap kiblat.',
      imageAsset: 'assets/shalat/shalat_sujud.jpg',
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ (٣×)',
      latin: 'Subhaana rabbiyal a’laa wa bihamdih (3x)',
      translation: 'Maha Suci Tuhanku Yang Maha Tinggi dan dengan memuji-Nya. (Dibaca 3 kali)',
      tips:
          'Siku tangan diangkat tidak menempel ke lantai, dan perut tidak menempel ke paha bagi laki-laki. Sujud adalah posisi terdekat seorang hamba dengan Allah.',
    ),
    GerakanShalatItem(
      order: 8,
      name: 'Duduk Antara Dua Sujud (Iftirasy)',
      description:
          'Bangkit dari sujud seraya bertakbir, lalu duduk iftirasy (menduduki telapak kaki kiri yang dibentangkan, sedangkan telapak kaki kanan ditegakkan dengan jari-jari menghadap kiblat). Kedua tangan diletakkan di atas paha dekat lutut.',
      imageAsset: 'assets/shalat/shalat_duduk.jpg',
      arabic: 'رَبِّ اغْفِرْ لِيْ وَارْحَمْنِيْ وَاجْبُرْنِيْ وَارْفَعْنِيْ وَارْزُقْنِيْ وَاهْدِنِيْ وَعَافِنِيْ وَاعْفُ عَنِّيْ',
      latin:
          'Rabbighfirlii warhamnii wajburnii warfa’nii warzuqnii wahdinii wa’aafinii wa’fu ‘annii.',
      translation:
          'Ya Tuhanku, ampunilah aku, sayangilah aku, cukupkanlah kekuranganku, tinggikanlah derajatku, berilah aku rezeki, berilah aku petunjuk, sehatkanlah badanku, dan maafkanlah kesalahanku.',
      tips:
          'Pastikan duduk dengan tenang (thuma’ninah) sebelum bersujud untuk kedua kalinya.',
    ),
    GerakanShalatItem(
      order: 9,
      name: 'Sujud Kedua & Bangkit Rakaat Selanjutnya',
      description:
          'Bertakbir dan melakukan sujud kedua persis seperti sujud pertama, membaca tasbih sujud 3 kali, lalu bertakbir bangkit untuk berdiri tegak memulai rakaat berikutnya (atau duduk tasyahhud).',
      imageAsset: 'assets/shalat/shalat_sujud.jpg',
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ (٣×)',
      latin: 'Subhaana rabbiyal a’laa wa bihamdih (3x)',
      translation: 'Maha Suci Tuhanku Yang Maha Tinggi dan dengan memuji-Nya. (Dibaca 3 kali)',
      tips:
          'Disunnahkan duduk istirahat sejenak sebelum bangkit berdiri menuju rakaat berikutnya.',
    ),
    GerakanShalatItem(
      order: 10,
      name: 'Duduk Tasyahhud / Tahiyyat Awal',
      description:
          'Dilakukan pada rakaat kedua pada shalat 3 atau 4 rakaat. Duduk iftirasy, tangan kiri di atas paha kiri, tangan kanan menggenggam jari-jari kecuali jari telunjuk yang diacungkan saat membaca syahadat.',
      imageAsset: 'assets/shalat/shalat_tahiyyat_awal.jpg',
      arabic:
          'التَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلّٰهِ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللّٰهِ الصَّالِحِيْنَ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُوْلُ اللّٰهِ. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ',
      latin:
          'Attahiyyaatul mubaarakaatush shalawaatuth thayyibaatu lillaah. Assalaamu ‘alaika ayyuhan-nabiyyu wa rahmatullaahi wa barakaatuh. Assalaamu ‘alainaa wa ‘alaa ‘ibaadillaahish-shaalihiin. Asyhadu allaa ilaaha illallaah wa asyhadu anna Muhammadar rasuulullaah. Allaahumma shalli ‘alaa sayyidinaa Muhammad.',
      translation:
          'Segala penghormatan yang penuh berkah, shalawat dan kebaikan adalah milik Allah. Semoga keselamatan, rahmat Allah dan berkah-Nya tercurah kepadamu wahai Nabi. Semoga keselamatan tercurah kepada kami dan hamba-hamba Allah yang saleh. Aku bersaksi bahwa tiada tuhan selain Allah dan aku bersaksi bahwa Muhammad utusan Allah. Ya Allah, limpahkanlah rahmat kepada junjungan kami Nabi Muhammad.',
      tips:
          'Jari telunjuk tangan kanan diacungkan ke arah kiblat saat mengucap kalimat "illallaah".',
    ),
    GerakanShalatItem(
      order: 11,
      name: 'Duduk Tasyahhud / Tahiyyat Akhir & Shalawat',
      description:
          'Duduk tawarruk pada rakaat terakhir (kaki kiri dimasukkan di bawah kaki kanan, telapak kaki kanan ditegakkan, dan pantat langsung menyentuh lantai). Membaca Tasyahhud lengkap beserta Shalawat Ibrahimiyah.',
      imageAsset: 'assets/shalat/shalat_tahiyyat_akhir.jpg',
      arabic:
          'التَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلّٰهِ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللّٰهِ الصَّالِحِيْنَ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُوْلُ اللّٰهِ. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيْمَ، وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى سَيِّدِنَا إِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيْمَ، فِي الْعَالَمِيْنَ إِنَّكَ حَمِيْدٌ مَجِيْدٌ',
      latin:
          'Attahiyyaatul mubaarakaatush shalawaatuth thayyibaatu lillaah. Assalaamu ‘alaika ayyuhan-nabiyyu wa rahmatullaahi wa barakaatuh. Assalaamu ‘alainaa wa ‘alaa ‘ibaadillaahish-shaalihiin. Asyhadu allaa ilaaha illallaah wa asyhadu anna Muhammadar rasuulullaah. Allaahumma shalli ‘alaa sayyidinaa Muhammad wa ‘alaa aali sayyidinaa Muhammad, kamaa shallaita ‘alaa sayyidinaa Ibraahiim wa ‘alaa aali sayyidinaa Ibraahiim, wa baarik ‘alaa sayyidinaa Muhammad wa ‘alaa aali sayyidinaa Muhammad, kamaa baarakta ‘alaa sayyidinaa Ibraahiim wa ‘alaa aali sayyidinaa Ibraahiim, fil ‘aalamiina innaka hamiidum majiid.',
      translation:
          'Segala kehormatan, keberkahan, shalawat dan kebaikan adalah milik Allah. Salam sejahtera untukmu wahai Nabi, beserta rahmat Allah dan berkah-Nya. Salam sejahtera untuk kami dan untuk hamba-hamba Allah yang saleh. Aku bersaksi tidak ada tuhan selain Allah dan aku bersaksi bahwa Muhammad utusan Allah. Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan keluarganya, sebagaimana Engkau telah melimpahkan rahmat kepada Nabi Ibrahim dan keluarganya. Dan berkahilah Nabi Muhammad dan keluarganya, sebagaimana Engkau memberkahi Nabi Ibrahim dan keluarganya. Di seluruh alam semesta, sesungguhnya Engkau Maha Terpuji lagi Maha Mulia.',
      tips:
          'Setelah shalawat, disunnahkan membaca doa perlindungan dari empat perkara (siksa neraka Jahanam, siksa kubur, fitnah kehidupan dan kematian, serta fitnah Dajjal).',
    ),
    GerakanShalatItem(
      order: 12,
      name: 'Mengucapkan Salam (Penutup Shalat)',
      description:
          'Menolehkan wajah ke arah kanan hingga pipi terlihat dari belakang seraya mengucapkan salam, kemudian menolehkan wajah ke arah kiri seraya mengucapkan salam yang kedua.',
      imageAsset: 'assets/shalat/shalat_salam.jpg',
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ',
      latin: 'Assalaamu ‘alaikum wa rahmatullaahi wa barakaatuh',
      translation: 'Semoga keselamatan, rahmat Allah, dan berkah-Nya tercurah kepada kalian.',
      tips:
          'Salam pertama ke kanan adalah rukun shalat (wajib). Salam kedua ke kiri adalah sunnah muakkad.',
    ),
  ];

  // ==========================================
  // 2. SHALAT FARDHU (5 WAKTU & JUM'AT)
  // ==========================================
  static const List<ShalatItem> shalatFardhuList = [
    ShalatItem(
      id: 'subuh',
      name: 'Shalat Subuh',
      category: 'fardhu',
      rakaat: 2,
      hukum: 'Fardhu ‘Ain (Wajib)',
      waktu: 'Mulai terbit fajar shadiq hingga sesaat sebelum piringan matahari terbit',
      description:
          'Shalat fardhu dua rakaat yang dikerjakan pada waktu fajar. Disunnahkan membaca doa Qunut pada rakaat kedua setelah i’tidal menurut Mazhab Syafi’i.',
      niatArab: 'أُصَلِّي فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhash-shubhi rak’ataini mustaqbilal qiblati adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Subuh dua rakaat menghadap kiblat tepat pada waktunya karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhash-shubhi rak’ataini mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Subuh dua rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      niatMakmumArab: 'أُصَلِّي فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatMakmumLatin: 'Ushallii fardhash-shubhi rak’ataini mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatMakmumArti: 'Aku berniat shalat fardhu Subuh dua rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa yang menunaikan shalat Subuh berjamaah, maka ia berada dalam jaminan dan perlindungan Allah Subhanahu wa Ta’ala (HR. Muslim).',
      tataCara: [
        'Rakaat Pertama: Niat & Takbiratul Ihram, Doa Iftitah, Al-Fatihah, Surah Pendek, Ruku’ thuma’ninah, I’tidal thuma’ninah, Sujud 1, Duduk antara dua sujud, Sujud 2, lalu bangkit ke rakaat kedua.',
        'Rakaat Kedua: Membaca Al-Fatihah, Surah Pendek, Ruku’ thuma’ninah, I’tidal lalu membaca Doa Qunut (sunnah).',
        'Sujud 1, Duduk antara dua sujud, Sujud 2, lalu Duduk Tasyahhud Akhir & membaca Shalawat Ibrahimiyah.',
        'Mengucapkan Salam ke kanan dan ke kiri.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ اهْدِنِيْ فِيْمَنْ هَدَيْتَ، وَعَافِنِيْ فِيْمَنْ عَافَيْتَ، وَتَوَلَّنِيْ فِيْمَنْ تَوَلَّيْتَ، وَبَارِكْ لِيْ فِيْمَا أَعْطَيْتَ، وَقِنِيْ شَرَّ مَا قَضَيْتَ، فَإِنَّكَ تَقْضِيْ وَلَا يُقْضَى عَلَيْكَ، وَإِنَّهُ لَا يَذِلُّ مَنْ وَالَيْتَ، وَلَا يَعِزُّ مَنْ عَادَيْتَ، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ، فَلَكَ الْحَمْدُ عَلَى مَا قَضَيْتَ، أَسْتَغْفِرُكَ وَأَتُوْبُ إِلَيْكَ، وَصَلَّى اللّٰهُ عَلَى سَيِّدِنَا مُحَمَّدٍ النَّبِيِّ الْأُمِّيِّ وَعَلَى آلِهِ وَصَحْبِهِ وَسَلَّمَ',
      doaKhususLatin:
          'Allaahummah-dinii fiiman hadait, wa ‘aafinii fiiman ‘aafait, wa tawallanii fiiman tawallait, wa baarik lii fiimaa a’thait, wa qinii syarra maa qadhait, fa innaka taqdhii wa laa yuqdhaa ‘alaik, wa innahu laa yadzillu man waalait, wa laa ya’izzu man ‘aadait, tabaarakta rabbanaa wa ta’aalait, falakal hamdu ‘alaa maa qadhait, astaghfiruka wa atuubu ilaik, wa shallallaahu ‘alaa sayyidinaa Muhammadin-nabiyyil ummiyyi wa ‘alaa aalihi wa shahbihii wa sallam.',
      doaKhususArti:
          'Ya Allah berilah aku petunjuk sebagaimana orang yang telah Engkau beri petunjuk, berilah aku keselamatan sebagaimana orang yang telah Engkau beri keselamatan, peliharalah aku sebagaimana orang yang telah Engkau pelihara, berkahilah bagiku pada apa yang telah Engkau karuniakan, dan lindungilah aku dari keburukan yang telah Engkau tetapkan. Sesungguhnya Engkaulah yang menetapkan dan tidak ada yang berhak menetapkan atas-Mu...',
    ),
    ShalatItem(
      id: 'dzuhur',
      name: 'Shalat Dzuhur',
      category: 'fardhu',
      rakaat: 4,
      hukum: 'Fardhu ‘Ain (Wajib)',
      waktu: 'Mulai tergelincirnya matahari dari tengah langit ke arah barat hingga bayangan suatu benda sama panjang dengan aslinya',
      description:
          'Shalat fardhu empat rakaat yang dikerjakan pada siang hari dengan bacaan sirr (pelan). Terdiri dari dua tasyahhud (awal di rakaat kedua dan akhir di rakaat keempat).',
      niatArab: 'أُصَلِّي فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhazh-zhuhri arba’a raka’aatin mustaqbilal qiblati adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Dzuhur empat rakaat menghadap kiblat tepat pada waktunya karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhazh-zhuhri arba’a raka’aatin mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Dzuhur empat rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      niatMakmumArab: 'أُصَلِّي فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatMakmumLatin: 'Ushallii fardhazh-zhuhri arba’a raka’aatin mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatMakmumArti: 'Aku berniat shalat fardhu Dzuhur empat rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Pintu langit dibuka pada waktu tergelincirnya matahari (waktu Dzuhur), dan Rasulullah SAW menyukai bila amal kebajikan terangkat pada waktu tersebut (HR. Tirmidzi).',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Doa Iftitah, Al-Fatihah, Surah Pendek, Ruku’, I’tidal, 2 Sujud dengan duduk di antaranya.',
        'Rakaat 2: Al-Fatihah, Surah Pendek, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Awal.',
        'Rakaat 3: Bangkit bertakbir, membaca Al-Fatihah saja, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 4: Al-Fatihah saja, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Akhir & membaca Shalawat Ibrahimiyah, Salam.',
      ],
    ),
    ShalatItem(
      id: 'ashar',
      name: 'Shalat Ashar',
      category: 'fardhu',
      rakaat: 4,
      hukum: 'Fardhu ‘Ain (Wajib)',
      waktu: 'Mulai saat bayangan benda melebihi panjang aslinya hingga matahari mulai menguning dan terbenam',
      description:
          'Shalat fardhu empat rakaat yang sering disebut Shalat Wustha (shalat pertengahan). Dikerjakan secara sirr (pelan).',
      niatArab: 'أُصَلِّي فَرْضَ الْعَصْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhal ‘ashri arba’a raka’aatin mustaqbilal qiblati adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Ashar empat rakaat menghadap kiblat tepat pada waktunya karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الْعَصْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhal ‘ashri arba’a raka’aatin mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Ashar empat rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      niatMakmumArab: 'أُصَلِّي فَرْضَ الْعَصْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatMakmumLatin: 'Ushallii fardhal ‘ashri arba’a raka’aatin mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatMakmumArti: 'Aku berniat shalat fardhu Ashar empat rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa meninggalkan shalat Ashar secara sengaja, maka sungguh gugurlah amal kebaikannya (HR. Bukhari). Shalat Ashar dan Subuh disaksikan langsung oleh para malaikat bergantian.',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Iftitah, Al-Fatihah, Surah Pendek, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 2: Al-Fatihah, Surah Pendek, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Awal.',
        'Rakaat 3: Al-Fatihah, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 4: Al-Fatihah, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Akhir & Shalawat, Salam.',
      ],
    ),
    ShalatItem(
      id: 'maghrib',
      name: 'Shalat Maghrib',
      category: 'fardhu',
      rakaat: 3,
      hukum: 'Fardhu ‘Ain (Wajib)',
      waktu: 'Mulai terbenamnya seluruh piringan matahari hingga hilangnya mega merah di ufuk barat',
      description:
          'Shalat fardhu tiga rakaat. Bacaan Al-Fatihah dan surah pendek pada rakaat 1 dan 2 dibaca secara jahr (keras/nyaring) bagi imam dan munfarid (sendirian).',
      niatArab: 'أُصَلِّي فَرْضَ الْمَغْرِبِ ثَلَاثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhal maghribi tsalaatsa raka’aatin mustaqbilal qiblati adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Maghrib tiga rakaat menghadap kiblat tepat pada waktunya karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الْمَغْرِبِ ثَلَاثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhal maghribi tsalaatsa raka’aatin mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Maghrib tiga rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      niatMakmumArab: 'أُصَلِّي فَرْضَ الْمَغْرِبِ ثَلَاثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatMakmumLatin: 'Ushallii fardhal maghribi tsalaatsa raka’aatin mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatMakmumArti: 'Aku berniat shalat fardhu Maghrib tiga rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Menyegerakan shalat Maghrib di awal waktu mendatangkan kebaikan dan keberkahan sebagaimana sabda Nabi Muhammad SAW (HR. Abu Dawud).',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Iftitah, Al-Fatihah (nyaring), Surah Pendek, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 2: Al-Fatihah (nyaring), Surah Pendek, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Awal.',
        'Rakaat 3: Bangkit bertakbir, membaca Al-Fatihah saja (pelan/sirr), Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Akhir & Shalawat, Salam.',
      ],
    ),
    ShalatItem(
      id: 'isya',
      name: 'Shalat Isya',
      category: 'fardhu',
      rakaat: 4,
      hukum: 'Fardhu ‘Ain (Wajib)',
      waktu: 'Mulai hilangnya mega merah di ufuk barat hingga terbitnya fajar shadiq',
      description:
          'Shalat fardhu empat rakaat. Bacaan Al-Fatihah dan surah pada rakaat 1 dan 2 dibaca secara jahr (nyaring), sedangkan rakaat 3 dan 4 secara sirr (pelan).',
      niatArab: 'أُصَلِّي فَرْضَ الْعِشَاءِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhal ‘isyaa’i arba’a raka’aatin mustaqbilal qiblati adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Isya empat rakaat menghadap kiblat tepat pada waktunya karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الْعِشَاءِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhal ‘isyaa’i arba’a raka’aatin mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Isya empat rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      niatMakmumArab: 'أُصَلِّي فَرْضَ الْعِشَاءِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatMakmumLatin: 'Ushallii fardhal ‘isyaa’i arba’a raka’aatin mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatMakmumArti: 'Aku berniat shalat fardhu Isya empat rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa yang shalat Isya berjamaah, maka seolah-olah ia telah melaksanakan shalat separuh malam penuh (HR. Muslim).',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Iftitah, Al-Fatihah (nyaring), Surah Pendek, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 2: Al-Fatihah (nyaring), Surah Pendek, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Awal.',
        'Rakaat 3: Al-Fatihah (pelan), Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 4: Al-Fatihah (pelan), Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Akhir & Shalawat, Salam.',
      ],
    ),
    ShalatItem(
      id: 'jumat',
      name: 'Shalat Jum’at',
      category: 'fardhu',
      rakaat: 2,
      hukum: 'Fardhu ‘Ain (Wajib bagi Laki-laki Muslim)',
      waktu: 'Pada waktu Dzuhur di hari Jum’at didahului dengan dua khutbah',
      description:
          'Shalat dua rakaat berjamaah yang wajib dilaksanakan oleh laki-laki muslim mukallaf dan mukim pada hari Jum’at sebagai pengganti shalat Dzuhur, setelah mendengarkan dua khutbah Jum’at.',
      niatArab: 'أُصَلِّي فَرْضَ الْجُمُعَةِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhal jumu’ati rak’ataini mustaqbilal qiblati adaa’an ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Jum’at dua rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      niatImamArab: 'أُصَلِّي فَرْضَ الْجُمُعَةِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
      niatImamLatin: 'Ushallii fardhal jumu’ati rak’ataini mustaqbilal qiblati adaa’an imaaman lillaahi ta’aalaa',
      niatImamArti: 'Aku berniat shalat fardhu Jum’at dua rakaat menghadap kiblat sebagai imam karena Allah Ta’ala.',
      keutamaan:
          'Hari Jum’at adalah sayyidul ayyam (pemimpin segala hari). Shalat Jum’at dan langkah kaki menuju masjid menghapus dosa-dosa di antara dua Jum’at (HR. Muslim).',
      tataCara: [
        'Mandi sunnah Jum’at, memakai pakaian terbaik, dan wewangian.',
        'Mendengarkan dua khutbah Jum’at dengan tenang dan khusyuk (tidak berbicara sama sekali).',
        'Rakaat 1: Takbiratul Ihram bersama imam, membaca Al-Fatihah & surah (imam menjaharkan bacaan), ruku’, i’tidal, 2 sujud.',
        'Rakaat 2: Al-Fatihah & surah bersama imam, ruku’, i’tidal, 2 sujud, tasyahhud akhir, dan salam.',
      ],
    ),
  ];

  // ==========================================
  // 3. SHALAT SUNNAH LENGKAP
  // ==========================================
  static const List<ShalatItem> shalatSunnahList = [
    ShalatItem(
      id: 'tahajjud',
      name: 'Shalat Tahajjud (Qiyamul Lail)',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah Muakkad',
      waktu: 'Malam hari setelah bangun dari tidur, paling utama di sepertiga malam terakhir (sekitar pukul 02.00 - subuh)',
      description:
          'Shalat sunnah malam hari yang didirikan setelah tidur terlebih dahulu, minimal 2 rakaat dengan salam setiap 2 rakaat, tanpa batas maksimal rakaat.',
      niatArab: 'أُصَلِّي سُنَّةَ التَّهَجُّدِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatat-tahajjudi rak’ataini mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Tahajjud dua rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Dan pada sebagian malam bertahajudlah kamu sebagai suatu ibadah tambahan bagimu; mudah-mudahan Tuhanmu mengangkat kamu ke tempat yang terpuji (QS. Al-Isra: 79). Doa pada waktu ini bagaikan anak panah yang tak pernah meleset.',
      tataCara: [
        'Tidur sejenak terlebih dahulu sebelum menunaikannya.',
        'Dikerjakan minimal 2 rakaat, setiap 2 rakaat diakhiri dengan salam.',
        'Disunnahkan membaca ayat-ayat Al-Qur’an yang panjang dengan penghayatan dan tadabbur.',
        'Ditutup dengan shalat witir 1 atau 3 rakaat.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ لَكَ الْحَمْدُ أَنْتَ نُوْرُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيْهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ قَيِّمُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيْهِنَّ، أَنْتَ الْحَقُّ وَوَعْدُكَ الْحَقُّ وَقَوْلُكَ الْحَقُّ وَلِقَاؤُكَ حَقٌّ وَالْجَنَّةُ حَقٌّ وَالنَّارُ حَقٌّ وَالنَّبِيُّوْنَ حَقٌّ وَمُحَمَّدٌ حَقٌّ وَالسَّاعَةُ حَقٌّ...',
      doaKhususLatin:
          'Allaahumma lakal hamdu anta nuurus-samaawaati wal ardhi wa man fiihinna, wa lakal hamdu anta qayyimus-samaawaati wal ardhi wa man fiihinna, antal haqqu wa wa’dukal haqqu wa qaulukal haqqu wa liqaa’uka haqqun wal jannatu haqqun wan-naaru haqqun wan-nabiyyuuna haqqun wa Muhammadun haqqun was-saa’atu haqqun...',
      doaKhususArti:
          'Ya Allah, bagi-Mu segala puji, Engkaulah cahaya langit dan bumi serta apa yang ada di dalamnya. Bagi-Mu segala puji, Engkaulah pengurus langit dan bumi serta apa yang ada di dalamnya. Engkaulah Yang Maha Benar, janji-Mu benar, firman-Mu benar, perjumpaan dengan-Mu benar, surga-Mu benar, neraka-Mu benar, para nabi-Mu benar, Nabi Muhammad benar, dan hari kiamat itu benar...',
    ),
    ShalatItem(
      id: 'dhuha',
      name: 'Shalat Dhuha',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah Muakkad',
      waktu: 'Mulai saat matahari naik setinggi satu tombak (sekitar 15-20 menit setelah terbit matahari) hingga menjelang waktu Dzuhur',
      description:
          'Shalat sunnah yang ditunaikan di waktu pagi hari saat matahari sedang naik. Dikerjakan minimal 2 rakaat hingga 8 rakaat (atau 12 rakaat) setiap 2 rakaat satu salam.',
      niatArab: 'أُصَلِّي سُنَّةَ الضُّحَى رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatadh-dhuhaa rak’ataini mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Dhuha dua rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Shalat Dhuha merupakan sedekah bagi setiap persendian tubuh (360 persendian). Shalat Dhuha 4 rakaat menjamin kecukupan rezeki seseorang hingga sore hari (HR. Muslim & Tirmidzi).',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Al-Fatihah, disunnahkan membaca Surah Asy-Syams atau Ad-Dhuha, Ruku’, I’tidal, 2 Sujud.',
        'Rakaat 2: Al-Fatihah, disunnahkan membaca Surah Al-Lail atau Al-Insyirah, Ruku’, I’tidal, 2 Sujud, Duduk Tasyahhud Akhir, Salam.',
        'Berdoa dengan Doa Shalat Dhuha.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ إِنَّ الضُّحَاءَ ضُحَاؤُكَ، وَالْبَهَاءَ بَهَاؤُكَ، وَالْجَمَالَ جَمَالُكَ، وَالْقُوَّةَ قُوَّتُكَ، وَالْقُدْرَةَ قُدْرَتُكَ، وَالْعِصْمَةَ عِصْمَتُكَ. اَللّٰهُمَّ إِنْ كَانَ رِزْقِيْ فِي السَّمَاءِ فَأَنْزِلْهُ، وَإِنْ كَانَ فِي الْأَرْضِ فَأَخْرِجْهُ، وَإِنْ كَانَ مُعَسَّرًا فَيَسِّرْهُ، وَإِنْ كَانَ حَرَامًا فَطَهِّرْهُ، وَإِنْ كَانَ بَعِيْدًا فَقَرِّبْهُ، بِحَقِّ ضُحَائِكَ وَبَهَائِكَ وَجَمَالِكَ وَقُوَّتِكَ وَقُدْرَتِكَ، آتِنِيْ مَا آتَيْتَ عِبَادَكَ الصَّالِحِيْنَ',
      doaKhususLatin:
          'Allaahumma innadh-dhuhaa’a dhuhaa’uka, wal bahaa’a bahaa’uka, wal jamaala jamaaluka, wal quwwata quwwatuka, wal qudrata qudratuka, wal ‘ishmata ‘ishmatuka. Allaahumma in kaana rizqii fis-samaa’i fa anzilhu, wa in kaana fil ardhi fa akhrijhu, wa in kaana mu’assaran fa yassirhu, wa in kaana haraaman fa thahhirhu, wa in kaana ba’iidan fa qarribhu, bihaqqi dhuhaa’ika wa bahaa’ika wa jamaalika wa quwwatika wa qudratika, aatinii maa aataita ‘ibaadakash-shaalihiin.',
      doaKhususArti:
          'Ya Allah, sesungguhnya waktu dhuha adalah waktu dhuha-Mu, keagungan adalah keagungan-Mu, keindahan adalah keindahan-Mu, kekuatan adalah kekuatan-Mu, kekuasaan adalah kekuasaan-Mu, dan penjagaan adalah penjagaan-Mu. Ya Allah, apabila rezekiku berada di atas langit maka turunkanlah, bila ada di dalam bumi maka keluarkanlah, bila sukar mudahkanlah, bila haram sucikanlah, bila jauh dekatkanlah, dengan hak waktu dhuha-Mu, keagungan-Mu, keindahan-Mu, kekuatan-Mu dan kekuasaan-Mu, limpahkanlah kepadaku apa yang telah Engkau limpahkan kepada hamba-hamba-Mu yang saleh.',
    ),
    ShalatItem(
      id: 'witir',
      name: 'Shalat Witir',
      category: 'sunnah',
      rakaat: 3,
      hukum: 'Sunnah Muakkad',
      waktu: 'Setelah shalat Isya hingga terbit fajar subuh, menjadi penutup shalat malam',
      description:
          'Shalat sunnah dengan bilangan rakaat ganjil (1, 3, 5, hingga 11 rakaat). Menjadi penutup seluruh shalat sunnah yang dikerjakan pada malam hari.',
      niatArab: 'أُصَلِّي سُنَّةَ الْوِتْرِ ثَلَاثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatal witri tsalaatsa raka’aatin mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Witir tiga rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Sesungguhnya Allah itu Witir (Ganjil) dan menyukai hal-hal yang ganjil, maka shalat witirlah kalian wahai ahli Al-Qur’an (HR. Abu Dawud & Tirmidzi).',
      tataCara: [
        'Bisa dikerjakan 3 rakaat sekaligus dengan satu salam, atau 2 rakaat salam lalu ditambah 1 rakaat salam.',
        'Rakaat 1 membaca Surah Al-A’laa, rakaat 2 membaca Surah Al-Kafirun, rakaat 3 membaca Surah Al-Ikhlas, Al-Falaq, dan An-Nas.',
        'Pada separuh akhir bulan Ramadhan, disunnahkan membaca doa Qunut pada rakaat terakhir.',
      ],
      doaKhususArab:
          'سُبْحَانَ الْمَلِكِ الْقُدُّوْسِ (٣×)، سُبُّوْحٌ قُدُّوْسٌ رَبُّنَا وَرَبُّ الْمَلَائِكَةِ وَالرُّوْحِ',
      doaKhususLatin: 'Subhaanal malikil qudduus (3x), Subbuuhun qudduusun rabbunaa wa rabbul malaa’ikati war-ruuh.',
      doaKhususArti: 'Maha Suci Dzat Raja Yang Maha Suci (3x). Maha Suci dan Maha Kudus Tuhan kami serta Tuhan para Malaikat dan Ruh (Jibril).',
    ),
    ShalatItem(
      id: 'rawatib',
      name: 'Shalat Sunnah Rawatib',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah Muakkad & Ghairu Muakkad',
      waktu: 'Mengiringi shalat fardhu (Qabliyah sebelum fardhu, Ba’diyah sesudah fardhu)',
      description:
          'Shalat sunnah yang mengiringi shalat fardhu 5 waktu. Yang Muakkad (sangat dianjurkan) ada 10/12 rakaat: 2 rakaat sebelum Subuh, 2/4 sebelum Dzuhur, 2 sesudah Dzuhur, 2 sesudah Maghrib, dan 2 sesudah Isya.',
      niatArab: 'أُصَلِّي سُنَّةَ الظُّهْرِ رَكْعَتَيْنِ قَبْلِيَّةً مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatazh-zhuhri rak’ataini qabliyyatan mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah sebelum (qabliyah) Dzuhur dua rakaat menghadap kiblat karena Allah Ta’ala. (Ganti "ba’diyyatan" jika sesudah shalat).',
      keutamaan:
          'Barangsiapa shalat sunnah 12 rakaat dalam sehari semalam (rawatib), Allah akan bangunkan baginya sebuah istana megah di dalam Surga (HR. Muslim).',
      tataCara: [
        'Dikerjakan 2 rakaat masing-masing salam.',
        'Membaca Al-Fatihah dan surah pendek seperti Al-Kafirun pada rakaat 1 dan Al-Ikhlas pada rakaat 2.',
        'Tidak ada adzan maupun iqamah untuk shalat sunnah rawatib.',
      ],
    ),
    ShalatItem(
      id: 'tarawih',
      name: 'Shalat Tarawih',
      category: 'sunnah',
      rakaat: 8,
      hukum: 'Sunnah Muakkad',
      waktu: 'Khusus pada malam hari di bulan Ramadhan setelah shalat Isya hingga sebelum waktu Subuh',
      description:
          'Shalat sunnah khusus yang dilaksanakan hanya pada malam-malam bulan suci Ramadhan. Dikerjakan 8 rakaat (4 kali salam @ 2 rakaat) atau 20 rakaat (10 kali salam @ 2 rakaat), lalu ditutup dengan shalat witir 3 rakaat.',
      niatArab: 'أُصَلِّي سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatat-taraawiihi rak’ataini mustaqbilal qiblati ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Tarawih dua rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa mendirikan shalat malam di bulan Ramadhan (Tarawih) karena iman dan mengharap pahala Allah, diampuni dosa-dosanya yang telah lalu (HR. Bukhari & Muslim).',
      tataCara: [
        'Dikerjakan dua rakaat - dua rakaat salam.',
        'Dianjurkan berjamaah di masjid atau mushalla.',
        'Diselingi dengan istirahat, dzikir, dan shalawat di antara tiap 2 atau 4 rakaat.',
        'Diakhiri dengan Shalat Witir dan Doa Kamilin.',
      ],
    ),
    ShalatItem(
      id: 'hajat',
      name: 'Shalat Hajat',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah',
      waktu: 'Kapan saja baik siang maupun malam hari (di luar waktu yang diharamkan shalat)',
      description:
          'Shalat sunnah yang dikerjakan saat seseorang memiliki hajat, permohonan khusus, atau keinginan besar yang ingin dikabulkan oleh Allah SWT.',
      niatArab: 'أُصَلِّي سُنَّةَ الْحَاجَةِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatal haajati rak’ataini mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Hajat dua rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa berwudhu dengan sempurna lalu shalat dua rakaat memohon kepada Allah apa saja kebutuhannya, Allah pasti memberikannya cepat atau lambat (HR. Ahmad).',
      tataCara: [
        'Dikerjakan 2 rakaat.',
        'Setelah salam, membaca puji-pujian kepada Allah dan bershalawat kepada Rasulullah SAW.',
        'Membaca doa Shalat Hajat dan menyampaikan keinginan/hajat di dalam sujud atau setelah shalat.',
      ],
      doaKhususArab:
          'لَا إِلٰهَ إِلَّا اللّٰهُ الْحَلِيْمُ الْكَرِيْمُ، سُبْحَانَ اللّٰهِ رَبِّ الْعَرْشِ الْعَظِيْمِ، اَلْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ، أَسْأَلُكَ مُوْجِبَاتِ رَحْمَتِكَ وَعَزَائِمَ مَغْفِرَتِكَ وَالْغَنِيْمَةَ مِنْ كُلِّ بِرٍّ وَالسَّلَامَةَ مِنْ كُلِّ إِثْمٍ، لَا تَدَعْ لِيْ ذَنْبًا إِلَّا غَفَرْتَهُ وَلَا هَمًّا إِلَّا فَرَّجْتَهُ وَلَا حَاجَةً هِيَ لَكَ رِضًا إِلَّا قَضَيْتَهَا يَا أَرْحَمَ الرَّاحِمِيْنَ',
      doaKhususLatin:
          'Laa ilaaha illallaahul haliimul kariim, subhaanallaahi rabbil ‘arsyil ‘azhiim. Alhamdulillaahi rabbil ‘aalamiin. As’aluka muujibaati rahmatika wa ‘azaa’ima maghfiratika wal ghaniimata min kulli birrin was-salaamata min kulli itsmin, laa tada’ lii dzanban illaa ghafartahu wa laa hamman illaa farrajtahu wa laa haajatan hiya laka ridhan illaa qadhaitahaa yaa arhamar-raahimiin.',
      doaKhususArti:
          'Tiada tuhan yang berhak disembah selain Allah Yang Maha Penyantun lagi Maha Pemurah. Maha Suci Allah, Tuhan Pemelihara Arsy yang agung. Segala puji bagi Allah, Tuhan semesta alam. Aku memohon kepada-Mu sebab-sebab rahmat-Mu, kepastian ampunan-Mu, keuntungan dari setiap kebaikan, dan keselamatan dari setiap dosa. Janganlah Engkau biarkan dosa padaku melainkan Engkau ampuni, jangan biarkan kesedihan melainkan Engkau beri jalan keluar, dan tiada suatu hajat yang Engkau ridhai melainkan Engkau kabulkan, wahai Yang Maha Pengasih dari segala yang mengasihi.',
    ),
    ShalatItem(
      id: 'istikharah',
      name: 'Shalat Istikharah',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah',
      waktu: 'Kapan saja saat menghadapi kebimbangan atau dihadapkan pada pilihan-pilihan penting dalam hidup',
      description:
          'Shalat sunnah dua rakaat untuk memohon petunjuk pilihan terbaik dari Allah Subhanahu wa Ta’ala dalam urusan jodoh, pekerjaan, studi, tempat tinggal, maupun keputusan penting lainnya.',
      niatArab: 'أُصَلِّي سُنَّةَ الْاِسْتِخَارَةِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatal istikhaarati rak’ataini mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Istikharah dua rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Rasulullah SAW mengajarkan istikharah dalam setiap urusan sebagaimana beliau mengajarkan satu surat dari Al-Qur’an (HR. Bukhari). Orang yang beristikharah tidak akan pernah menyesal.',
      tataCara: [
        'Dikerjakan 2 rakaat.',
        'Rakaat 1 membaca Al-Fatihah dan Surah Al-Kafirun.',
        'Rakaat 2 membaca Al-Fatihah dan Surah Al-Ikhlas.',
        'Setelah salam membaca Doa Istikharah yang diajarkan Rasulullah SAW.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ إِنِّيْ أَسْتَخِيْرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيْمِ، فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ، وَتَعْلَمُ وَلَا أَعْلَمُ، وَأَنْتَ عَلَّامُ الْغُيُوْبِ. اَللّٰهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ خَيْرٌ لِيْ فِيْ دِيْنِيْ وَمَعَاشِيْ وَعَاقِبَةِ أَمْرِيْ فَاقْدُرْهُ لِيْ وَيَسِّرْهُ لِيْ ثُمَّ بَارِكْ لِيْ فِيْهِ...',
      doaKhususLatin:
          'Allaahumma innii astakhiiruka bi’ilmika, wa astaqdiruka biqudratika, wa as’aluka min fadhlikal ‘azhiim, fa innaka taqdiru wa laa aqdiru, wa ta’lamu wa laa a’lamu, wa anta ‘allaamul ghuyuub. Allaahumma in kunta ta’lamu anna haadzal amra khairun lii fii diinii wa ma’aasyii wa ‘aaqibati amrii faqdurhu lii wa yassirhu lii tsumma baarik lii fiihi...',
      doaKhususArti:
          'Ya Allah, sesungguhnya aku memohon petunjuk dengan ilmu-Mu, memohon kemampuan dengan kekuasaan-Mu, dan meminta kemurahan-Mu yang agung. Sesungguhnya Engkau Maha Berkuasa sedang aku tidak berkuasa, Engkau Maha Mengetahui sedang aku tidak mengetahui, dan Engkaulah Yang Maha Mengetahui perkara gaib...',
    ),
    ShalatItem(
      id: 'taubat',
      name: 'Shalat Taubat',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah',
      waktu: 'Kapan saja setiap kali seorang muslim berbuat dosa dan bertekad untuk kembali kepada Allah',
      description:
          'Shalat sunnah dua rakaat yang dilakukan ketika seseorang menyadari kesalahan atau dosa yang telah diperbuat, dengan tekad tulus untuk tidak mengulanginya lagi (Taubat Nasuha).',
      niatArab: 'أُصَلِّي سُنَّةَ التَّوْبَةِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatat-taubati rak’ataini mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Taubat dua rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Tidaklah seorang hamba melakukan suatu dosa, lalu ia berwudhu dengan baik, kemudian shalat dua rakaat dan beristighfar memohon ampunan kepada Allah, melainkan Allah pasti mengampuni dosanya (HR. Abu Dawud & Tirmidzi).',
      tataCara: [
        'Berwudhu dengan sempurna.',
        'Mendirikan shalat 2 rakaat dengan penuh penyesalan dan linangan air mata.',
        'Memperbanyak istighfar dan membaca Sayyidul Istighfar.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِيْ وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوْذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوْءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوْءُ بِذَنْبِيْ فَاغْفِرْ لِيْ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوْبَ إِلَّا أَنْتَ',
      doaKhususLatin:
          'Allaahumma anta rabbii laa ilaaha illaa anta, khalaqtanii wa ana ‘abduka, wa ana ‘alaa ‘ahdika wa wa’dika mastatha’tu, a’uudzu bika min syarri maa shana’tu, abuu’u laka bini’matika ‘alayya, wa abuu’u bidzanbii faghfir lii fa innahu laa yaghfirudz-dzunuuba illaa anta.',
      doaKhususArti:
          'Ya Allah, Engkau adalah Tuhanku, tiada tuhan selain Engkau. Engkau yang menciptakan aku dan aku adalah hamba-Mu. Aku memegang teguh perjanjian-Mu dan janji-Mu semampuku. Aku berlindung kepada-Mu dari keburukan yang telah aku perbuat. Aku mengakui nikmat-Mu yang Engkau limpahkan kepadaku, dan aku mengakui dosaku kepada-Mu, maka ampunilah aku, sesungguhnya tiada yang dapat mengampuni dosa-dosa selain Engkau.',
    ),
    ShalatItem(
      id: 'tasbih',
      name: 'Shalat Tasbih',
      category: 'sunnah',
      rakaat: 4,
      hukum: 'Sunnah',
      waktu: 'Kapan saja (bisa dikerjakan setiap malam, seminggu sekali, sebulan sekali, setahun sekali, atau seumur hidup sekali)',
      description:
          'Shalat sunnah empat rakaat yang di dalamnya dibaca kalimat tasbih sebanyak 300 kali (75 kali tasbih pada setiap rakaat di berbagai posisi gerakan shalat).',
      niatArab: 'أُصَلِّي سُنَّةَ التَّسْبِيْحِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatat-tasbiihi arba’a raka’aatin mustaqbilal qiblati lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Tasbih empat rakaat menghadap kiblat karena Allah Ta’ala.',
      keutamaan:
          'Nabi Muhammad SAW berwasiat kepada pamannya Abbas RA bahwa jika shalat ini dikerjakan, Allah akan mengampuni sepuluh jenis dosa: dosa awal, akhir, lama, baru, yang tidak disengaja, disengaja, kecil, besar, tersembunyi, maupun terang-terangan (HR. Abu Dawud).',
      tataCara: [
        'Bacaan Tasbih: "Subhaanallaahi wal hamdu lillaahi wa laa ilaaha illallaahu wallaahu akbar".',
        'Sebaran 75 tasbih per rakaat: Setelah Al-Fatihah & surah (15x), saat Ruku’ (10x), saat I’tidal (10x), saat Sujud 1 (10x), saat Duduk antara dua sujud (10x), saat Sujud 2 (10x), saat Duduk istirahat sebelum bangkit (10x). Total 75x per rakaat x 4 rakaat = 300x tasbih.',
      ],
    ),
    ShalatItem(
      id: 'idulfitri',
      name: 'Shalat Hari Raya Idul Fitri',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah Muakkad',
      waktu: 'Tanggal 1 Syawwal mulai saat matahari terbit setinggi tombak hingga sebelum waktu Dzuhur',
      description:
          'Shalat sunnah dua rakaat yang ditunaikan secara berjamaah di tanah lapang atau masjid pada pagi hari Idul Fitri. Disertai dengan 7 takbir tambahan pada rakaat pertama dan 5 takbir tambahan pada rakaat kedua, dilanjutkan dua khutbah Id.',
      niatArab: 'أُصَلِّي سُنَّةً لِعِيْدِ الْفِطْرِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatan li’iidil fithri rak’ataini mustaqbilal qiblati ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Idul Fitri dua rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Merupakan syiar Islam yang agung di hari kemenangan kaum muslimin setelah sebulan penuh berpuasa Ramadhan. Para malaikat turun menyambut dan mendoakan ampunan bagi kaum mukminin.',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram lalu membaca iftitah, kemudian takbir tambahan 7 kali. Di antara tiap takbir membaca: "Subhaanallaahi wal hamdu lillaahi wa laa ilaaha illallaahu wallaahu akbar". Lalu Al-Fatihah dan Surah Al-A’laa.',
        'Rakaat 2: Bangkit takbir intiqal, lalu takbir tambahan 5 kali seraya membaca tasbih di antaranya. Lalu Al-Fatihah dan Surah Al-Ghaasyiyah.',
        'Mendengarkan dua khutbah Idul Fitri dengan khidmat.',
      ],
    ),
    ShalatItem(
      id: 'iduladha',
      name: 'Shalat Hari Raya Idul Adha',
      category: 'sunnah',
      rakaat: 2,
      hukum: 'Sunnah Muakkad',
      waktu: 'Tanggal 10 Dzulhijjah di waktu pagi hari agar lekas menyembelih hewan qurban',
      description:
          'Shalat dua rakaat berjamaah pada hari raya kurban (Nahr), tata caranya persis sama dengan shalat Idul Fitri (7 takbir di rakaat pertama dan 5 takbir di rakaat kedua) diikuti dengan penyembelihan hewan kurban.',
      niatArab: 'أُصَلِّي سُنَّةً لِعِيْدِ الْأَضْحَى رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatan li’iidil adh-haa rak’ataini mustaqbilal qiblati ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah Idul Adha dua rakaat menghadap kiblat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Hari Idul Adha dan hari Tasyriq adalah hari makan, minum, dan berdzikir mengingat Allah. Menyembelih hewan kurban adalah amalan yang paling dicintai Allah pada hari raya qurban.',
      tataCara: [
        'Disunnahkan tidak makan terlebih dahulu sampai shalat Idul Adha selesai.',
        'Dikerjakan 2 rakaat dengan 7 takbir di rakaat 1 dan 5 takbir di rakaat 2.',
        'Mendengarkan dua khutbah Idul Adha lalu dilanjutkan dengan penyembelihan qurban.',
      ],
    ),
  ];

  // ==========================================
  // 4. SHALAT JENAZAH & SHALAT KHUSUS
  // ==========================================
  static const List<ShalatItem> shalatKhususList = [
    ShalatItem(
      id: 'jenazah_lk',
      name: 'Shalat Jenazah (Laki-laki)',
      category: 'jenazah',
      rakaat: 0, // Shalat berdiri tanpa ruku' dan sujud
      hukum: 'Fardhu Kifayah',
      waktu: 'Setelah jenazah dimandikan dan dikafani',
      description:
          'Shalat yang dikerjakan dengan berdiri penuh sebanyak 4 kali takbir tanpa ruku’ dan sujud. Posisi imam berdiri sejajar dengan kepala jenazah laki-laki.',
      niatArab: 'أُصَلِّي عَلَى هٰذَا الْمَيِّتِ أَرْبَعَ تَكْبِيْرَاتٍ فَرْضَ الْكِفَايَةِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii ‘alaa haadzal mayyiti arba’a takbiiraatin fardhal kifaayati ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat atas jenazah (laki-laki) ini empat takbir fardhu kifayah sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Barangsiapa menshalatkan jenazah maka baginya pahala sebesar satu qirath (sebesar Gunung Uhud), dan barangsiapa mengiringinya hingga dimakamkan maka baginya dua qirath (HR. Bukhari & Muslim).',
      tataCara: [
        'Takbir ke-1: Membaca Surat Al-Fatihah.',
        'Takbir ke-2: Membaca Shalawat Nabi (Allaahumma shalli ‘alaa sayyidinaa Muhammad...).',
        'Takbir ke-3: Mendoakan jenazah: "Allaahummaghfir lahu warhamhu wa ‘aafihi wa’fu ‘anhu...".',
        'Takbir ke-4: Membaca doa: "Allaahumma laa tahrimnaa ajrahu wa laa taftinnaa ba’dahu waghfir lanaa wa lahu", lalu Salam ke kanan dan ke kiri.',
      ],
      doaKhususArab:
          'اَللّٰهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ، وَأَكْرِمْ نُزُلَهُ وَوَسِّعْ مَدْخَلَهُ، وَاغْسِلْهُ بِالْمَاءِ وَالثَّلْجِ وَالْبَرَدِ، وَنَقِّهِ مِنَ الْخَطَايَا كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ...',
      doaKhususLatin:
          'Allaahummaghfir lahu warhamhu wa ‘aafihi wa’fu ‘anhu, wa akrim nuzulahu wa wassi’ madkhalahu, waghsilhu bil maa’i wats-tsalji wal barad, wa naqqihii minal khathaayaa kamaa yunaqqats-tsaubul abyadhu minad-danas...',
      doaKhususArti:
          'Ya Allah, ampunilah dia, rahmatilah dia, selamatkanlah dia dan maafkanlah kesalahannya. Muliakanlah tempat persinggahannya, luaskanlah kuburnya, sucikanlah dia dengan air, es dan embun, dan bersihkanlah dia dari segala kesalahan sebagaimana kain putih dibersihkan dari noda kotoran...',
    ),
    ShalatItem(
      id: 'jenazah_pr',
      name: 'Shalat Jenazah (Perempuan)',
      category: 'jenazah',
      rakaat: 0,
      hukum: 'Fardhu Kifayah',
      waktu: 'Setelah jenazah perempuan selesai dimandikan dan dikafani',
      description:
          'Shalat jenazah 4 takbir untuk perempuan. Posisi imam berdiri sejajar dengan perut / pinggang jenazah perempuan.',
      niatArab: 'أُصَلِّي عَلَى هٰذِهِ الْمَيِّتَةِ أَرْبَعَ تَكْبِيْرَاتٍ فَرْضَ الْكِفَايَةِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii ‘alaa haadzihil mayyitati arba’a takbiiraatin fardhal kifaayati ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat atas jenazah (perempuan) ini empat takbir fardhu kifayah sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Tidaklah seorang muslim meninggal dunia lalu dishalatkan oleh 40 orang yang tidak menyekutukan Allah sedikitpun, melainkan Allah akan menerima syafaat mereka untuknya (HR. Muslim).',
      tataCara: [
        'Takbir ke-1: Membaca Surat Al-Fatihah.',
        'Takbir ke-2: Membaca Shalawat Nabi.',
        'Takbir ke-3: Mendoakan jenazah perempuan: "Allaahummaghfir lahaa warhamhaa wa ‘aafihaa wa’fu ‘anhaa...".',
        'Takbir ke-4: Membaca doa: "Allaahumma laa tahrimnaa ajrahaa wa laa taftinnaa ba’dahaa waghfir lanaa wa lahaa", lalu Salam.',
      ],
    ),
    ShalatItem(
      id: 'gerhana',
      name: 'Shalat Gerhana (Kusuf & Khusuf)',
      category: 'khusus',
      rakaat: 2,
      hukum: 'Sunnah Muakkad',
      waktu: 'Ketika terjadi peristiwa gerhana matahari (Kusuf) atau gerhana bulan (Khusuf) hingga gerhana selesai',
      description:
          'Shalat sunnah 2 rakaat yang unik dengan 4 kali ruku’ dan 4 kali sujud (setiap rakaat ada 2 kali berdiri membaca Al-Fatihah dan surah panjang, serta 2 kali ruku’).',
      niatArab: 'أُصَلِّي سُنَّةَ الْكُسُوْفِ رَكْعَتَيْنِ مَأْمُوْمًا لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii sunnatal kusuufi rak’ataini ma’muuman lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat sunnah gerhana (Kusuf: matahari / Khusuf: bulan) dua rakaat sebagai makmum karena Allah Ta’ala.',
      keutamaan:
          'Matahari dan bulan adalah tanda kebesaran Allah. Keduanya tidak gerhana karena kematian atau kelahiran seseorang. Jika kalian melihatnya maka berdoalah kepada Allah, bertakbirlah, shalatlah, dan bersedekahlah (HR. Bukhari).',
      tataCara: [
        'Rakaat 1: Takbiratul Ihram, Al-Fatihah, Surah Panjang, Ruku’ panjang ke-1, I’tidal, membaca Al-Fatihah & Surah lagi (berdiri ke-2), Ruku’ panjang ke-2, I’tidal, lalu 2 Sujud panjang.',
        'Rakaat 2: Persis sama dengan rakaat 1 (2 kali berdiri membaca surah dan 2 kali ruku’), lalu Duduk Tasyahhud Akhir & Salam.',
      ],
    ),
    ShalatItem(
      id: 'jamak_qashar',
      name: 'Shalat Jamak & Qashar (Musafir)',
      category: 'khusus',
      rakaat: 2,
      hukum: 'Rukhshah (Keringanan yang dicintai Allah)',
      waktu: 'Dalam perjalanan musafir yang mencapai jarak minimal marhalatain (±81-85 km) bukan untuk maksiat',
      description:
          'Menggabungkan dua shalat fardhu dalam satu waktu (Jamak: Dzuhur dengan Ashar, Maghrib dengan Isya) dan/atau meringkas shalat yang 4 rakaat menjadi 2 rakaat (Qashar: Dzuhur, Ashar, dan Isya).',
      niatArab: 'أُصَلِّي فَرْضَ الظُّهْرِ رَكْعَتَيْنِ قَصْرًا مَجْمُوْعًا إِلَيْهِ الْعَصْرُ أَدَاءً لِلّٰهِ تَعَالَى',
      niatLatin: 'Ushallii fardhazh-zhuhri rak’ataini qashran majmuu’an ilaihil ‘ashru adaa’an lillaahi ta’aalaa',
      niatArti: 'Aku berniat shalat fardhu Dzuhur dua rakaat qashar digabungkan dengan Ashar tunai karena Allah Ta’ala.',
      keutamaan:
          'Sesungguhnya Allah menyukai apabila rukhshah (keringanan-Nya) diambil sebagaimana Dia membenci apabila kemaksiatan dilakukan (HR. Ahmad & Ibnu Hibban).',
      tataCara: [
        'Jamak Taqdim: Shalat pertama dikerjakan di waktu pertama (misal Dzuhur & Ashar di waktu Dzuhur). Syarat: niat jamak di awal shalat pertama, tertib (dzuhur dulu baru ashar), dan muwalah (berurutan tanpa jeda panjang).',
        'Jamak Ta’khir: Shalat dikerjakan di waktu kedua (misal Dzuhur & Ashar di waktu Ashar). Syarat: sudah berniat ta’khir pada waktu shalat pertama sebelum habis.',
        'Shalat Maghrib tetap 3 rakaat (tidak boleh diqashar), Subuh tetap 2 rakaat.',
      ],
    ),
    ShalatItem(
      id: 'sujud_sahwi_tilawah',
      name: 'Sujud Sahwi, Tilawah & Syukur',
      category: 'khusus',
      rakaat: 0,
      hukum: 'Sunnah',
      waktu: 'Saat lupa rukun/ab’adh shalat (Sahwi), mendengar ayat Sajdah (Tilawah), atau menerima nikmat/terhindar dari bahaya (Syukur)',
      description:
          'Sujud khusus di luar sujud shalat biasa. Sujud Sahwi: dua sujud sebelum salam untuk menambal kelupaan shalat. Sujud Tilawah: satu sujud saat membaca/mendengar ayat sajdah. Sujud Syukur: satu sujud spontan tanda syukur kepada Allah.',
      niatArab: 'سُبْحَانَ مَنْ لَا يَنَامُ وَلَا يَسْهُوْ',
      niatLatin: 'Subhaana man laa yanaamu wa laa yas-huu',
      niatArti: 'Maha Suci Dzat Yang tidak pernah tidur dan tidak pernah lupa.',
      keutamaan:
          'Bila anak Adam membaca ayat sajdah lalu bersujud, setan menjauh seraya menangis berkata: "Celakalah aku, dia diperintahkan sujud lalu bersujud maka baginya surga, sedangkan aku diperintahkan sujud lalu membangkang maka bagiku neraka" (HR. Muslim).',
      tataCara: [
        'Sujud Sahwi: Dilakukan dua kali sujud dengan duduk di antaranya persis sebelum salam (atau setelah salam), membaca tasbih Sahwi.',
        'Sujud Tilawah: Berniat, takbir, sujud 1 kali membaca: "Sajada wajhiya lilladzii khalaqahu wa shawwarahu...", takbir lalu salam.',
        'Sujud Syukur: Sujud satu kali langsung menghadap kiblat dengan suci dari hadats ketika menerima anugerah besar atau selamat dari musibah.',
      ],
    ),
  ];

  // ==========================================
  // 5. PANDUAN WUDHU & TAYAMMUM LENGKAP
  // ==========================================
  static const List<PanduanWudhuItem> panduanWudhuList = [
    PanduanWudhuItem(
      step: 1,
      title: 'Membaca Basmalah & Mencuci Kedua Telapak Tangan',
      description:
          'Membaca Bismillah dan membasuh kedua telapak tangan hingga pergelangan tangan sebanyak 3 kali, membersihkan sela-sela jari jemari.',
      imageAsset: 'assets/shalat/wudhu_1.jpg',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
      latin: 'Bismillaahir-rahmaanir-rahiim',
      translation: 'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.',
    ),
    PanduanWudhuItem(
      step: 2,
      title: 'Berkumur-kumur (Madhmadha)',
      description:
          'Memasukkan air ke dalam mulut menggunakan telapak tangan kanan dan berkumur-kumur membersihkan sisa makanan sebanyak 3 kali.',
      imageAsset: 'assets/shalat/wudhu_2.jpg',
    ),
    PanduanWudhuItem(
      step: 3,
      title: 'Menghirup Air ke Hidung (Istinsyaq) & Mengeluarkannya',
      description:
          'Menghirup air ke dalam lubang hidung lalu menyemprotkannya keluar dengan tangan kiri untuk membersihkan rongga hidung sebanyak 3 kali.',
      imageAsset: 'assets/shalat/wudhu_3.jpg',
    ),
    PanduanWudhuItem(
      step: 4,
      title: 'Membasuh Seluruh Muka Disertai Niat Wudhu',
      description:
          'Membasuh seluruh wajah dari tempat tumbuhnya rambut kepala hingga bawah dagu dan dari telinga kanan ke telinga kiri sebanyak 3 kali, dibarengi niat wudhu di dalam hati.',
      imageAsset: 'assets/shalat/wudhu_4.jpg',
      arabic: 'نَوَيْتُ الْوُضُوْءَ لِرَفْعِ الْحَدَثِ الْأَصْغَرِ فَرْضًا لِلّٰهِ تَعَالَى',
      latin: 'Nawaitul wudhuu’a liraf’il hadatsil ashghari fardhan lillaahi ta’aalaa',
      translation: 'Aku berniat berwudhu untuk menghilangkan hadats kecil, fardhu karena Allah Ta’ala.',
    ),
    PanduanWudhuItem(
      step: 5,
      title: 'Membasuh Kedua Tangan Hingga ke Siku',
      description:
          'Membasuh tangan kanan mulai ujung jari hingga melewati kedua siku sebanyak 3 kali, kemudian dilanjutkan dengan tangan kiri sebanyak 3 kali.',
      imageAsset: 'assets/shalat/wudhu_5.jpg',
    ),
    PanduanWudhuItem(
      step: 6,
      title: 'Mengusap Sebagian / Seluruh Kepala',
      description:
          'Membasahi kedua tangan lalu mengusap sebagian atau seluruh kepala dari depan ditarik ke belakang lalu dikembalikan ke depan sebanyak 3 kali.',
      imageAsset: 'assets/shalat/wudhu_6.jpg',
    ),
    PanduanWudhuItem(
      step: 7,
      title: 'Membasuh Kedua Daun Telinga',
      description:
          'Memasukkan jari telunjuk ke dalam lubang telinga dan ibu jari membersihkan daun telinga bagian luar secara bersamaan sebanyak 3 kali.',
      imageAsset: 'assets/shalat/wudhu_7.jpg',
    ),
    PanduanWudhuItem(
      step: 8,
      title: 'Membasuh Kedua Kaki Hingga Mata Kaki & Doa',
      description:
          'Membasuh kaki kanan hingga di atas mata kaki sebanyak 3 kali seraya menyela-nyela jari kaki, lalu dilanjutkan kaki kiri sebanyak 3 kali secara tertib.',
      imageAsset: 'assets/shalat/wudhu_8.jpg',
      arabic:
          'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ. اَللّٰهُمَّ اجْعَلْنِيْ مِنَ التَّوَّابِيْنَ، وَاجْعَلْنِيْ مِنَ الْمُتَطَهِّرِيْنَ، وَاجْعَلْنِيْ مِنْ عِبَادِكَ الصَّالِحِيْنَ',
      latin:
          'Asyhadu allaa ilaaha illallaah wahdahu laa syariika lahu, wa asyhadu anna Muhammadan ‘abduhu wa rasuuluh. Allaahummaj’alnii minat-tawwaabiina, waj’alnii minal mutathahhiriina, waj’alnii min ‘ibaadikash-shaalihiin.',
      translation:
          'Aku bersaksi tiada tuhan selain Allah Yang Maha Esa tiada sekutu bagi-Nya, dan aku bersaksi bahwa Muhammad hamba dan utusan-Nya. Ya Allah jadikanlah aku termasuk golongan orang-orang yang bertaubat, jadikanlah aku termasuk golongan orang-orang yang bersuci, dan jadikanlah aku termasuk hamba-hamba-Mu yang saleh.',
    ),
  ];

  // ==========================================
  // 6. RUKUN, SYARAT & PEMBATAL SHALAT
  // ==========================================
  static const List<RukunSyaratShalat> rukunSyaratList = [
    RukunSyaratShalat(
      title: 'Syarat Wajib Shalat',
      items: [
        'Islam (tidak wajib bagi orang kafir)',
        'Baligh (sudah mencapai usia kedewasaan/akil baligh)',
        'Berakal sehat (tidak gila, hilang akal, atau pingsan)',
        'Suci dari haid dan nifas bagi wanita muslimah',
        'Telah sampai dakwah Islam kepadanya',
      ],
    ),
    RukunSyaratShalat(
      title: 'Syarat Sah Shalat',
      items: [
        'Suci badan, pakaian, dan tempat shalat dari segala najis',
        'Suci dari hadats kecil (berwudhu) dan hadats besar (mandi wajib)',
        'Menutup aurat (laki-laki: pusar hingga lutut; perempuan: seluruh tubuh kecuali muka dan telapak tangan)',
        'Telah masuk waktu shalat yang ditentukan',
        'Menghadap ke arah Kiblat (Ka’bah di Masjidil Haram)',
        'Mengetahui rukun dan fardhu shalat',
      ],
    ),
    RukunSyaratShalat(
      title: '13 Rukun Shalat (Mazhab Syafi’i)',
      items: [
        '1. Niat di dalam hati berbarengan dengan Takbiratul Ihram',
        '2. Berdiri bagi yang mampu pada shalat fardhu',
        '3. Mengucapkan Takbiratul Ihram ("Allahu Akbar")',
        '4. Membaca Surat Al-Fatihah pada setiap rakaat',
        '5. Ruku’ dengan Thuma’ninah (berhenti tenang sejenak)',
        '6. I’tidal (bangkit dari ruku’) dengan Thuma’ninah',
        '7. Dua kali Sujud pada setiap rakaat dengan Thuma’ninah',
        '8. Duduk di antara dua sujud dengan Thuma’ninah',
        '9. Duduk untuk Tasyahhud / Tahiyyat Akhir',
        '10. Membaca bacaan Tasyahhud Akhir',
        '11. Membaca Shalawat atas Nabi Muhammad SAW pada tasyahhud akhir',
        '12. Mengucapkan Salam yang pertama ke arah kanan',
        '13. Tertib (mengerjakan semua rukun secara berurutan)',
      ],
    ),
    RukunSyaratShalat(
      title: 'Hal-Hal yang Membatalkan Shalat',
      items: [
        'Berbicara sengaja dengan perkataan manusia',
        'Melakukan gerakan banyak secara berturut-turut (tiga gerakan berturut-turut)',
        'Berhadats (buang angin, kencing, dll) sebelum salam pertama',
        'Terkena najis yang tidak dimaafkan pada pakaian atau badan',
        'Terbukanya aurat secara sengaja atau tidak segera ditutup',
        'Berubah niat di tengah-tengah shalat',
        'Membelakangi kiblat dengan sengaja',
        'Makan atau minum walaupun sedikit',
        'Tertawa terbahak-bahak hingga mengeluarkan suara',
        'Murtad (keluar dari agama Islam)',
        'Meninggalkan salah satu rukun atau syarat sah shalat secara sengaja',
      ],
    ),
  ];
}
