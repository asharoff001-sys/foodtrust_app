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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('FoodTrust'),

        centerTitle: true,

        elevation: 0,
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),

            child: TextField(
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              decoration: InputDecoration(
                hintText: 'Search products...',

                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey,
                ),

                prefixIcon: Icon(
                  Icons.search,

                  color: isDark ? Colors.white70 : Colors.grey,
                ),

                filled: true,

                fillColor: isDark
                    ? const Color(0xFF1A1A24)
                    : Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(vertical: 14),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.inventory_2_outlined,

                          size: 90,

                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'No products found',

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.bold,

                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!.docs;

                final filteredProducts = products.where((product) {
                  final data = product.data() as Map<String, dynamic>;

                  final name = (data['name'] ?? '').toString().toLowerCase();

                  return name.contains(searchText);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.search_off,

                          size: 90,

                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'No matching products',

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.bold,

                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),

                  itemCount: filteredProducts.length,

                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    final data = product.data() as Map<String, dynamic>;

                    final halal = data['halal'] == true;

                    return Card(
                      color: Theme.of(context).cardColor,

                      elevation: 4,

                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),

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

                        child: Padding(
                          padding: const EdgeInsets.all(14),

                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),

                                child: Image.network(
                                  data['image'] ?? '',

                                  width: 75,

                                  height: 75,

                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 75,

                                      height: 75,

                                      color: isDark
                                          ? const Color(0xFF2A2A35)
                                          : Colors.grey.shade300,

                                      child: Icon(
                                        Icons.fastfood,

                                        size: 35,

                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      data['name'] ?? '',

                                      maxLines: 2,

                                      overflow: TextOverflow.ellipsis,

                                      style: TextStyle(
                                        fontSize: 17,

                                        fontWeight: FontWeight.bold,

                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      data['brand'] ?? '',

                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,

                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),

                                      decoration: BoxDecoration(
                                        color: halal
                                            ? Colors.green.withOpacity(0.18)
                                            : Colors.orange.withOpacity(0.18),

                                        borderRadius: BorderRadius.circular(30),
                                      ),

                                      child: Text(
                                        halal ? 'Halal' : 'Check Ingredients',

                                        style: TextStyle(
                                          color: halal
                                              ? Colors.green
                                              : Colors.orange,

                                          fontWeight: FontWeight.bold,

                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,

                                size: 18,

                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ],
                          ),
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
