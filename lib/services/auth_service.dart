// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AuthService {
//   static const String baseUrl = 'http://10.0.2.2:5049/api'; // Android emulator localhost

//   static Future<bool> sendOtp(String phoneNumber) async {
//     final url = Uri.parse('$baseUrl/otp/send');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phoneNumber': phoneNumber}),
//       );

//       print('OTP SEND RESPONSE: ${response.statusCode} - ${response.body}');

//       return response.statusCode == 200;
//     } catch (e) {
//       print('Error sending OTP: $e');
//       return false;
//     }
//   }

//   static Future<String> verifyOtp(String phoneNumber, String otpCode) async {
//     final url = Uri.parse('$baseUrl/otp/verify');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phoneNumber': phoneNumber, 'otpCode': otpCode}),
//     );

//     print('OTP VERIFY RESPONSE: ${response.statusCode} - ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['token']; // Assumes backend returns { "token": "..." }
//     } else {
//       final error = jsonDecode(response.body);
//       throw Exception(error['message'] ?? 'OTP verification failed');
//     }
//   }
// }





// import 'dart:async';
// import 'dart:math';

// class AuthService {
//   static String? _lastGeneratedOtp;

//   // Generates OTP and returns it
//   static Future<String?> sendOtp(String phoneNumber) async {
//     await Future.delayed(const Duration(seconds: 1));

//     // Generate random 6-digit OTP
//     final random = Random();
//     _lastGeneratedOtp = (100000 + random.nextInt(900000)).toString();

//     print("📩 Mock OTP for $phoneNumber: $_lastGeneratedOtp"); // Debug console

//     return _lastGeneratedOtp;
//   }

//   // Verifies OTP and returns mock JWT token
//   static Future<String?> verifyOtp(String phoneNumber, String otpCode) async {
//     await Future.delayed(const Duration(seconds: 1));

//     if (otpCode == _lastGeneratedOtp) {
//       return "mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}";
//     } else {
//       throw Exception("Invalid OTP");
//     }
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send OTP to phone number
  static Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // add country code
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification on some devices
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Verify OTP
  static Future<User?> verifyOtp(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }
  /// Normalize phone number for backend
  static String normalizePhone(String phone) {
    if (phone.startsWith("+91")) {
      return phone.substring(3); // remove +91
    }
    return phone;
  }
}
