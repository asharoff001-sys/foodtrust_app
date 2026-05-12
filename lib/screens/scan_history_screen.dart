import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recent Scans'), centerTitle: true),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scan_history')
            .orderBy('scannedAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No scan history yet',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final scans = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scans.length,

            itemBuilder: (context, index) {
              final data = scans[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,

                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: CircleAvatar(
                    radius: 28,

                    backgroundColor: Colors.green.shade100,

                    child: const Icon(Icons.history, color: Colors.green),
                  ),

                  title: Text(
                    data['productName'] ?? 'Unknown Product',

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(data['productId'] ?? ''),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
