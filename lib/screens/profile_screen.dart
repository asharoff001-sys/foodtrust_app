import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'scan_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 55,

              backgroundColor: Colors.green,

              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 25),

            Text(
              user?.email ?? 'No User Logged In',

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            buildOptionCard(
              context: context,

              icon: Icons.history,

              title: 'Recent Scans',

              subtitle: 'View your previously scanned products',

              color: Colors.green,

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

              color: Colors.orange,

              onTap: () {},
            ),

            const SizedBox(height: 16),

            buildOptionCard(
              context: context,

              icon: Icons.settings,

              title: 'Settings',

              subtitle: 'Preferences and app settings',

              color: Colors.blue,

              onTap: () {},
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

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
      elevation: 4,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: ListTile(
        contentPadding: const EdgeInsets.all(18),

        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),

          child: Icon(icon, color: color),
        ),

        title: Text(
          title,

          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(subtitle),
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 18),

        onTap: onTap,
      ),
    );
  }
}
