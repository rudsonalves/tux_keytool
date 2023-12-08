import 'package:flutter/material.dart';

import 'common/singletons/app_settings.dart';
import 'common/themes/color_schemes.g.dart';
import 'features/home/home_page.dart';
import 'features/settings/settings_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appSettings = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appSettings.themeMode$,
      builder: (context, _) {
        return MaterialApp(
          themeMode: _appSettings.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            SettingsPage.routeName: (context) => const SettingsPage(),
          },
        );
      },
    );
  }
}
