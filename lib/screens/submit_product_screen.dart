import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubmitProductScreen extends StatefulWidget {
  final String barcode;

  const SubmitProductScreen({super.key, required this.barcode});

  @override
  State<SubmitProductScreen> createState() => _SubmitProductScreenState();
}

class _SubmitProductScreenState extends State<SubmitProductScreen> {
  final nameController = TextEditingController();

  final brandController = TextEditingController();

  final ingredientsController = TextEditingController();

  final imageController = TextEditingController();

  bool halal = true;

  bool isLoading = false;

  Future<void> submitProduct() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product name required')));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('product_submissions').add({
        'barcode': widget.barcode,
        'name': nameController.text.trim(),
        'brand': brandController.text.trim(),
        'ingredients': ingredientsController.text.trim(),
        'image': imageController.text.trim(),
        'halal': halal,
        'submittedBy': user.uid,
        'submittedAt': Timestamp.now(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product submitted successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Submission failed')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Product'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Barcode: ${widget.barcode}',

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: 'Product Name',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: brandController,

              decoration: InputDecoration(
                labelText: 'Brand',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: ingredientsController,

              maxLines: 5,

              decoration: InputDecoration(
                labelText: 'Ingredients',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: imageController,

              decoration: InputDecoration(
                labelText: 'Image URL',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              value: halal,

              onChanged: (value) {
                setState(() {
                  halal = value;
                });
              },

              title: const Text('Halal Product'),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isLoading ? null : submitProduct,

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
