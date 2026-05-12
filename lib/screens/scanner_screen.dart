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

  bool isLoading = false;

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> fetchProduct(String code) async {
    setState(() {
      isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(code)
          .get();

      if (!doc.exists) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found in database')),
        );

        setState(() {
          isScanning = true;
          isLoading = false;
        });

        return;
      }

      final data = doc.data() as Map<String, dynamic>;

      if (!context.mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductDetailsScreen(product: {'id': doc.id, ...data}),
        ),
      );

      setState(() {
        isScanning = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isScanning = true;
        isLoading = false;
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Scanner Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              controller.toggleTorch();
            },
            icon: const Icon(Icons.flash_on),
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: controller,

            onDetect: (capture) async {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isEmpty) return;

              final code = barcodes.first.rawValue;

              if (code == null) return;

              setState(() {
                isScanning = false;
              });

              await fetchProduct(code);
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

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),

              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
