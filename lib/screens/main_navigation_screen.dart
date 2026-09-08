import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'home/home_dashboard_screen.dart';
import 'quran/quran_tab_screen.dart';
import 'doa/doa_tab_screen.dart';
import 'ibadah/ibadah_tab_screen.dart';
import 'lainnya/lainnya_tab_screen.dart';

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
      FeatureDiscovery.discoverFeatures(
        context,
        <String>{
          'feature_quran_tab',
          'feature_ibadah_tab',
        },
      );
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

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE2B75A).withValues(alpha: 0.25),
          elevation: 0,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFF0F3A26)),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: DescribedFeatureOverlay(
                featureId: 'feature_quran_tab',
                tapTarget: Icon(Icons.menu_book_outlined),
                title: Text('Al-Qur\'an'),
                description: Text('Baca dan dengarkan ayat suci di sini.'),
                backgroundColor: Color(0xFF0F3A26),
                targetColor: Color(0xFFE2B75A),
                textColor: Colors.white,
                child: Icon(Icons.menu_book_outlined),
              ),
              selectedIcon: Icon(Icons.menu_book, color: Color(0xFF0F3A26)),
              label: 'Al-Qur\'an',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism_outlined),
              selectedIcon: Icon(Icons.volunteer_activism, color: Color(0xFF0F3A26)),
              label: 'Doa',
            ),
            NavigationDestination(
              icon: DescribedFeatureOverlay(
                featureId: 'feature_ibadah_tab',
                tapTarget: Icon(Icons.mosque_outlined),
                title: Text('Ibadah'),
                description: Text('Jadwal shalat, arah kiblat, dan tasbih digital.'),
                backgroundColor: Color(0xFF0F3A26),
                targetColor: Color(0xFFE2B75A),
                textColor: Colors.white,
                child: Icon(Icons.mosque_outlined),
              ),
              selectedIcon: Icon(Icons.mosque, color: Color(0xFF0F3A26)),
              label: 'Ibadah',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz, color: Color(0xFF0F3A26)),
              label: 'Lainnya',
            ),
          ],
        ),
      ),
    );
  }
}
