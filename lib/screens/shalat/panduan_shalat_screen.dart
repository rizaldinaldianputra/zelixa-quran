import 'package:flutter/material.dart';

import '../../data/shalat_data.dart';
import '../../models/shalat_model.dart';
import '../../theme/app_theme.dart';
import 'gerakan_detail_screen.dart';
import 'shalat_detail_screen.dart';

class PanduanShalatScreen extends StatefulWidget {
  final int initialTabIndex;

  const PanduanShalatScreen({super.key, this.initialTabIndex = 0});

  @override
  State<PanduanShalatScreen> createState() => _PanduanShalatScreenState();
}

class _PanduanShalatScreenState extends State<PanduanShalatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Panduan Shalat Lengkap',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? AppColors.appBarDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    cursorColor: const Color(0xFFE2B75A),
                    decoration: InputDecoration(
                      hintText: 'Cari nama shalat atau gerakan...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFFE2B75A),
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              // TabBar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFFE2B75A),
                indicatorWeight: 3,
                labelColor: const Color(0xFFE2B75A),
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Gerakan Shalat'),
                  Tab(text: 'Shalat Fardhu'),
                  Tab(text: 'Shalat Sunnah'),
                  Tab(text: 'Jenazah & Khusus'),
                  Tab(text: 'Wudhu & Syarat'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _searchQuery.isNotEmpty
          ? _buildSearchResults()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGerakanTab(),
                _buildShalatListTab(ShalatData.shalatFardhuList),
                _buildShalatListTab(ShalatData.shalatSunnahList),
                _buildShalatListTab(ShalatData.shalatKhususList),
                _buildWudhuSyaratTab(),
              ],
            ),
    );
  }

  // ==========================================
  // TAB 1: GERAKAN SHALAT
  // ==========================================
  Widget _buildGerakanTab() {
    final movements = ShalatData.gerakanShalatList;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Interactive Hero Banner
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GerakanDetailScreen(initialStep: 0),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3A26), Color(0xFF1E5B3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F3A26).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2B75A).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Mode Interaktif',
                          style: TextStyle(
                            color: Color(0xFFE2B75A),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Mulai Panduan Visual Gerakan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pelajari 12 gerakan rukun shalat disertai ilustrasi dan audio bacaan.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2B75A),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF0F3A26),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Section Title
        Row(
          children: [
            Icon(Icons.directions_walk_rounded, color: context.primaryAdaptive, size: 18),
            const SizedBox(width: 8),
            Text(
              'Daftar Langkah Gerakan Shalat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.primaryAdaptive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Movements List
        ...movements.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return _buildMovementListTile(item, idx);
        }),
      ],
    );
  }

  Widget _buildMovementListTile(GerakanShalatItem item, int index) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GerakanDetailScreen(initialStep: index),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
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
          child: Row(
            children: [
              // Image thumbnail or badge
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: context.badgeBg,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.order}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.badgeIcon,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.badgeBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Langkah ${item.order}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: context.badgeIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.latin,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2, 3, 4: LIST OF SHALAT ITEMS
  // ==========================================
  Widget _buildShalatListTab(List<ShalatItem> items) {
    final isDark = context.isDark;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShalatDetailScreen(shalat: item),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.badgeBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    color: context.badgeIcon,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.hukum,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.accentGold : const Color(0xFFB38928),
                              ),
                            ),
                          ),
                          if (item.rakaat > 0) ...[
                            const SizedBox(width: 6),
                            Text(
                              '• ${item.rakaat} Rakaat',
                              style: TextStyle(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 5: WUDHU & SYARAT SHALAT
  // ==========================================
  Widget _buildWudhuSyaratTab() {
    final isDark = context.isDark;
    final wudhuList = ShalatData.panduanWudhuList;
    final rukunSyarat = ShalatData.rukunSyaratList;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Wudhu
        Row(
          children: [
            Icon(Icons.water_drop_rounded, color: context.primaryAdaptive, size: 20),
            const SizedBox(width: 8),
            Text(
              'Panduan Berwudhu (8 Langkah)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.primaryAdaptive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...wudhuList.map((w) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      w.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: context.badgeBg,
                        alignment: Alignment.center,
                        child: Text(
                          '${w.step}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.badgeIcon,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${w.step}. ${w.title}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        w.description,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: context.textSecondary,
                        ),
                      ),
                      if (w.arabic != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          w.arabic!,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                            color: context.arabicColor,
                          ),
                        ),
                        if (w.latin != null)
                          Text(
                            w.latin!,
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: context.latinColor,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // Header Rukun & Syarat
        Row(
          children: [
            Icon(Icons.menu_book_rounded, color: context.primaryAdaptive, size: 20),
            const SizedBox(width: 8),
            Text(
              'Ketentuan & Fiqih Shalat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.primaryAdaptive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...rukunSyarat.map((section) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                section.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.primaryAdaptive,
                ),
              ),
              leading: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFFE2B75A),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: section.items.map((it) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                color: context.primaryAdaptive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                it,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: context.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  // ==========================================
  // SEARCH RESULTS
  // ==========================================
  Widget _buildSearchResults() {
    final isDark = context.isDark;
    final allShalat = [
      ...ShalatData.shalatFardhuList,
      ...ShalatData.shalatSunnahList,
      ...ShalatData.shalatKhususList,
    ];

    final filteredShalat = allShalat.where((s) {
      return s.name.toLowerCase().contains(_searchQuery) ||
          s.description.toLowerCase().contains(_searchQuery) ||
          s.hukum.toLowerCase().contains(_searchQuery);
    }).toList();

    final filteredGerakan = ShalatData.gerakanShalatList.where((g) {
      return g.name.toLowerCase().contains(_searchQuery) ||
          g.description.toLowerCase().contains(_searchQuery) ||
          g.latin.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredShalat.isEmpty && filteredGerakan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: context.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Tidak ditemukan shalat dengan kata "$_searchQuery"',
              style: TextStyle(color: context.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredShalat.isNotEmpty) ...[
          Text(
            'Hasil Pencarian Shalat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.primaryAdaptive,
            ),
          ),
          const SizedBox(height: 10),
          ...filteredShalat.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.badgeBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.mosque_rounded, color: context.badgeIcon),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: context.textPrimary),
                  ),
                  subtitle: Text(
                    '${item.hukum} • ${item.waktu}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                  ),
                  trailing: Icon(Icons.chevron_right, color: context.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShalatDetailScreen(shalat: item),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        if (filteredGerakan.isNotEmpty) ...[
          Text(
            'Hasil Pencarian Gerakan Shalat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.primaryAdaptive,
            ),
          ),
          const SizedBox(height: 10),
          ...filteredGerakan.map((g) {
            final idx = ShalatData.gerakanShalatList.indexOf(g);
            return _buildMovementListTile(g, idx);
          }),
        ],
      ],
    );
  }
}
