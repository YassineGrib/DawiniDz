import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'themes/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'constants/app_constants.dart';
import 'utils/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Seed sample data
  await DataSeeder.seedSampleData();

  runApp(const DawiniDzApp());
}

class DawiniDzApp extends StatelessWidget {
  const DawiniDzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Localization Configuration
      locale: const Locale('ar', 'DZ'), // Default to Arabic (Algeria)
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // RTL Support
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Force RTL for Arabic
          child: child!,
        );
      },

      // Home Screen
      home: const SplashScreen(),
    );
  }
}
