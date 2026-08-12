import 'package:flutter/material.dart';
import 'main.dart'; // <-- import SplashScreen from main.dart

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool _hoverYes = false;
  bool _hoverNo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6), // dim background
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Do you really want to logout?",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // --- Buttons Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // No Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverNo = true),
                    onExit: (_) => setState(() => _hoverNo = false),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _hoverNo
                            ? Colors.grey[400]
                            : Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // close popup page
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Yes Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverYes = true),
                    onExit: (_) => setState(() => _hoverYes = false),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            _hoverYes ? Colors.red[700] : Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // 🚀 Send back to SplashScreen from main.dart
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SplashScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}