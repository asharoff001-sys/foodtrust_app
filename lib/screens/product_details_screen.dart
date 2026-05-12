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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,

        title: Text(widget.product['name'] ?? 'Product'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),

            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF1A1A24)
                    : Colors.green.shade50,
              ),

              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,

                color: isDark ? Colors.purpleAccent : Colors.green,
              ),

              onPressed: saveProduct,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Hero(
              tag: widget.product['id'].toString(),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),

                child: Image.network(
                  widget.product['image'] ?? '',

                  height: 260,

                  width: double.infinity,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 260,

                      color: isDark
                          ? const Color(0xFF1A1A24)
                          : Colors.grey.shade300,

                      child: Icon(
                        Icons.fastfood,

                        size: 90,

                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              widget.product['name'] ?? '',

              style: TextStyle(
                fontSize: 30,

                fontWeight: FontWeight.bold,

                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.product['brand'] ?? '',

              style: TextStyle(
                fontSize: 18,

                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 26),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: [
                buildBadge(
                  label: halal ? 'Halal' : 'Needs Verification',

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

            const SizedBox(height: 30),

            buildSafetyCard(safetyScore),

            const SizedBox(height: 34),

            buildSectionTitle('Ingredients'),

            const SizedBox(height: 14),

            buildInfoCard(
              widget.product['ingredients'] ?? 'No ingredients available',
            ),

            const SizedBox(height: 34),

            buildSectionTitle('Description'),

            const SizedBox(height: 14),

            buildInfoCard(
              widget.product['description'] ?? 'No description available',
            ),

            const SizedBox(height: 34),

            buildSectionTitle('Product Information'),

            const SizedBox(height: 14),

            Card(
              color: Theme.of(context).cardColor,

              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    buildInfoRow('Category', widget.product['category'] ?? ''),

                    Divider(
                      height: 30,

                      color: isDark ? Colors.white24 : Colors.black12,
                    ),

                    buildInfoRow(
                      'Safety',

                      getSafetyLabel(safetyScore),

                      valueColor: getSafetyColor(safetyScore),
                    ),

                    Divider(
                      height: 30,

                      color: isDark ? Colors.white24 : Colors.black12,
                    ),

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

  Widget buildSafetyCard(double safetyScore) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            getSafetyColor(safetyScore).withOpacity(0.15),

            isDark ? const Color(0xFF1A1A24) : Colors.white,
          ],
        ),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety,

                color: getSafetyColor(safetyScore),

                size: 36,
              ),

              const SizedBox(width: 12),

              Text(
                'Safety Score',

                style: TextStyle(
                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                  color: getSafetyColor(safetyScore),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          LinearProgressIndicator(
            value: safetyScore / 10,

            minHeight: 14,

            borderRadius: BorderRadius.circular(30),

            backgroundColor: Colors.grey.shade700,

            color: getSafetyColor(safetyScore),
          ),

          const SizedBox(height: 14),

          Text(
            '${safetyScore.toStringAsFixed(1)}/10 Safety Rating',

            style: TextStyle(
              fontWeight: FontWeight.bold,

              fontSize: 16,

              color: getSafetyColor(safetyScore),
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

  Widget buildSectionTitle(String title) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 24,

        fontWeight: FontWeight.bold,

        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget buildInfoCard(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.grey.shade100,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 16,

          height: 1.7,

          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: TextStyle(
            fontSize: 16,

            fontWeight: FontWeight.w500,

            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: 16,

            fontWeight: FontWeight.bold,

            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
