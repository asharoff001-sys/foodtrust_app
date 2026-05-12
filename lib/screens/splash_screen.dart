import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,

          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      } else {
        Navigator.pushReplacement(
          context,

          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(24),

              decoration: const BoxDecoration(
                color: Colors.white,

                shape: BoxShape.circle,
              ),

              child: const Icon(Icons.verified, size: 80, color: Colors.green),
            ),

            const SizedBox(height: 30),

            const Text(
              'FoodTrust',

              style: TextStyle(
                color: Colors.white,

                fontSize: 40,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Trusted Halal Verification',

              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
