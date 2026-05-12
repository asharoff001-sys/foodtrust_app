import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'restaurant_details_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants'), centerTitle: true),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No restaurants found'));
          }

          final restaurants = snapshot.data!.docs;

          return ListView.builder(
            itemCount: restaurants.length,

            itemBuilder: (context, index) {
              final restaurant = restaurants[index];

              final data = restaurant.data() as Map<String, dynamic>;

              final halal = data['halal'] == true;

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

                    child: const Icon(Icons.restaurant, color: Colors.green),
                  ),

                  title: Text(
                    data['name'] ?? '',

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(data['location'] ?? ''),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        halal ? Icons.verified : Icons.warning,

                        color: halal ? Colors.green : Colors.orange,
                      ),

                      const SizedBox(height: 4),

                      Text(data['rating'].toString()),
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsScreen(
                          restaurant: {'id': restaurant.id, ...data},
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
