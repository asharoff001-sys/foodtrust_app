import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'product_details_screen.dart';
import 'submit_product_screen.dart';

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

      print('FETCHING PRODUCT WITH ID: $code');

      // PRODUCT NOT FOUND
      if (!doc.exists) {
        if (!context.mounted) return;

        final shouldSubmit = await showDialog<bool>(
          context: context,

          builder: (context) {
            return AlertDialog(
              title: const Text('Product Not Found'),

              content: Text(
                'Barcode $code does not exist.\n\nWould you like to submit this product?',
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },

                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },

                  child: const Text('Submit Product'),
                ),
              ],
            );
          },
        );

        if (shouldSubmit == true) {
          if (!context.mounted) return;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitProductScreen(barcode: code),
            ),
          );
        }

        controller.start();

        setState(() {
          isScanning = true;
          isLoading = false;
        });

        return;
      }

      final data = doc.data() as Map<String, dynamic>;

      // SAVE SCAN HISTORY
      final user = FirebaseAuth.instance.currentUser;

      print('CURRENT USER: ${user?.uid}');

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scan_history')
            .add({
              'productId': doc.id,
              'productName': data['name'] ?? '',
              'image': data['image'] ?? '',
              'scannedAt': Timestamp.now(),
            });

        print('SCAN HISTORY SAVED');
      } else {
        print('USER IS NULL');
      }

      if (!context.mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductDetailsScreen(product: {'id': doc.id, ...data}),
        ),
      );

      controller.start();

      setState(() {
        isScanning = true;
        isLoading = false;
      });
    } catch (e) {
      print('SCANNER ERROR: $e');

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
            fit: BoxFit.cover,

            onDetect: (capture) async {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isEmpty) return;

              String? code = barcodes.first.rawValue;

              if (code == null) return;

              code = code.trim();

              // REMOVE INVALID FIRESTORE CHARACTERS
              code = code.replaceAll('/', '');
              code = code.replaceAll('\\', '');

              if (code.isEmpty) {
                setState(() {
                  isScanning = true;
                });

                return;
              }

              print('SCANNED CODE: $code');

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
