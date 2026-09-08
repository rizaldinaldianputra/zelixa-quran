import 'package:flutter/material.dart';

import '../../services/settings_service.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  double _fontSize = 24.0;
  bool _showLatin = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final size = await SettingsService.getArabicFontSize();
    final latin = await SettingsService.getShowLatin();
    final trans = await SettingsService.getShowTranslation();

    if (mounted) {
      setState(() {
        _fontSize = size;
        _showLatin = latin;
        _showTranslation = trans;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pratinjau Teks',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F3A26),
                  ),
                ),
                if (_showLatin) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Bismillāhir-raḥmānir-raḥīm(i)',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
                if (_showTranslation) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tampilan Al-Quran Section
          const Text(
            'Tampilan Al-Qur\'an',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F3A26),
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ukuran Font Arab',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          Text(
                            '${_fontSize.toInt()} pt',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F3A26)),
                          ),
                        ],
                      ),
                      Slider(
                        value: _fontSize,
                        min: 18.0,
                        max: 36.0,
                        divisions: 9,
                        activeColor: const Color(0xFF0F3A26),
                        onChanged: (val) {
                          setState(() => _fontSize = val);
                          SettingsService.setArabicFontSize(val);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Tampilkan Teks Latin (Transliterasi)', style: TextStyle(fontSize: 14)),
                  value: _showLatin,
                  activeThumbColor: const Color(0xFF0F3A26),
                  onChanged: (val) {
                    setState(() => _showLatin = val);
                    SettingsService.setShowLatin(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Tampilkan Terjemahan Bahasa Indonesia', style: TextStyle(fontSize: 14)),
                  value: _showTranslation,
                  activeThumbColor: const Color(0xFF0F3A26),
                  onChanged: (val) {
                    setState(() => _showTranslation = val);
                    SettingsService.setShowTranslation(val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
