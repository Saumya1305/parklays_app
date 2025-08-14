
import 'package:flutter/material.dart';
import 'dart:async';
import 'phone_number_screen.dart';

void main() {
  runApp(ParklaysApp());
}

class ParklaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parklays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Orbitron',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String fullText = 'PARKLAYS';
  String visibleText = '';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    Timer.periodic(Duration(milliseconds: 120), (timer) {
      if (_charIndex < fullText.length) {
        setState(() {
          visibleText += fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        _slideController.forward();
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // White background (already default)
          Container(color: Colors.white),

          // Glowing animated car icon
          Align(
            alignment: Alignment.center,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 110, // Enlarged size
                height: 110,
                decoration: BoxDecoration(
                  color: Color(0xFF508A1E), // Green bubble
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF0C1633).withOpacity(0.4), // Deep navy glow
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_car_filled,
                  color: Colors.white,
                  size: 55, // Bigger icon
                ),
              ),
            ),
          ),

          // Parklays text with typewriter effect (shifted upward)
          Align(
            alignment: Alignment(0, 0.6), // Move upward from bottom
            child: SlideTransition(
              position: _slideAnimation,
              child: Text(
                visibleText,
                style: TextStyle(
                  fontSize: 42,
                  color: Color(0xFF0C1633), // Deep navy text
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
