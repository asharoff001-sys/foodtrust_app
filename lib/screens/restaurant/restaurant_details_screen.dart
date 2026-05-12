import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../reviews/add_review_screen.dart';
import '../../widgets/review_card.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final restaurantId = restaurant['id'];

    return Scaffold(
      appBar: AppBar(title: Text(restaurant['name'] ?? ''), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        child: const Icon(Icons.add),

        onPressed: () async {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => AddReviewScreen(restaurantId: restaurantId),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              height: 220,

              width: double.infinity,

              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(restaurant['image'] ?? ''),

                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    restaurant['name'] ?? '',

                    style: const TextStyle(
                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),

                      const SizedBox(width: 6),

                      Text(restaurant['location'] ?? ''),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Icon(
                        restaurant['halal'] == true
                            ? Icons.verified
                            : Icons.warning,

                        color: restaurant['halal'] == true
                            ? Colors.green
                            : Colors.orange,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        restaurant['halal'] == true
                            ? 'Halal Verified'
                            : 'Needs Verification',

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          color: restaurant['halal'] == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Hygiene Status: ${restaurant['hygieneStatus'] ?? ''}',

                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Customer Reviews',

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(restaurantId)
                        .collection('reviews')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No reviews yet');
                      }

                      final reviews = snapshot.data!.docs;

                      return Column(
                        children: reviews.map((review) {
                          final data = review.data() as Map<String, dynamic>;

                          return ReviewCard(
                            username: data['username'] ?? '',

                            comment: data['comment'] ?? '',

                            rating: (data['rating'] ?? 0).toDouble(),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
