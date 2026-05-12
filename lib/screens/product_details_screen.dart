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

  @override
  Widget build(BuildContext context) {
    final halal = widget.product['halal'] == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']?.toString() ?? 'Product'),

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
              child: CircleAvatar(
                radius: 55,

                backgroundColor: Colors.green.shade100,

                child: const Icon(
                  Icons.fastfood,

                  size: 55,

                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              widget.product['name']?.toString() ?? '',

              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              widget.product['brand']?.toString() ?? '',

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
                        halal ? 'Halal Verified' : 'Needs Checking',

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: halal ? Colors.green : Colors.orange,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        halal
                            ? 'Safe for consumption'
                            : 'Please verify ingredients',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Description',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              widget.product['description']?.toString() ??
                  'No description available.',

              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            const Text(
              'Product Information',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

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
                        const Text('Brand'),

                        Text(widget.product['brand']?.toString() ?? ''),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text('Status'),

                        Text(
                          halal ? 'Halal' : 'Check',

                          style: TextStyle(
                            color: halal ? Colors.green : Colors.orange,

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
