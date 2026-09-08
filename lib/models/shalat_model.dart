class ShalatItem {
  final String id;
  final String name;
  final String category; // 'fardhu', 'sunnah', 'jenazah', 'khusus'
  final int rakaat;
  final String hukum;
  final String waktu;
  final String description;
  final String niatArab;
  final String niatLatin;
  final String niatArti;
  final String? niatImamArab;
  final String? niatImamLatin;
  final String? niatImamArti;
  final String? niatMakmumArab;
  final String? niatMakmumLatin;
  final String? niatMakmumArti;
  final String keutamaan;
  final List<String> tataCara;
  final String? doaKhususArab;
  final String? doaKhususLatin;
  final String? doaKhususArti;

  const ShalatItem({
    required this.id,
    required this.name,
    required this.category,
    required this.rakaat,
    required this.hukum,
    required this.waktu,
    required this.description,
    required this.niatArab,
    required this.niatLatin,
    required this.niatArti,
    this.niatImamArab,
    this.niatImamLatin,
    this.niatImamArti,
    this.niatMakmumArab,
    this.niatMakmumLatin,
    this.niatMakmumArti,
    required this.keutamaan,
    required this.tataCara,
    this.doaKhususArab,
    this.doaKhususLatin,
    this.doaKhususArti,
  });
}

class GerakanShalatItem {
  final int order;
  final String name;
  final String description;
  final String imageAsset;
  final String arabic;
  final String latin;
  final String translation;
  final String tips;

  const GerakanShalatItem({
    required this.order,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.tips,
  });
}

class PanduanWudhuItem {
  final int step;
  final String title;
  final String description;
  final String imageAsset;
  final String? arabic;
  final String? latin;
  final String? translation;

  const PanduanWudhuItem({
    required this.step,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.arabic,
    this.latin,
    this.translation,
  });
}

class RukunSyaratShalat {
  final String title;
  final List<String> items;

  const RukunSyaratShalat({
    required this.title,
    required this.items,
  });
}
