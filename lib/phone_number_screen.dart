// import 'package:flutter/material.dart';
// import 'otp_verification_screen.dart';

// class PhoneNumberScreen extends StatelessWidget {
//   final TextEditingController _phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFF0F1F4),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Parklays',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF6663CC),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               const Text(
//                 'Enter Your Phone Number',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xFF332A1C),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: 'Phone Number',
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.transparent),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OTPVerificationScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFCDD01),
//                   foregroundColor: Colors.black,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Send OTP',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'otp_verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (!isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit phone number.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? otp = await AuthService.sendOtp(phone);

    setState(() {
      _isLoading = false;
    });

    if (otp != null) {
      print("✅ OTP Sent: $otp"); // Debug print

      // Show OTP in SnackBar for testing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mock OTP: $otp'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to OTP screen with OTP prefilled
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: phone,
            prefillOtp: otp,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send OTP. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PARKLAYS',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1633),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Enter Your Phone Number',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF0C1633),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF0F1F4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF508A1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}




//everything is working about this code


// import 'package:flutter/material.dart';
// import '../services/auth_service.dart'; // Your backend API service
// import 'otp_verification_screen.dart';

// class PhoneNumberScreen extends StatefulWidget {
//   const PhoneNumberScreen({super.key});

//   @override
//   State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
// }

// class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   bool _isLoading = false;

//   bool isValidPhoneNumber(String phone) {
//     return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
//   }

//   void _sendOtp() async {
//     String phone = _phoneController.text.trim();
//     if (!isValidPhoneNumber(phone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a valid 10-digit phone number.'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     bool success = await AuthService.sendOtp(phone);

//     setState(() {
//       _isLoading = false;
//     });

//     if (success) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OTPVerificationScreen(phoneNumber: phone),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to send OTP. Please try again.'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 36,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF0C1633),
//               ),
//             ),
//             const SizedBox(height: 50),
//             const Text(
//               'Enter Your Phone Number',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF0C1633),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 hintText: 'Phone Number',
//                 hintStyle: const TextStyle(color: Colors.grey),
//                 filled: true,
//                 fillColor: const Color(0xFFF0F1F4),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.transparent),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _sendOtp,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF508A1E),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                     )
//                   : const Text(
//                       'Send OTP',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//this code is properly working
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart'; // Import the AuthService
// import 'otp_verification_screen.dart';

// class PhoneNumberScreen extends StatelessWidget {
//   final TextEditingController _phoneController = TextEditingController();

//   PhoneNumberScreen({super.key});

//   bool isValidPhoneNumber(String phone) {
//     return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 36,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF0C1633),
//               ),
//             ),
//             const SizedBox(height: 50),
//             const Text(
//               'Enter Your Phone Number',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF0C1633),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 hintText: 'Phone Number',
//                 hintStyle: const TextStyle(color: Colors.grey),
//                 filled: true,
//                 fillColor: const Color(0xFFF0F1F4),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.transparent),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 String phone = _phoneController.text.trim();
//                 if (isValidPhoneNumber(phone)) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OTPVerificationScreen(),
//                     ),
//                   );
//                 } else {
//                   // Show a snackbar or alert if invalid
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter a valid 10-digit phone number.'),
//                       backgroundColor: Colors.redAccent,
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF508A1E),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Send OTP',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'otp_verification_screen.dart';

// class PhoneNumberScreen extends StatelessWidget {
//   final TextEditingController _phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFF0F1F4),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Parklays',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF6663CC),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               const Text(
//                 'Enter Your Phone Number',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xFF332A1C),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: 'Phone Number',
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.transparent),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OTPVerificationScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFCDD01),
//                   foregroundColor: Colors.black,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Send OTP',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
