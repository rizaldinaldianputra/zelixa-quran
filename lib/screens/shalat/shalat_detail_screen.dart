import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/shalat_model.dart';
import 'gerakan_detail_screen.dart';

class ShalatDetailScreen extends StatefulWidget {
  final ShalatItem shalat;

  const ShalatDetailScreen({super.key, required this.shalat});

  @override
  State<ShalatDetailScreen> createState() => _ShalatDetailScreenState();
}

class _ShalatDetailScreenState extends State<ShalatDetailScreen> {
  int _selectedNiatIndex = 0; // 0: Sendiri, 1: Makmum, 2: Imam

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F3A26),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shalat = widget.shalat;
    final hasVariants = shalat.niatMakmumArab != null || shalat.niatImamArab != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          shalat.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Card
            _buildHeaderCard(shalat),
            const SizedBox(height: 16),

            // Niat Shalat Card
            _buildNiatCard(shalat, hasVariants),
            const SizedBox(height: 16),

            // Keutamaan Card
            _buildKeutamaanCard(shalat),
            const SizedBox(height: 16),

            // Tata Cara Pelaksanaan
            _buildTataCaraCard(shalat),
            const SizedBox(height: 16),

            // Doa Khusus (if any)
            if (shalat.doaKhususArab != null) ...[
              _buildDoaKhususCard(shalat),
              const SizedBox(height: 16),
            ],

            // Action: Panduan Gerakan Visual
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GerakanDetailScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.accessibility_new_rounded),
              label: const Text(
                'Lihat Panduan Visual Gerakan Shalat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0F3A26),
                foregroundColor: const Color(0xFFE2B75A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ShalatItem shalat) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3A26), Color(0xFF1B5E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3A26).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2B75A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2B75A).withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  shalat.hukum,
                  style: const TextStyle(
                    color: Color(0xFFE2B75A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (shalat.rakaat > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.repeat_rounded,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${shalat.rakaat} Rakaat',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            shalat.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shalat.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: [
              const Icon(
                Icons.access_time_filled,
                color: Color(0xFFE2B75A),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  shalat.waktu,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNiatCard(ShalatItem shalat, bool hasVariants) {
    String currentArab = shalat.niatArab;
    String currentLatin = shalat.niatLatin;
    String currentArti = shalat.niatArti;

    if (_selectedNiatIndex == 1 && shalat.niatMakmumArab != null) {
      currentArab = shalat.niatMakmumArab!;
      currentLatin = shalat.niatMakmumLatin ?? '';
      currentArti = shalat.niatMakmumArti ?? '';
    } else if (_selectedNiatIndex == 2 && shalat.niatImamArab != null) {
      currentArab = shalat.niatImamArab!;
      currentLatin = shalat.niatImamLatin ?? '';
      currentArti = shalat.niatImamArti ?? '';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2B75A).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFF0F3A26),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Lafadz Niat Shalat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3A26),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                color: Colors.grey[700],
                tooltip: 'Salin Niat',
                onPressed: () => _copyToClipboard(
                  '$currentArab\n\n$currentLatin\n\nArtinya:\n$currentArti',
                  'Lafadz Niat',
                ),
              ),
            ],
          ),

          // Variants Toggle if applicable
          if (hasVariants) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  _buildNiatTabButton('Sendirian', 0),
                  if (shalat.niatMakmumArab != null)
                    _buildNiatTabButton('Makmum', 1),
                  if (shalat.niatImamArab != null)
                    _buildNiatTabButton('Imam', 2),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Arabic
          Text(
            currentArab,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 2.1,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),

          // Latin
          Text(
            currentLatin,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F3A26),
            ),
          ),
          const Divider(height: 24),

          // Arti
          Text(
            'Artinya:\n$currentArti',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNiatTabButton(String label, int index) {
    final isSelected = _selectedNiatIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNiatIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F3A26) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeutamaanCard(ShalatItem shalat) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0F3A26).withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.stars_rounded,
                color: Color(0xFFE2B75A),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Keutamaan & Dalil',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            shalat.keutamaan,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTataCaraCard(ShalatItem shalat) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.format_list_numbered_rounded,
                color: Color(0xFF0F3A26),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Tata Cara Pelaksanaan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...shalat.tataCara.asMap().entries.map((entry) {
            final idx = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3A26).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${idx + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F3A26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDoaKhususCard(ShalatItem shalat) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2B75A).withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.volunteer_activism_rounded,
                    color: Color(0xFF0F3A26),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Doa Khusus ${shalat.name}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3A26),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                color: Colors.grey[700],
                tooltip: 'Salin Doa',
                onPressed: () => _copyToClipboard(
                  '${shalat.doaKhususArab}\n\n${shalat.doaKhususLatin}\n\nArtinya:\n${shalat.doaKhususArti}',
                  'Doa khusus',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            shalat.doaKhususArab ?? '',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 2.1,
              color: Color(0xFF1E293B),
            ),
          ),
          if (shalat.doaKhususLatin != null) ...[
            const SizedBox(height: 14),
            Text(
              shalat.doaKhususLatin!,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F3A26),
              ),
            ),
          ],
          if (shalat.doaKhususArti != null) ...[
            const Divider(height: 24),
            Text(
              'Artinya:\n${shalat.doaKhususArti}',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
