import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().init();
  await NotificationService().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PreferencesService(),
      builder: (context, _) {
        final prefs = PreferencesService();
        return FeatureDiscovery(
          recordStepsInSharedPreferences: false,
          child: MaterialApp(
            title: 'Zelixa Islamic',
            debugShowCheckedModeBanner: false,
            themeMode: prefs.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
