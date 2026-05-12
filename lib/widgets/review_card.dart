import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String username;

  final String comment;

  final double rating;

  const ReviewCard({
    super.key,

    required this.username,

    required this.comment,

    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,

                      child: const Icon(Icons.person, color: Colors.green),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      username,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 17,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),

                      const SizedBox(width: 4),

                      Text(
                        rating.toStringAsFixed(1),

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(comment, style: const TextStyle(height: 1.5, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
