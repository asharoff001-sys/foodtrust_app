import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'core/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),

      child: const FoodTrustApp(),
    ),
  );
}

class FoodTrustApp extends StatelessWidget {
  const FoodTrustApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'FoodTrust',

      themeMode: themeProvider.themeMode,

      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

        scaffoldBackgroundColor: Colors.white,

        cardColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,

          foregroundColor: Colors.black,

          centerTitle: true,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),

          bodyMedium: TextStyle(color: Colors.black87),

          titleLarge: TextStyle(color: Colors.black),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,

          fillColor: Colors.grey.shade100,

          hintStyle: const TextStyle(color: Colors.grey),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: const BorderSide(color: Colors.green, width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,

            foregroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0F0F14),

        cardColor: const Color(0xFF1A1A24),

        colorScheme: const ColorScheme.dark(
          primary: Colors.purpleAccent,

          secondary: Colors.pinkAccent,

          surface: Color(0xFF1A1A24),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF12121A),

          foregroundColor: Colors.white,

          centerTitle: true,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),

          bodyMedium: TextStyle(color: Colors.white70),

          titleLarge: TextStyle(color: Colors.white),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,

          fillColor: const Color(0xFF1E1E2A),

          hintStyle: const TextStyle(color: Colors.grey),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: const BorderSide(
              color: Colors.purpleAccent,

              width: 1.5,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,

            foregroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF232332),

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
