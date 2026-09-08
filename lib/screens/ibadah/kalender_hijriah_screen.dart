import 'package:flutter/material.dart';

class KalenderHijriahScreen extends StatelessWidget {
  const KalenderHijriahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final islamicEvents = [
      {'title': 'Tahun Baru Islam (1 Muharram)', 'hijri': '1 Muharram', 'desc': 'Awal tahun kalender Hijriah'},
      {'title': 'Hari Asyura', 'hijri': '10 Muharram', 'desc': 'Puasa sunnah Asyura'},
      {'title': 'Maulid Nabi Muhammad ﷺ', 'hijri': '12 Rabi\'ul Awwal', 'desc': 'Peringatan kelahiran Rasulullah ﷺ'},
      {'title': 'Isra\' Mi\'raj', 'hijri': '27 Rajab', 'desc': 'Perjalanan malam & perintah shalat 5 waktu'},
      {'title': 'Nisfu Sya\'ban', 'hijri': '15 Sya\'ban', 'desc': 'Malam penuh ampunan'},
      {'title': 'Awal Puasa Ramadhan', 'hijri': '1 Ramadhan', 'desc': 'Wajib puasa satu bulan penuh'},
      {'title': 'Nuzulul Qur\'an', 'hijri': '17 Ramadhan', 'desc': 'Peringatan turunnya Al-Qur\'an'},
      {'title': 'Hari Raya Idul Fitri', 'hijri': '1 Syawwal', 'desc': 'Hari kemenangan umat Islam'},
      {'title': 'Puasa Sunnah Arafah', 'hijri': '9 Dzulhijjah', 'desc': 'Puasa menghapus dosa 2 tahun'},
      {'title': 'Hari Raya Idul Adha', 'hijri': '10 Dzulhijjah', 'desc': 'Hari raya kurban'},
      {'title': 'Hari Tasyrik', 'hijri': '11-13 Dzulhijjah', 'desc': 'Hari berkurban dan berdzikir'},
    ];

    final hijriMonths = [
      '1. Muharram', '2. Safar', '3. Rabi\'ul Awwal', '4. Rabi\'ul Akhir',
      '5. Jumadil Awwal', '6. Jumadil Akhir', '7. Rajab', '8. Sya\'ban',
      '9. Ramadhan', '10. Syawwal', '11. Dzulqa\'dah', '12. Dzulhijjah'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Kalender Hijriah', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Date Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3A26), Color(0xFF1E5B3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Hari Ini',
                    style: TextStyle(color: Color(0xFFE2B75A), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${now.day} ${_getMonthName(now.month)} ${now.year} M',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kalender Hijriah Berbasis Penanggalan Ummul Qura',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sunnah Fasting Reminder Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2B75A).withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFF0F3A26), size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Puasa Sunnah Ayyamul Bidh',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F3A26)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Dianjurkan setiap tanggal 13, 14, dan 15 pada bulan-bulan Hijriah.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 12 Hijri Months
            const Text(
              '12 Bulan Hijriah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F3A26)),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: hijriMonths.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    hijriMonths[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Important Events List
            const Text(
              'Hari Besar & Peristiwa Penting Islam',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F3A26)),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: islamicEvents.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final ev = islamicEvents[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3A26).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ev['hijri']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3A26),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ev['title']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ev['desc']!,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}
