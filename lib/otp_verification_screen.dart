
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:parklays/role_selection_screen.dart';
// import 'user_preferences.dart';

// class OTPVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId;

//   const OTPVerificationScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.verificationId,
//   });

//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   int _secondsRemaining = 60;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     setState(() {
//       _secondsRemaining = 60;
//     });

//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsRemaining > 0) {
//         setState(() {
//           _secondsRemaining--;
//         });
//       } else {
//         _timer?.cancel();
//       }
//     });
//   }

//   void _resendOtp() async {
//     if (_secondsRemaining == 0) {
//       try {
//         await _auth.verifyPhoneNumber(
//           phoneNumber: "+91${widget.phoneNumber}",
//           verificationCompleted: (PhoneAuthCredential credential) async {
//             await _auth.signInWithCredential(credential);
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Verification failed: ${e.message}")),
//             );
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             setState(() {
//               _secondsRemaining = 60;
//             });
//             _startTimer();
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {},
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error resending OTP: $e")),
//         );
//       }
//     }
//   }

//   void _verifyOTP() async {
//     final otp = _otpController.text.trim();

//     if (otp.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a valid 6-digit OTP')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: otp,
//       );

//       await _auth.signInWithCredential(credential);
//       await UserPreferences.savePhoneNumber(widget.phoneNumber);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP: ${e.message}")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           // 🌈 Pastel gradient background (same as phone number screen)
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFF6F8F3), // soft cream
//               Color(0xFFE7F3C7), // mild yellow-green
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             reverse: true,
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // 🪄 Logo animation
//                 AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.easeInOut,
//                   child: Image.asset(
//                     'assets/images/Logoo.png',
//                     height: height * 0.22,
//                   ),
//                 ),
//                 const SizedBox(height: 35),

//                 const Text(
//                   "Verify Your Number",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF060606),
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 const Text(
//                   "Enter the 6-digit OTP sent to",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 const SizedBox(height: 6),

//                 Text(
//                   "+91 ${widget.phoneNumber}",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 35),

//                 // 🔢 OTP input with glassy design
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
//                     controller: _otpController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 6,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       letterSpacing: 8,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF060606),
//                     ),
//                     decoration: const InputDecoration(
//                       counterText: "",
//                       border: InputBorder.none,
//                       hintText: "______",
//                       hintStyle: TextStyle(
//                         fontSize: 22,
//                         letterSpacing: 8,
//                         color: Colors.grey,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(vertical: 18),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // ✨ Verify button with glow
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
//                     onPressed: _isLoading ? null : _verifyOTP,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD7EE46),
//                       foregroundColor: const Color(0xFF060606),
//                       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
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
//                             'Verify OTP',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // ⏳ Timer or Resend button
//                 _secondsRemaining > 0
//                     ? Text(
//                         "Resend OTP in $_secondsRemaining s",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                     : TextButton(
//                         onPressed: _isLoading ? null : _resendOtp,
//                         child: const Text(
//                           "Resend OTP",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF060606),
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),

//                 const SizedBox(height: 20),

//                 const Text(
//                   "Didn’t get the code? Check your SMS inbox.",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.black45,
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





import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';
import 'user_preferences.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool _isLoading = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 60);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }
  String normalizePhone(String phone) {
  if (phone.startsWith("+91")) {
    return phone.substring(3); // remove +91
  }
  return phone;
}

  void _resendOtp() async {
    if (_secondsRemaining == 0) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: "+91${widget.phoneNumber}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Verification failed: ${e.message}")),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {});
            _startTimer();
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error resending OTP: $e")),
        );
      }
    }
  }

void _verifyOTP() async {
  final otp = _otpController.text.trim();

  if (otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enter a valid 6-digit OTP')),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    // Firebase sign-in
    UserCredential userCred = await _auth.signInWithCredential(credential);
    User? user = userCred.user;

    // 🔥 Get Firebase mobile number (this includes +91)
    final firebasePhone = user?.phoneNumber ?? "";

    // 🔥 Clean the phone number for backend
    final cleanPhone = normalizePhone(firebasePhone);
    print("Clean Phone for backend: $cleanPhone");

    // 🔥 Save cleaned phone instead of raw input
    await UserPreferences.savePhoneNumber(cleanPhone);

    // 🟢 Continue to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid OTP: ${e.message}")),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF6F8F3),
              Color(0xFFE7F3C7),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(28, 20, 28, bottomInset + 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: height * 0.04),

                // 🪄 Logo
                Image.asset(
                  'assets/images/Logoo.png',
                  height: height * 0.22,
                ),
                const SizedBox(height: 35),

                const Text(
                  "Verify Your Number",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF060606),
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Enter the 6-digit OTP sent to",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "+91 ${widget.phoneNumber}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 35),

                // 🔢 OTP input
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
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "______",
                      hintStyle: TextStyle(
                        fontSize: 22,
                        letterSpacing: 8,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ✔ Verify button
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD7EE46),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 80),
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
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 25),

                // ⏳ Resend OTP text / timer
                _secondsRemaining > 0
                    ? Text(
                        "Resend OTP in $_secondsRemaining s",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      )
                    : TextButton(
                        onPressed: _resendOtp,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),

                const SizedBox(height: 18),

                const Text(
                  "Didn’t get the code? Check your SMS inbox.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


