import 'package:flutter/material.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  double rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Review')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),

            const Text(
              'Share Your Experience',

              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: 'Your Name',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: commentController,

              maxLines: 5,

              decoration: InputDecoration(
                labelText: 'Write your review',

                alignLabelWithHint: true,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Rating',

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Row(
              children: [
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

                Text(
                  rating.toStringAsFixed(1),

                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      commentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );

                    return;
                  }

                  Navigator.pop(context, {
                    'username': nameController.text.trim(),

                    'comment': commentController.text.trim(),

                    'rating': rating,
                  });
                },

                child: const Text(
                  'Submit Review',

                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
