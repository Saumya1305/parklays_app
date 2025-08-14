// import 'package:flutter/material.dart';

// class OTPVerificationScreen extends StatelessWidget {
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFF332A1C)),
//         title: Text(
//           'OTP Verification',
//           style: TextStyle(color: Color(0xFF332A1C), fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Container(
//         color: Color(0xFFF0F1F4),
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF6663CC),
//                 letterSpacing: 2,
//               ),
//             ),
//             SizedBox(height: 60),
//             Text(
//               'Enter OTP sent to your phone',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF332A1C),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(color: Color(0xFF332A1C)),
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 hintStyle: TextStyle(color: Colors.grey[500]),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('OTP Verified (mock)')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFFCDD01),
//                 foregroundColor: Colors.black,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Verify',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import 'profile_setup_screen.dart';

class OTPVerificationScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();
  final String phoneNumber;
  final String? prefillOtp;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.prefillOtp,
  }) {
    if (prefillOtp != null) {
      _otpController.text = prefillOtp!;
    }
  }

  void _verifyOTP(BuildContext context) async {
  final otp = _otpController.text.trim();

  if (otp.isEmpty || otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
    );
    return;
  }

  try {
    final jwt = await AuthService.verifyOtp(phoneNumber, otp);

    // Save JWT token securely
    if (jwt != null) {
      await _storage.write(key: 'jwt_token', value: jwt);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified Successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(phoneNumber: phoneNumber),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0C1633)),
        title: const Text(
          'OTP Verification',
          style: TextStyle(color: Color(0xFF0C1633), fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PARKLAYS',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1633),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Enter OTP sent to your phone',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF0C1633),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFF0C1633)),
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: const Color(0xFFF0F1F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _verifyOTP(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF508A1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//evrything about this code is working
// import 'package:flutter/material.dart';
// import 'package:parklays/services/auth_service.dart'; // Make sure this path is correct
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class OTPVerificationScreen extends StatelessWidget {
//   final TextEditingController _otpController = TextEditingController();
//   final String phoneNumber;

//   OTPVerificationScreen({super.key, required this.phoneNumber});

//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   void _verifyOTP(BuildContext context) async {
//     final otp = _otpController.text.trim();

//     if (otp.isEmpty || otp.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid 6-digit OTP')),
//       );
//       return;
//     }

//     try {
//       final jwt = await AuthService.verifyOtp(phoneNumber, otp);

//       // Save JWT token securely
//       await _storage.write(key: 'jwt_token', value: jwt);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('OTP Verified Successfully')),
//       );

//       // TODO: Navigate to home/dashboard screen
//       // Navigator.pushReplacement(...);

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFF0C1633)),
//         title: Text(
//           'OTP Verification',
//           style: TextStyle(color: Color(0xFF0C1633), fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF0C1633),
//                 letterSpacing: 2,
//               ),
//             ),
//             SizedBox(height: 60),
//             Text(
//               'Enter OTP sent to your phone',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF0C1633),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(color: Color(0xFF0C1633)),
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 hintStyle: TextStyle(color: Colors.grey[500]),
//                 filled: true,
//                 fillColor: Color(0xFFF0F1F4),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () => _verifyOTP(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF508A1E),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Verify',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//this code is working properly
// import 'package:flutter/material.dart';

// class OTPVerificationScreen extends StatelessWidget {
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFF0C1633)),
//         title: Text(
//           'OTP Verification',
//           style: TextStyle(color: Color(0xFF0C1633), fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF0C1633),
//                 letterSpacing: 2,
//               ),
//             ),
//             SizedBox(height: 60),
//             Text(
//               'Enter OTP sent to your phone',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF0C1633),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(color: Color(0xFF0C1633)),
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 hintStyle: TextStyle(color: Colors.grey[500]),
//                 filled: true,
//                 fillColor: Color(0xFFF0F1F4),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('OTP Verified (mock)')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF508A1E),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Verify',
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

// class OTPVerificationScreen extends StatelessWidget {
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFF332A1C)),
//         title: Text(
//           'OTP Verification',
//           style: TextStyle(color: Color(0xFF332A1C), fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Container(
//         color: Color(0xFFF0F1F4),
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'PARKLAYS',
//               style: TextStyle(
//                 fontFamily: 'Orbitron',
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF6663CC),
//                 letterSpacing: 2,
//               ),
//             ),
//             SizedBox(height: 60),
//             Text(
//               'Enter OTP sent to your phone',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF332A1C),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(color: Color(0xFF332A1C)),
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 hintStyle: TextStyle(color: Colors.grey[500]),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('OTP Verified (mock)')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFFCDD01),
//                 foregroundColor: Colors.black,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Verify',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
