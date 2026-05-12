import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'product_details_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Products'), centerTitle: true),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('saved_products')
            .orderBy('savedAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No saved products yet',

                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final savedProducts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: savedProducts.length,

            itemBuilder: (context, index) {
              final data = savedProducts[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,

                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,

                    child: const Icon(Icons.bookmark, color: Colors.green),
                  ),

                  title: Text(
                    data['productName'] ?? 'Unknown Product',

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(data['productId'] ?? ''),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: {
                            'id': data['productId'],

                            'name': data['productName'],
                          },
                        ),
                      ),
                    );
                  },

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('saved_products')
                          .doc(data['productId'])
                          .delete();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product Removed')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
