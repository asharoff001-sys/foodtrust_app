import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(title: const Text('Settings')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          buildTile(
            context,

            icon: Icons.dark_mode,

            title: 'Theme',

            subtitle: isDark ? 'Dark Mode Enabled' : 'Light Mode Enabled',

            onTap: () {},
          ),

          buildTile(
            context,

            icon: Icons.info_outline,

            title: 'About FoodTrust',

            subtitle: 'Learn more about the app',

            onTap: () {},
          ),

          buildTile(
            context,

            icon: Icons.privacy_tip_outlined,

            title: 'Privacy Policy',

            subtitle: 'Read our privacy information',

            onTap: () {},
          ),

          buildTile(
            context,

            icon: Icons.notifications_none,

            title: 'Notifications',

            subtitle: 'Manage future notifications',

            onTap: () {},
          ),

          buildTile(
            context,

            icon: Icons.bug_report_outlined,

            title: 'Debug / Report Issue',

            subtitle: 'Send bug reports and feedback',

            onTap: () {
              showReportDialog(context);
            },
          ),

          buildTile(
            context,

            icon: Icons.contact_mail_outlined,

            title: 'Contact',

            subtitle: 'foodtrust@gmail.com',

            onTap: () {},
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              'FoodTrust v1.0',

              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Theme.of(context).cardColor,

      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: Colors.purpleAccent.withOpacity(0.15),

          child: Icon(icon, color: Colors.purpleAccent),
        ),

        title: Text(
          title,

          style: TextStyle(
            fontWeight: FontWeight.bold,

            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }

  void showReportDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Report Issue'),

          content: TextField(
            controller: controller,

            maxLines: 5,

            decoration: const InputDecoration(
              hintText: 'Describe the issue or feedback...',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final text = controller.text.trim();

                if (text.isEmpty) {
                  return;
                }

                await FirebaseFirestore.instance.collection('reports').add({
                  'message': text,

                  'createdAt': Timestamp.now(),
                });

                if (!context.mounted) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report submitted successfully'),
                  ),
                );
              },

              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
