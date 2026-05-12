import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReviewScreen extends StatefulWidget {
  final String restaurantId;

  const AddReviewScreen({super.key, required this.restaurantId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  double rating = 4.0;

  bool isLoading = false;

  Future<void> submitReview() async {
    if (nameController.text.trim().isEmpty ||
        commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('reviews')
          .add({
            'username': nameController.text.trim(),

            'comment': commentController.text.trim(),

            'rating': rating,

            'createdAt': Timestamp.now(),
          });

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to submit review')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Review')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,

              decoration: const InputDecoration(labelText: 'Your Name'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: commentController,

              maxLines: 4,

              decoration: const InputDecoration(labelText: 'Your Review'),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text('Rating:'),

                Expanded(
                  child: Slider(
                    value: rating,

                    min: 1,

                    max: 5,

                    divisions: 4,

                    label: rating.toString(),

                    onChanged: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : submitReview,

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
