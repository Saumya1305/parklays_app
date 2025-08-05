// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'phone_number_screen.dart'; // Add this line
// void main() {
//   runApp(ParklaysApp());
// }

// class ParklaysApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Parklays',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: 'Orbitron'), // Custom font
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _slideController;
//   late Animation<Offset> _slideAnimation;

//   String fullText = 'PARKLAYS';
//   String visibleText = '';
//   int _charIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Slide up animation
//     _slideController = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOut,
//     ));

//     // Start typewriter effect
//     Timer.periodic(Duration(milliseconds: 120), (timer) {
//       if (_charIndex < fullText.length) {
//         setState(() {
//           visibleText += fullText[_charIndex];
//           _charIndex++;
//         });
//       } else {
//         timer.cancel();
//         _slideController.forward();
//         // Navigate after animation
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
//           );
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _slideController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Text(
//             visibleText,
//             style: TextStyle(
//               fontSize: 48,
//               color: Colors.white,
//               letterSpacing: 4,
//               fontWeight: FontWeight.w800,
//               shadows: [
//                 Shadow(
//                   blurRadius: 30,
//                   color: const Color.fromARGB(255, 131, 126, 132),
//                   offset: Offset(0, 0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Home Screen',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'phone_number_screen.dart'; // Your next screen

// void main() {
//   runApp(ParklaysApp());
// }

// class ParklaysApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Parklays',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Orbitron',
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   String fullText = 'PARKLAYS';
//   String visibleText = '';
//   int _charIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     _fadeController = AnimationController(
//       duration: Duration(milliseconds: 1800),
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
//     );

//     // Typewriter + animations
//     Timer.periodic(Duration(milliseconds: 120), (timer) {
//       if (_charIndex < fullText.length) {
//         setState(() {
//           visibleText += fullText[_charIndex];
//           _charIndex++;
//         });
//       } else {
//         timer.cancel();
//         _fadeController.forward();
//         _scaleController.forward();
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
//           );
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE8EAF6), Color(0xFFD1C4E9)], // soft lavender tones
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: Text(
//                 visibleText,
//                 style: TextStyle(
//                   fontSize: 50,
//                   letterSpacing: 6,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.deepPurple[700],
//                   shadows: [
//                     Shadow(
//                       blurRadius: 10,
//                       color: Colors.purple.shade200,
//                       offset: Offset(1, 2),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
