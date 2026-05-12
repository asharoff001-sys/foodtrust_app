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

    final halal = restaurant['halal'] == true;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? Colors.purpleAccent : Colors.green,

        foregroundColor: Colors.white,

        icon: const Icon(Icons.rate_review),

        label: const Text('Add Review'),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => AddReviewScreen(restaurantId: restaurantId),
            ),
          );
        },
      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,

            pinned: true,

            backgroundColor: isDark ? const Color(0xFF12121A) : Colors.green,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant['name'] ?? ''),

              background: Stack(
                fit: StackFit.expand,

                children: [
                  Image.network(
                    restaurant['image'] ?? '',

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark
                            ? const Color(0xFF1A1A24)
                            : Colors.grey.shade300,

                        child: Icon(
                          Icons.restaurant,

                          size: 90,

                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      );
                    },
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,

                        end: Alignment.bottomCenter,

                        colors: [
                          Colors.transparent,

                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          restaurant['location'] ?? '',

                          style: TextStyle(
                            fontSize: 16,

                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: [
                      buildBadge(
                        label: halal ? 'Halal Verified' : 'Needs Verification',

                        color: halal ? Colors.green : Colors.orange,

                        icon: halal ? Icons.verified : Icons.warning,
                      ),

                      buildBadge(
                        label: restaurant['hygieneStatus'] ?? 'Unknown',

                        color: Colors.blue,

                        icon: Icons.health_and_safety,
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  Text(
                    'Customer Reviews',

                    style: TextStyle(
                      fontSize: 24,

                      fontWeight: FontWeight.bold,

                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 18),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(restaurantId)
                        .collection('reviews')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),

                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(30),

                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1A1A24)
                                : Colors.grey.shade100,

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            children: [
                              Icon(
                                Icons.reviews_outlined,

                                size: 70,

                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade500,
                              ),

                              const SizedBox(height: 16),

                              Text(
                                'No reviews yet',

                                style: TextStyle(
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,

                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final reviews = snapshot.data!.docs;

                      return Column(
                        children: reviews.map((review) {
                          final data = review.data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),

                            child: ReviewCard(
                              username: data['username'] ?? '',

                              comment: data['comment'] ?? '',

                              rating: (data['rating'] ?? 0).toDouble(),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: color, size: 18),

          const SizedBox(width: 6),

          Text(
            label,

            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
