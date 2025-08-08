import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/ui/providers/language_provider.dart';
import 'package:evently/ui/providers/theme_provider.dart';
import 'package:evently/ui/screens/login/login.dart';
import 'package:evently/ui/screens/splash/splash.dart';
import 'package:evently/ui/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAUE4lOt0X24bWlASU0NbeUNiigLmnlajg",
        appId: "1:49624288565:android:2715d0bddf2ccb9eedd07c",
        messagingSenderId: "49624288565",
        projectId: "evently-471c6"),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LanguageProvider languageProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of(context);
    themeProvider = Provider.of(context);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.mode,
      locale: Locale(languageProvider.currentLocale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: const Splash(),
    );
  }
}