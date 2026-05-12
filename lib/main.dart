import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FoodTrustApp());
}

class FoodTrustApp extends StatelessWidget {
  const FoodTrustApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'FoodTrust',

      theme: ThemeData(primarySwatch: Colors.green),

      home: const SplashScreen(),
    );
  }
}
