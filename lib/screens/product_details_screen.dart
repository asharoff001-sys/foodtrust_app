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

  @override
  Widget build(BuildContext context) {
    final halal = widget.product['halal'] == true;

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
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Image.network(
                  widget.product['image'] ?? '',

                  height: 220,

                  width: double.infinity,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,

                      color: Colors.grey.shade300,

                      child: const Icon(Icons.fastfood, size: 80),
                    );
                  },
                ),
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

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: getSafetyColor(safetyScore).withOpacity(0.1),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  Icon(
                    halal ? Icons.verified : Icons.warning,

                    color: halal ? Colors.green : Colors.orange,

                    size: 36,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          halal ? 'Halal Verified' : 'Needs Verification',

                          style: TextStyle(
                            fontSize: 20,

                            fontWeight: FontWeight.bold,

                            color: halal ? Colors.green : Colors.orange,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Safety Score: ${safetyScore.toStringAsFixed(1)}/10',

                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            color: getSafetyColor(safetyScore),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Ingredients',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              widget.product['ingredients'] ?? '',

              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            const Text(
              'Description',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              widget.product['description'] ?? '',

              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text('Category'),

                        Text(widget.product['category'] ?? ''),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text('Safety'),

                        Text(
                          safetyScore >= 8
                              ? 'Safe'
                              : safetyScore >= 5
                              ? 'Moderate'
                              : 'Risky',

                          style: TextStyle(
                            color: getSafetyColor(safetyScore),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
