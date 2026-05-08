import 'package:flutter/material.dart';
import '../services/product_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductService.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodTrust Dashboard'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Tracked Products',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: products.length,

                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),

                    child: ListTile(
                      leading: Icon(
                        product.isSafe ? Icons.verified : Icons.warning,

                        color: product.isSafe ? Colors.green : Colors.red,
                      ),

                      title: Text(product.name),

                      subtitle: Text('Expiry: ${product.expiryDate}'),

                      trailing: Text(
                        product.isSafe ? 'SAFE' : 'UNSAFE',

                        style: TextStyle(
                          color: product.isSafe ? Colors.green : Colors.red,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
