import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/hadits_data.dart';
import '../../theme/app_theme.dart';

class HaditsScreen extends StatefulWidget {
  const HaditsScreen({super.key});

  @override
  State<HaditsScreen> createState() => _HaditsScreenState();
}

class _HaditsScreenState extends State<HaditsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HaditsItem> get _filteredHadits {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return HaditsData.arbain;

    // Check if searching by number (e.g. "1", "#1", "hadits 1", "hadis 1")
    final numMatch = RegExp(r'\b(\d+)\b').firstMatch(query);
    final searchNum = numMatch != null ? int.tryParse(numMatch.group(1)!) : null;

    final terms = query
        .replaceAll(RegExp(r'^(?:hadits|hadis)\s*'), '')
        .replaceAll(RegExp(r"['’\-]"), '')
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    return HaditsData.arbain.where((h) {
      if (searchNum != null && h.number == searchNum) return true;

      final combined = '${h.title} ${h.narrator} ${h.translation} ${h.arabic}'
          .toLowerCase()
          .replaceAll(RegExp(r"['’\-]"), '');
      
      // All terms must match somewhere in the hadits
      if (terms.isEmpty) return true;
      return terms.every((term) => combined.contains(term));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final haditsList = _filteredHadits;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Hadits Pilihan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : Colors.white,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkCardSurface : const Color(0xFF0F3A26),
        foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDarkSecondary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: context.textPrimary, fontSize: 13),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Cari hadits, nomor, perawi, atau isi...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.primaryAdaptive,
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18, color: context.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: haditsList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 60, color: context.textSecondary),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ditemukan hadits untuk "$_searchQuery"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Coba cari dengan kata kunci lain seperti nomor hadits (#1), nama perawi (Bukhari, Muslim, Umar), atau tema (niat, rukun islam, lisan).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: context.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: haditsList.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final h = haditsList[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCardElevated
                                  : const Color(0xFF0F3A26),
                              borderRadius: BorderRadius.circular(8),
                              border: isDark ? Border.all(color: context.borderColor) : null,
                            ),
                            child: Text(
                              'Hadits #${h.number}',
                              style: TextStyle(
                                color: isDark ? const Color(0xFFE2B75A) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy_rounded, size: 18, color: context.textSecondary),
                            tooltip: 'Salin Hadits',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                text: '${h.title}\n\n${h.arabic}\n\nArtinya: ${h.translation}\n(${h.narrator})',
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Hadits disalin ke papan klip'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        h.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        h.arabic,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                          color: context.arabicColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        h.translation,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        h.narrator,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: context.latinColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
