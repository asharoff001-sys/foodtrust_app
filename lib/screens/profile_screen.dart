import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import '../core/theme_provider.dart';
import 'login_screen.dart';
import 'scan_history_screen.dart';
import 'saved_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(title: const Text('Profile'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(6),

              decoration: const BoxDecoration(
                shape: BoxShape.circle,

                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.pinkAccent],
                ),
              ),

              child: CircleAvatar(
                radius: 55,

                backgroundColor: Theme.of(context).cardColor,

                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              user?.email ?? 'No User Logged In',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            buildOptionCard(
              context: context,

              icon: Icons.history,

              title: 'Recent Scans',

              subtitle: 'View your previously scanned products',

              color: Colors.purpleAccent,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const ScanHistoryScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            buildOptionCard(
              context: context,

              icon: Icons.bookmark,

              title: 'Saved Products',

              subtitle: 'Your bookmarked food products',

              color: Colors.pinkAccent,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) => const SavedScreen()),
                );
              },
            ),

            const SizedBox(height: 16),

            buildOptionCard(
              context: context,

              icon: Icons.settings,

              title: 'Settings',

              subtitle: 'Preferences and app settings',

              color: Colors.blueAccent,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // THEME SWITCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      const Icon(Icons.dark_mode, color: Colors.purpleAccent),

                      const SizedBox(width: 12),

                      Text(
                        'Dark Mode',

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),

                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.isDarkMode,

                        activeColor: Colors.pinkAccent,

                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),

                    (route) => false,
                  );
                },

                icon: const Icon(Icons.logout, color: Colors.white),

                label: const Text(
                  'Logout',

                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Theme.of(context).cardColor,

      elevation: 4,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: ListTile(
        contentPadding: const EdgeInsets.all(18),

        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),

          child: Icon(icon, color: color),
        ),

        title: Text(
          title,

          style: TextStyle(
            fontWeight: FontWeight.bold,

            fontSize: 18,

            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(subtitle, style: TextStyle(color: Colors.grey.shade400)),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,

          size: 18,

          color: Colors.grey.shade500,
        ),

        onTap: onTap,
      ),
    );
  }
}
