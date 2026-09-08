import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'home/home_dashboard_screen.dart';
import 'quran/quran_tab_screen.dart';
import 'doa/doa_tab_screen.dart';
import 'ibadah/ibadah_tab_screen.dart';
import 'lainnya/lainnya_tab_screen.dart';

import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = PreferencesService();
      if (prefs.isFirstTimeFeatureDiscovery) {
        FeatureDiscovery.discoverFeatures(
          context,
          <String>{
            'feature_quran_tab',
            'feature_ibadah_tab',
          },
        );
        prefs.setFeatureDiscoveryShown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeDashboardScreen(
        onNavigateTab: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
      ),
      const QuranTabScreen(),
      const DoaTabScreen(),
      const IbadahTabScreen(),
      const LainnyaTabScreen(),
    ];

    final isDark = context.isDark;
    final selectedIconColor = isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26);
    final unselectedIconColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: context.cardColor,
          indicatorColor: const Color(0xFFE2B75A).withValues(alpha: 0.25),
          elevation: 0,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: unselectedIconColor),
              selectedIcon: Icon(Icons.home, color: selectedIconColor),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: DescribedFeatureOverlay(
                featureId: 'feature_quran_tab',
                tapTarget: Icon(Icons.menu_book_outlined, color: unselectedIconColor),
                title: const Text('Al-Qur\'an'),
                description: const Text('Baca dan dengarkan ayat suci di sini.'),
                backgroundColor: const Color(0xFF0F3A26),
                targetColor: const Color(0xFFE2B75A),
                textColor: Colors.white,
                child: Icon(Icons.menu_book_outlined, color: unselectedIconColor),
              ),
              selectedIcon: Icon(Icons.menu_book, color: selectedIconColor),
              label: 'Al-Qur\'an',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism_outlined, color: unselectedIconColor),
              selectedIcon: Icon(Icons.volunteer_activism, color: selectedIconColor),
              label: 'Doa',
            ),
            NavigationDestination(
              icon: DescribedFeatureOverlay(
                featureId: 'feature_ibadah_tab',
                tapTarget: Icon(Icons.mosque_outlined, color: unselectedIconColor),
                title: const Text('Ibadah'),
                description: const Text('Jadwal shalat, arah kiblat, dan tasbih digital.'),
                backgroundColor: const Color(0xFF0F3A26),
                targetColor: const Color(0xFFE2B75A),
                textColor: Colors.white,
                child: Icon(Icons.mosque_outlined, color: unselectedIconColor),
              ),
              selectedIcon: Icon(Icons.mosque, color: selectedIconColor),
              label: 'Ibadah',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined, color: unselectedIconColor),
              selectedIcon: Icon(Icons.more_horiz, color: selectedIconColor),
              label: 'Lainnya',
            ),
          ],
        ),
      ),
    );
  }
}
