import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/shalat_data.dart';
import '../../models/shalat_model.dart';
import '../../theme/app_theme.dart';

class GerakanDetailScreen extends StatefulWidget {
  final int initialStep;

  const GerakanDetailScreen({super.key, this.initialStep = 0});

  @override
  State<GerakanDetailScreen> createState() => _GerakanDetailScreenState();
}

class _GerakanDetailScreenState extends State<GerakanDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialStep;
    _pageController = PageController(initialPage: widget.initialStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movements = ShalatData.gerakanShalatList;
    final totalSteps = movements.length;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Gerakan ${movements[_currentIndex].order} dari $totalSteps',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: context.isDark ? AppColors.darkTextPrimary : Colors.white,
          ),
        ),
        backgroundColor: context.isDark ? AppColors.darkCardSurface : const Color(0xFF0F3A26),
        foregroundColor: context.isDark ? AppColors.darkTextPrimary : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.list_alt_rounded,
              color: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
            ),
            tooltip: 'Daftar Gerakan',
            onPressed: () => _showStepsBottomSheet(context, movements),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Progress Bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / totalSteps,
            backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE2B75A)),
            minHeight: 4,
          ),

          // Horizontal mini pill indicator
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: context.isDark ? AppColors.darkCardSurface : Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: totalSteps,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26))
                          : (context.isDark ? AppColors.darkCardElevated : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE2B75A)
                            : (context.isDark ? context.borderColor : Colors.transparent),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? (context.isDark ? Colors.black : Colors.white)
                            : context.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // PageView for content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalSteps,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = movements[index];
                return _buildMovementCard(item);
              },
            ),
          ),

          // Navigation bottom bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkCardSurface : Colors.white,
              border: Border(top: BorderSide(color: context.borderColor)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Sebelumnya'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: context.isDark ? AppColors.darkTextPrimary : const Color(0xFF0F3A26),
                        side: BorderSide(
                          color: context.isDark ? context.borderColor : const Color(0xFF0F3A26),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex < totalSteps - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : () {
                              Navigator.pop(context);
                            },
                      icon: Icon(
                        _currentIndex < totalSteps - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_circle_rounded,
                      ),
                      label: Text(
                        _currentIndex < totalSteps - 1 ? 'Selanjutnya' : 'Selesai',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
                        foregroundColor: const Color(0xFFE2B75A),
                        side: context.isDark ? BorderSide(color: context.borderColor) : null,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(GerakanShalatItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration Image Card
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: context.isDark
                          ? AppColors.darkCardElevated
                          : const Color(0xFF0F3A26).withValues(alpha: 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.accessibility_new_rounded,
                            size: 64,
                            color: context.isDark
                                ? AppColors.gold.withValues(alpha: 0.5)
                                : const Color(0xFF0F3A26).withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: TextStyle(
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
                      borderRadius: BorderRadius.circular(8),
                      border: context.isDark ? Border.all(color: context.borderColor) : null,
                    ),
                    child: Text(
                      'Langkah ${item.order}',
                      style: const TextStyle(
                        color: Color(0xFFE2B75A),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Title & Description
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.isDark ? AppColors.darkTextPrimary : const Color(0xFF0F3A26),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Bacaan Shalat Card (Rukun Qauli)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.isDark ? context.borderColor : const Color(0xFFE2B75A).withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
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
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: context.isDark
                            ? AppColors.darkCardElevated
                            : const Color(0xFF0F3A26).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                            size: 15,
                            color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Bacaan Gerakan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      color: context.textSecondary,
                      tooltip: 'Salin Bacaan',
                      onPressed: () => _copyToClipboard(
                        '${item.arabic}\n\n${item.latin}\n\nArtinya:\n${item.translation}',
                        'Bacaan shalat',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  item.arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 2.0,
                    color: context.arabicColor,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.latin,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: context.latinColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(height: 24, color: context.borderColor),
                Text(
                  'Artinya:\n${item.translation}',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Tips & Rukun Shalat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkCardElevated : const Color(0xFFF1F8F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.isDark ? context.borderColor : const Color(0xFF0F3A26).withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFE2B75A),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petunjuk & Thuma’ninah',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.tips,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showStepsBottomSheet(
    BuildContext context,
    List<GerakanShalatItem> movements,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.isDark ? AppColors.darkCardSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.isDark ? AppColors.darkBorder : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daftar Langkah Gerakan Shalat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.isDark ? AppColors.darkTextPrimary : const Color(0xFF0F3A26),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: context.borderColor),
              Expanded(
                child: ListView.separated(
                  itemCount: movements.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: context.borderColor),
                  itemBuilder: (context, idx) {
                    final isCurrent = idx == _currentIndex;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isCurrent
                            ? (context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26))
                            : (context.isDark ? AppColors.darkCardElevated : const Color(0xFFF1F5F9)),
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? (context.isDark ? Colors.black : Colors.white)
                                : context.textSecondary,
                          ),
                        ),
                      ),
                      title: Text(
                        movements[idx].name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent
                              ? (context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26))
                              : context.textPrimary,
                        ),
                      ),
                      trailing: isCurrent
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pageController.jumpToPage(idx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
