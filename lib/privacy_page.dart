import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool locationEnabled = true;
  bool analyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Full white background
      appBar: AppBar(
        title: const Text(
          "Privacy Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Container(
        color: Colors.white, // ✅ force body background white too
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.white,
              elevation: 1,
              child: SwitchListTile(
                title: const Text("Location Access"),
                value: locationEnabled,
                onChanged: (value) {
                  setState(() {
                    locationEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 1,
              child: SwitchListTile(
                title: const Text("Analytics Sharing"),
                value: analyticsEnabled,
                onChanged: (value) {
                  setState(() {
                    analyticsEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
