import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF332A1C)),
        title: Text(
          'OTP Verification',
          style: TextStyle(color: Color(0xFF332A1C), fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: Color(0xFFF0F1F4),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PARKLAYS',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6663CC),
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 60),
            Text(
              'Enter OTP sent to your phone',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF332A1C),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Color(0xFF332A1C)),
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP Verified (mock)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFCDD01),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
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
