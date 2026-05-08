import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String scannedCode = '';

  final TextEditingController controller = TextEditingController();

  void scanProduct() {
    setState(() {
      scannedCode = controller.text;
    });

    Navigator.pop(context, scannedCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.qr_code_scanner, size: 120, color: Colors.green),

            const SizedBox(height: 30),

            TextField(
              controller: controller,

              decoration: const InputDecoration(
                labelText: 'Enter Barcode',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: scanProduct, child: const Text('Scan')),

            const SizedBox(height: 30),

            Text(
              scannedCode.isEmpty
                  ? 'No Product Scanned'
                  : 'Scanned Code: $scannedCode',

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
