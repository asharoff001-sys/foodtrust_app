import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FoodTrustApp());
}

class FoodTrustApp extends StatelessWidget {
  const FoodTrustApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodTrust',
      theme: ThemeData.light(),
      home: SplashScreen(),
    );
  }
}
