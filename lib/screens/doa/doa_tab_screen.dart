import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/doa_data.dart';
import '../../theme/app_theme.dart';

class DoaTabScreen extends StatefulWidget {
  const DoaTabScreen({super.key});

  @override
  State<DoaTabScreen> createState() => _DoaTabScreenState();
}

class _DoaTabScreenState extends State<DoaTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Semua';
  String _searchDoa = '';
  String _selectedDzikirType = 'shalat';
  final Map<int, int> _dzikirCounters = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Doa & Dzikir',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE2B75A),
          indicatorWeight: 3,
          labelColor: const Color(0xFFE2B75A),
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Doa Harian'),
            Tab(text: 'Dzikir'),
            Tab(text: 'Asmaul Husna'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDoaHarianTab(),
          _buildDzikirTab(),
          _buildAsmaulHusnaTab(),
        ],
      ),
    );
  }

  Widget _buildDoaHarianTab() {
    final isDark = context.isDark;
    final categories = [
      'Semua',
      'Tidur',
      'Makan & Minum',
      'Masjid',
      'Rumah',
      'Keluarga',
      'Umum',
      'Ilmu',
      'Kebersihan',
      'Perjalanan',
    ];

    final filtered = DoaData.doaHarian.where((d) {
      final matchesCat =
          _selectedCategory == 'Semua' || d.category == _selectedCategory;
      final matchesSearch =
          _searchDoa.isEmpty ||
          d.title.toLowerCase().contains(_searchDoa.toLowerCase()) ||
          d.translation.toLowerCase().contains(_searchDoa.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Column(
      children: [
        // Search Input
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDarkSecondary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TextField(
              style: TextStyle(color: context.textPrimary, fontSize: 13),
              onChanged: (val) => setState(() => _searchDoa = val),
              decoration: InputDecoration(
                hintText: 'Cari doa harian...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey[400],
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.primaryAdaptive,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),

        // Category Chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26),
                labelStyle: TextStyle(
                  color: isSelected
                      ? (isDark ? const Color(0xFFE2B75A) : Colors.white)
                      : context.textPrimary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: context.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? context.primaryAdaptive
                        : context.borderColor,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Doa List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada doa ditemukan.',
                    style: TextStyle(color: context.textSecondary),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final doa = filtered[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.badgeBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  doa.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: context.badgeIcon,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: context.textSecondary,
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          '${doa.title}\n\n${doa.arabic}\n\n${doa.latin}\n\nArtinya: ${doa.translation}\n(${doa.source})',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Doa disalin ke papan klip',
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doa.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            doa.arabic,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              color: context.arabicColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doa.latin,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: context.latinColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            doa.translation,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doa.source,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDzikirTab() {
    final isDark = context.isDark;
    final types = [
      {'key': 'shalat', 'label': 'Setelah Shalat'},
      {'key': 'pagi', 'label': 'Dzikir Pagi'},
      {'key': 'petang', 'label': 'Dzikir Petang'},
    ];

    final list = DoaData.dzikirList
        .where((d) => d.type == _selectedDzikirType)
        .toList();

    return Column(
      children: [
        const SizedBox(height: 12),
        // Type Selector
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: types.map((t) {
              final isSel = t['key'] == _selectedDzikirType;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDzikirType = t['key']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel
                          ? (isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      t['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel
                            ? (isDark ? const Color(0xFFE2B75A) : Colors.white)
                            : context.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = list[index];
              final currentCount = _dzikirCounters[item.id] ?? 0;
              final isComplete = currentCount >= item.count;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isComplete ? AppColors.accentEmerald : context.borderColor,
                    width: isComplete ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
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
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isComplete
                                ? AppColors.accentEmerald
                                : context.badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$currentCount / ${item.count}x',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isComplete
                                  ? Colors.white
                                  : context.badgeIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.arabic,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.8,
                        color: context.arabicColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.latin,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: context.latinColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.translation,
                      style: TextStyle(fontSize: 13, color: context.textSecondary),
                    ),
                    if (item.note.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.note,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    // Tap counter button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isComplete
                                  ? AppColors.accentEmerald
                                  : (isDark ? const Color(0xFF1B4D36) : const Color(0xFF0F3A26)),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(
                              isComplete ? Icons.check : Icons.fingerprint,
                              size: 20,
                            ),
                            label: Text(
                              isComplete
                                  ? 'Selesai (${item.count}x)'
                                  : 'Ketuk untuk Menghitung',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                if (currentCount < item.count) {
                                  _dzikirCounters[item.id] = currentCount + 1;
                                }
                              });
                            },
                          ),
                        ),
                        if (currentCount > 0) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              size: 20,
                              color: context.textSecondary,
                            ),
                            tooltip: 'Reset',
                            onPressed: () {
                              setState(() {
                                _dzikirCounters[item.id] = 0;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAsmaulHusnaTab() {
    final isDark = context.isDark;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: DoaData.asmaulHusna.length,
      itemBuilder: (context, index) {
        final item = DoaData.asmaulHusna[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2B75A).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.number}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.arabic,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.arabicColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.latin,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.latinColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.translation,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: context.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}
