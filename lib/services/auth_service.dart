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





import 'dart:async';
import 'dart:math';

class AuthService {
  static String? _lastGeneratedOtp;

  // Generates OTP and returns it
  static Future<String?> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    // Generate random 6-digit OTP
    final random = Random();
    _lastGeneratedOtp = (100000 + random.nextInt(900000)).toString();

    print("📩 Mock OTP for $phoneNumber: $_lastGeneratedOtp"); // Debug console

    return _lastGeneratedOtp;
  }

  // Verifies OTP and returns mock JWT token
  static Future<String?> verifyOtp(String phoneNumber, String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otpCode == _lastGeneratedOtp) {
      return "mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}";
    } else {
      throw Exception("Invalid OTP");
    }
  }
}
