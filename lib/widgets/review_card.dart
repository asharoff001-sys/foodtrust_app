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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: Theme.of(context).cardColor,

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
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isDark
                            ? const Color(0xFF2A1F3D)
                            : Colors.green.shade100,

                        child: Icon(
                          Icons.person,

                          color: isDark ? Colors.purpleAccent : Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          username,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 17,

                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.amber.withOpacity(0.18)
                        : Colors.amber.shade100,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),

                      const SizedBox(width: 4),

                      Text(
                        rating.toStringAsFixed(1),

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              comment,

              style: TextStyle(
                height: 1.5,

                fontSize: 15,

                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
