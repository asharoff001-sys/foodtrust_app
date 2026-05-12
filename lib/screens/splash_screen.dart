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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController logoController;

  late AnimationController textController;

  late Animation<double> logoScale;

  late Animation<double> logoRotation;

  late Animation<double> textOpacity;

  late Animation<Offset> textSlide;

  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    );

    textController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1200),
    );

    logoScale = CurvedAnimation(
      parent: logoController,

      curve: Curves.elasticOut,
    );

    logoRotation = Tween<double>(
      begin: -0.15,

      end: 0,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeOut));

    textOpacity = Tween<double>(
      begin: 0,

      end: 1,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));

    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),

      end: Offset.zero,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeOut));

    startAnimations();

    Timer(const Duration(seconds: 4), () {
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

  Future<void> startAnimations() async {
    await logoController.forward();

    await textController.forward();
  }

  @override
  void dispose() {
    logoController.dispose();

    textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F14) : Colors.green,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            AnimatedBuilder(
              animation: logoController,

              builder: (context, child) {
                return Transform.rotate(
                  angle: logoRotation.value,

                  child: Transform.scale(
                    scale: logoScale.value,

                    child: Container(
                      padding: const EdgeInsets.all(28),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          colors: isDark
                              ? [Colors.purpleAccent, Colors.pinkAccent]
                              : [Colors.white, Colors.white70],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.purpleAccent.withOpacity(0.35)
                                : Colors.black.withOpacity(0.15),

                            blurRadius: 30,

                            spreadRadius: 4,
                          ),
                        ],
                      ),

                      child: Image.asset(
                        'assets/images/logo.png',

                        width: 90,

                        height: 90,

                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            FadeTransition(
              opacity: textOpacity,

              child: SlideTransition(
                position: textSlide,

                child: Column(
                  children: [
                    const Text(
                      'FoodTrust',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 42,

                        fontWeight: FontWeight.bold,

                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Trusted Halal Verification',

                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),

                        fontSize: 16,

                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            SizedBox(
              width: 34,
              height: 34,

              child: CircularProgressIndicator(
                strokeWidth: 3,

                color: isDark ? Colors.pinkAccent : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
