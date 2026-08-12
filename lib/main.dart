

// import 'package:flutter/material.dart';
// import 'dart:async';

// // Firebase imports
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // Localization imports
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'l10n/l10n.dart'; // ✅ Use generated localization file
// import 'package:provider/provider.dart';
// import 'locale_provider.dart';

// // Screens
// import 'phone_number_screen.dart';
// import 'profile_page.dart';
// import 'history_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   } catch (e) {
//     debugPrint("🔥 Firebase init failed: $e");
//   }

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => LocaleProvider(),
//       child: const ParklaysApp(),
//     ),
//   );
// }

// class ParklaysApp extends StatelessWidget {
//   const ParklaysApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocaleProvider>(context);

//     return MaterialApp(
//       title: 'Parklays',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Orbitron',
//         scaffoldBackgroundColor: const Color(0xFF101014),
//       ),

//       // ✅ Localization setup
//       locale: provider.locale,
//       localizationsDelegates: S.localizationsDelegates,
//       supportedLocales: S.supportedLocales,

//       home: const SplashScreen(),
//       routes: {
//         '/profile': (_) => const ProfilePage(),
//         '/phoneNumber': (_) => const PhoneNumberScreen(),
//         '/history': (_) => const HistoryPage(),
//       },
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _logoPulseController;
//   late final AnimationController _logoExpandController;
//   late final AnimationController _textFadeController;
//   late final Animation<double> _pulseAnimation;
//   late final Animation<double> _expandAnimation;
//   late final Animation<double> _fadeAnimation;

//   final String fullText = "YOUR SPACE, JUST A TAP AWAY...";
//   String visibleText = "";
//   int _charIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Subtle logo pulsing
//     _logoPulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
//       CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
//     );

//     // Expansion flash
//     _logoExpandController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _expandAnimation = Tween<double>(begin: 1.0, end: 10.0).animate(
//       CurvedAnimation(parent: _logoExpandController, curve: Curves.easeIn),
//     );

//     // Text fade
//     _textFadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _fadeAnimation =
//         Tween<double>(begin: 1.0, end: 0.0).animate(_textFadeController);

//     // Typewriter animation
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_charIndex < fullText.length) {
//         setState(() {
//           visibleText += fullText[_charIndex];
//           _charIndex++;
//         });
//       } else {
//         timer.cancel();
//         Future.delayed(const Duration(seconds: 2), () {
//           _textFadeController.forward();
//           _logoPulseController.stop();
//           _logoExpandController.forward();

//           Future.delayed(const Duration(milliseconds: 900), () {
//             Navigator.of(context).pushReplacement(
//               PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const PhoneNumberScreen(),
//                 transitionsBuilder: (_, anim, __, child) => FadeTransition(
//                   opacity: anim,
//                   child: child,
//                 ),
//                 transitionDuration: const Duration(milliseconds: 700),
//               ),
//             );
//           });
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _logoPulseController.dispose();
//     _logoExpandController.dispose();
//     _textFadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 🌈 Background gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF181818),
//                   Color(0xFF1C1B22),
//                   Color(0xFF27293D),
//                   Color(0xFF3A3B59),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),

//           // ✨ Softer glowing logo (reduced brightness)
//           Center(
//             child: ScaleTransition(
//               scale: _expandAnimation,
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color.fromARGB(255, 192, 193, 190), // 🌿 softer pastel instead of pure white
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xFFD8F2B0), // softer glow, less harsh
//                       blurRadius: 30, // reduced from 40
//                       spreadRadius: 3, // reduced from 5
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // 🌀 Pulsing Parklays Logo
//           Center(
//             child: ScaleTransition(
//               scale: _pulseAnimation,
//               child: Image.asset(
//                 "assets/images/Logoo.png",
//                 width: 160,
//                 height: 160,
//               ),
//             ),
//           ),

//           // 💬 Tagline text with fade
//           Positioned(
//             bottom: 100,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Text(
//                 visibleText,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Color(0xFFE0E0E0),
//                   fontSize: 18,
//                   letterSpacing: 2,
//                   fontWeight: FontWeight.w700,
//                   shadows: [
//                     Shadow(
//                       blurRadius: 10,
//                       color: Color.fromARGB(255, 170, 171, 168), // softened to match glow
//                       offset: Offset(0, 0),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'dart:async';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:parklays/role_selection_screen.dart';
import 'firebase_options.dart';

// Localization imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart'; // ✅ Use generated localization file
import 'package:provider/provider.dart';
import 'locale_provider.dart';

// Screens
import 'phone_number_screen.dart';
import 'profile_page.dart';
import 'history_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("🔥 Firebase init failed: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const ParklaysApp(),
    ),
  );
}

class ParklaysApp extends StatelessWidget {
  const ParklaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Parklays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Orbitron',
        scaffoldBackgroundColor: const Color(0xFF101014),
      ),
      locale: provider.locale,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      routes: {
        '/profile': (_) => const ProfilePage(),
        '/phoneNumber': (_) => const PhoneNumberScreen(),
        '/history': (_) => const HistoryPage(userPhone: ""),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoPulseController;
  late final AnimationController _logoExpandController;
  late final AnimationController _textFadeController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _fadeAnimation;

  final String fullText = "YOUR SPACE, JUST A TAP AWAY...";
  String visibleText = "";
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    // Subtle logo pulsing
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    // Expansion flash
    _logoExpandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _expandAnimation = Tween<double>(begin: 1.0, end: 10.0).animate(
      CurvedAnimation(parent: _logoExpandController, curve: Curves.easeIn),
    );

    // Text fade
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_textFadeController);

    // Typewriter animation
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_charIndex < fullText.length) {
        setState(() {
          visibleText += fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          _textFadeController.forward();
          _logoPulseController.stop();
          _logoExpandController.forward();

          Future.delayed(const Duration(milliseconds: 900), () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(
                  opacity: anim,
                  child: child,
                ),
                transitionDuration: const Duration(milliseconds: 700),
              ),
            );

          });
        });
      }
    });
  }

  @override
  void dispose() {
    _logoPulseController.dispose();
    _logoExpandController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🌈 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF181818),
                  Color(0xFF1C1B22),
                  Color(0xFF27293D),
                  Color(0xFF3A3B59),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ✨ Animated glowing logo
          Center(
            child: ScaleTransition(
              scale: _expandAnimation,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE7F3C7),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE7F3C7),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🌀 Pulsing Parklays Logo
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Image.asset(
                "assets/images/Logoo.png",
                width: 160,
                height: 160,
              ),
            ),
          ),

          // 💬 Tagline text with fade
          Positioned(
            bottom: 100,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                visibleText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 18,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color(0xFFE7F3C7),
                      offset: Offset(0, 0),
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

