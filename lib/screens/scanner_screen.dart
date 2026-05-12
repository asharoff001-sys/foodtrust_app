import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'product_details_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product'), centerTitle: true),

      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isEmpty) return;

              final code = barcodes.first.rawValue;

              if (code == null) return;

              setState(() {
                isScanning = false;
              });

              try {
                final doc = await FirebaseFirestore.instance
                    .collection('products')
                    .doc(code)
                    .get();

                if (!doc.exists) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found')),
                  );

                  setState(() {
                    isScanning = true;
                  });

                  return;
                }

                final data = doc.data() as Map<String, dynamic>;

                if (!context.mounted) return;

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsScreen(product: {'id': doc.id, ...data}),
                  ),
                ).then((_) {
                  setState(() {
                    isScanning = true;
                  });
                });
              } catch (e) {
                setState(() {
                  isScanning = true;
                });

                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Scanner Error')));
              }
            },
          ),

          Center(
            child: Container(
              width: 260,

              height: 260,

              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),

                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Positioned(
            bottom: 40,

            left: 20,

            right: 20,

            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),

                borderRadius: BorderRadius.circular(16),
              ),

              child: const Text(
                'Align barcode inside the frame',

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
