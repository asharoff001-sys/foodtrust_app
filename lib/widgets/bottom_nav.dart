import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

import '../screens/profile_screen.dart';

import '../screens/saved_screen.dart';

import '../screens/scanner_screen.dart';

import '../screens/ingredient_checker_screen.dart';

import '../screens/restaurant/restaurant_list_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),

    const RestaurantListScreen(),

    const ScannerScreen(),

    const IngredientCheckerScreen(),

    const SavedScreen(),

    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.green,

        unselectedItemColor: Colors.grey,

        showUnselectedLabels: true,

        elevation: 10,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),

            label: 'Restaurants',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),

            label: 'Scan',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),

            label: 'AI Check',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
