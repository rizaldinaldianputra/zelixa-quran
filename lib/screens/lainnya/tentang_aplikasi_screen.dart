import 'package:flutter/material.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Logo & Title
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3A26),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F3A26).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFFE2B75A),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Zelixa Islamic',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3A26),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Description Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Text(
                'Zelixa Islamic adalah aplikasi Al-Qur\'an digital modern, cepat, dan mudah digunakan yang dirancang untuk menemani ibadah harian kaum muslimin. Dilengkapi dengan Al-Qur\'an lengkap 30 juz, transliterasi Latin, terjemahan resmi Kemenag RI, audio tilawah per ayat, doa harian, dzikir, jadwal shalat akurat, kompas arah kiblat, serta tasbih digital.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Source & Acknowledgements
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sumber Data & Kredit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0F3A26),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCreditRow(
                    Icons.book,
                    'Teks Arab & Terjemahan',
                    'Kementerian Agama Republik Indonesia (Kemenag RI)',
                  ),
                  const SizedBox(height: 10),
                  _buildCreditRow(
                    Icons.audiotrack,
                    'Murottal Audio',
                    'Syaikh Misyari Rasyid Al-Afasi',
                  ),
                  const SizedBox(height: 10),
                  _buildCreditRow(
                    Icons.calendar_today,
                    'Jadwal Shalat',
                    'Algoritma Perhitungan Astronomi Kemenag',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Dibuat dengan ❤️ untuk Umat',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F3A26)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
