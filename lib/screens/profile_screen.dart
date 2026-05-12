import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const CircleAvatar(
              radius: 55,

              backgroundColor: Colors.green,

              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 30),

            Text(
              user?.email ?? 'No User Logged In',

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton.icon(
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

                icon: const Icon(Icons.logout),

                label: const Text('Logout', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
