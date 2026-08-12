

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'otp_verification_screen.dart';

// class PhoneNumberScreen extends StatefulWidget {
//   const PhoneNumberScreen({super.key});

//   @override
//   State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
// }

// class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   bool isValidPhoneNumber(String phone) {
//     return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
//   }

//   void _sendOtp() async {
//     String phone = _phoneController.text.trim();

//     if (!isValidPhoneNumber(phone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid 10-digit phone number.')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: "+91$phone",
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OTPVerificationScreen(
//                 phoneNumber: phone,
//                 verificationId: verificationId,
//               ),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error sending OTP: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           // 🌤️ Soft pastel gradient background
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFF6F8F3), // light pastel cream
//               Color(0xFFE7F3C7), // soft yellow-green
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 28.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // 🪄 Subtle hero animation zone
//                 AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.easeInOut,
//                   child: Image.asset(
//                     'assets/images/Logoo.png',
//                     height: height * 0.25,
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 const Text(
//                   "Let's Get Started!",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF060606),
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 const Text(
//                   'Enter your phone number to continue',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // 📱 Input field with glassy effect
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     style: const TextStyle(fontSize: 16),
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.phone, color: Colors.black54),
//                       hintText: 'Enter Phone Number',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 35),

//                 // ✨ Animated Send OTP Button
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFD7EE46).withOpacity(0.4),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _sendOtp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD7EE46),
//                       foregroundColor: const Color(0xFF060606),
//                       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             height: 22,
//                             width: 22,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.black,
//                             ),
//                           )
//                         : const Text(
//                             'Send OTP',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // 👣 Small footer text
//                 const Text(
//                   "You’ll receive an SMS for verification",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  void _sendOtp() async {
    String phone = _phoneController.text.trim();

    if (!isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phoneNumber: phone,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending OTP: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // 🌤️ Soft pastel gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF6F8F3), // light pastel cream
              Color(0xFFE7F3C7), // soft yellow-green
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(   // 🔥 FIX: Prevents overflow
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),

                  // 🪄 Subtle hero animation zone
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/images/Logoo.png',
                      height: height * 0.25,
                    ),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    "Let's Get Started!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF060606),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'Enter your phone number to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 📱 Input field with glassy effect
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: Colors.black54),
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ✨ Animated Send OTP Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD7EE46).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7EE46),
                        foregroundColor: const Color(0xFF060606),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 👣 Small footer text
                  const Text(
                    "You’ll receive an SMS for verification",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30), // bottom safe spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}







