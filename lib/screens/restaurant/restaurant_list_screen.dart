import 'package:flutter/material.dart';

import '../../models/restaurant_model.dart';

import 'restaurant_details_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Restaurant> restaurants = [
      Restaurant(
        id: '1',

        name: 'Green Bites',

        location: 'Dhaka',

        rating: 4.8,

        hygieneStatus: 'Excellent',

        reviews: [],

        image: '',

        halal: true,
      ),

      Restaurant(
        id: '2',

        name: 'Burger Town',

        location: 'Chittagong',

        rating: 4.5,

        hygieneStatus: 'Good',

        reviews: [],

        image: '',

        halal: true,
      ),

      Restaurant(
        id: '3',

        name: 'Spicy Grill',

        location: 'Sylhet',

        rating: 4.2,

        hygieneStatus: 'Average',

        reviews: [],

        image: '',

        halal: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),

      body: ListView.builder(
        itemCount: restaurants.length,

        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

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
                restaurant.name,

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(restaurant.location),

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    restaurant.halal ? Icons.verified : Icons.warning,

                    color: restaurant.halal ? Colors.green : Colors.orange,
                  ),

                  const SizedBox(height: 4),

                  Text(restaurant.rating.toString()),
                ],
              ),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailsScreen(
                      restaurant: {
                        'id': restaurant.id,

                        'name': restaurant.name,

                        'location': restaurant.location,

                        'rating': restaurant.rating,

                        'halal': restaurant.halal,
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
