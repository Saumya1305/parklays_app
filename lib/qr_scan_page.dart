import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends StatefulWidget {
  final int adminId;
  final int lotId;

  const ScanQRPage({
    super.key,
    required this.adminId,
    required this.lotId,
  });

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;
          scanned = true;

          final barcode = capture.barcodes.first;

          try {
            final data = jsonDecode(barcode.rawValue ?? '{}');
            // RETURN scanned user to previous page
            Navigator.pop(context, data);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid QR Code")),
            );
            scanned = false;
          }
        },
      ),
    );
  }
}
