import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FoodTrust'), centerTitle: true),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },

              decoration: InputDecoration(
                hintText: 'Search products...',

                prefixIcon: const Icon(Icons.search),

                filled: true,

                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final allProducts = snapshot.data!.docs;

                final filteredProducts = allProducts.where((product) {
                  final data = product.data() as Map<String, dynamic>;

                  final name = (data['name'] ?? '').toString().toLowerCase();

                  return name.contains(searchText);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No matching products'));
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,

                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    final data = product.data() as Map<String, dynamic>;

                    final halal = data['halal'] == true;

                    return Card(
                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: {'id': product.id, ...data},
                              ),
                            ),
                          );
                        },

                        leading: CircleAvatar(
                          radius: 28,

                          backgroundColor: Colors.green.shade100,

                          child: const Icon(
                            Icons.fastfood,

                            color: Colors.green,
                          ),
                        ),

                        title: Text(
                          data['name'] ?? '',

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 17,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),

                          child: Text(data['brand'] ?? ''),
                        ),

                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              halal ? Icons.verified : Icons.warning,

                              color: halal ? Colors.green : Colors.orange,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              halal ? 'Halal' : 'Check',

                              style: TextStyle(
                                color: halal ? Colors.green : Colors.orange,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
