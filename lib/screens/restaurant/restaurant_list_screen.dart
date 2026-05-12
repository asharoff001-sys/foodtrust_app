import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'restaurant_details_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants'), centerTitle: true),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants...',

                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                    final name = (data['name'] ?? '').toString().toLowerCase();

                    if (!name.contains(searchText)) {
                      return const SizedBox();
                    }

                    final halal = data['halal'] == true;

                    return Card(
                      elevation: 4,

                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            data['image'] ?? '',

                            width: 60,

                            height: 60,

                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,

                                height: 60,

                                color: Colors.grey.shade300,

                                child: const Icon(Icons.restaurant),
                              );
                            },
                          ),
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

                            Text((data['rating'] ?? 0).toString()),
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
          ),
        ],
      ),
    );
  }
}
