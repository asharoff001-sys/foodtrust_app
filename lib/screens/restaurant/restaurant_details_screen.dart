import 'package:flutter/material.dart';

import '../../widgets/review_card.dart';
import '../../models/review_model.dart';

import '../reviews/add_review_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final List<Review> reviews = [
    Review(
      id: '1',

      userName: 'Yasin',

      rating: 4.8,

      comment: 'Very clean restaurant and trustworthy halal food.',

      date: '2026-05-12',
    ),

    Review(
      id: '2',

      userName: 'Sarah',

      rating: 4.5,

      comment: 'Loved the food quality and environment.',

      date: '2026-05-11',
    ),

    Review(
      id: '3',

      userName: 'Ahmed',

      rating: 4.2,

      comment: 'Good service but verification should improve.',

      date: '2026-05-10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final halal = widget.restaurant['halal'] == true;

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant['name'])),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            Center(
              child: CircleAvatar(
                radius: 55,

                backgroundColor: Colors.green.shade100,

                child: const Icon(
                  Icons.restaurant,

                  size: 55,

                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              widget.restaurant['name'],

              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              widget.restaurant['location'],

              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: halal ? Colors.green.shade50 : Colors.orange.shade50,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  Icon(
                    halal ? Icons.verified : Icons.warning,

                    color: halal ? Colors.green : Colors.orange,

                    size: 32,
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        halal ? 'Halal Verified' : 'Needs Verification',

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: halal ? Colors.green : Colors.orange,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        halal ? 'Trusted restaurant' : 'Please verify status',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),

                const SizedBox(width: 8),

                Text(
                  widget.restaurant['rating'].toString(),

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'About',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              'This restaurant is listed on FoodTrust for halal food verification and community trust tracking.',

              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Reviews',

                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    final review = await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const AddReviewScreen(),
                      ),
                    );

                    if (review != null) {
                      setState(() {
                        reviews.insert(
                          0,

                          Review(
                            id: DateTime.now().toString(),

                            userName: review['username'],

                            rating: review['rating'],

                            comment: review['comment'],

                            date: DateTime.now().toString(),
                          ),
                        );
                      });
                    }
                  },

                  icon: const Icon(Icons.add),

                  label: const Text('Add Review'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ...reviews.map(
              (review) => ReviewCard(
                username: review.userName,

                rating: review.rating,

                comment: review.comment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
