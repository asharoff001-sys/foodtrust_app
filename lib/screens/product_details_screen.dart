import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isSaved = false;

  Future<void> saveProduct() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_products')
        .doc(widget.product['id'].toString())
        .set({
          'productId': widget.product['id'].toString(),
          'productName': widget.product['name'] ?? '',
          'savedAt': Timestamp.now(),
        });

    setState(() {
      isSaved = true;
    });

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product Saved')));
  }

  Color getSafetyColor(double score) {
    if (score >= 8) {
      return Colors.green;
    }

    if (score >= 5) {
      return Colors.orange;
    }

    return Colors.red;
  }

  String getSafetyLabel(double score) {
    if (score >= 8) {
      return 'Safe';
    }

    if (score >= 5) {
      return 'Moderate';
    }

    return 'Risky';
  }

  @override
  Widget build(BuildContext context) {
    final halal = widget.product['halal'] == true;

    final vegan = widget.product['vegan'] == true;

    final safetyScore = (widget.product['safetyScore'] ?? 0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Product'),

        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),

            onPressed: saveProduct,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),

              child: Image.network(
                widget.product['image'] ?? '',

                height: 240,

                width: double.infinity,

                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 240,

                    color: Colors.grey.shade300,

                    child: const Icon(Icons.fastfood, size: 80),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            Text(
              widget.product['name'] ?? '',

              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              widget.product['brand'] ?? '',

              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 25),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: [
                buildBadge(
                  label: halal ? 'Halal' : 'Not Verified',

                  color: halal ? Colors.green : Colors.orange,

                  icon: halal ? Icons.verified : Icons.warning,
                ),

                buildBadge(
                  label: getSafetyLabel(safetyScore),

                  color: getSafetyColor(safetyScore),

                  icon: safetyScore >= 8 ? Icons.shield : Icons.error,
                ),

                if (vegan)
                  buildBadge(
                    label: 'Vegan',

                    color: Colors.teal,

                    icon: Icons.eco,
                  ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: getSafetyColor(safetyScore).withOpacity(0.1),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.health_and_safety,

                        color: getSafetyColor(safetyScore),

                        size: 34,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        'Safety Score',

                        style: TextStyle(
                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                          color: getSafetyColor(safetyScore),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  LinearProgressIndicator(
                    value: safetyScore / 10,

                    minHeight: 12,

                    borderRadius: BorderRadius.circular(20),

                    backgroundColor: Colors.grey.shade300,

                    color: getSafetyColor(safetyScore),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${safetyScore.toStringAsFixed(1)}/10 Safety Rating',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                      color: getSafetyColor(safetyScore),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            buildSectionTitle('Ingredients'),

            const SizedBox(height: 12),

            buildInfoCard(
              widget.product['ingredients'] ?? 'No ingredients available',
            ),

            const SizedBox(height: 30),

            buildSectionTitle('Description'),

            const SizedBox(height: 12),

            buildInfoCard(
              widget.product['description'] ?? 'No description available',
            ),

            const SizedBox(height: 30),

            buildSectionTitle('Product Information'),

            const SizedBox(height: 12),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    buildInfoRow('Category', widget.product['category'] ?? ''),

                    const Divider(height: 30),

                    buildInfoRow(
                      'Safety',
                      getSafetyLabel(safetyScore),

                      valueColor: getSafetyColor(safetyScore),
                    ),

                    const Divider(height: 30),

                    buildInfoRow(
                      'Halal Status',
                      halal ? 'Verified' : 'Needs Verification',

                      valueColor: halal ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

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

  Widget buildSectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildInfoCard(String text) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.6)),
    );
  }

  Widget buildInfoRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: 16,

            fontWeight: FontWeight.bold,

            color: valueColor,
          ),
        ),
      ],
    );
  }
}
