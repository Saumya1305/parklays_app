// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
//       children: [
//         const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
//         const SizedBox(height: 12),
//         const Center(
//           child: Text("User Name",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 6),
//         const Center(
//             child: Text("user@email.com",
//                 style: TextStyle(color: Colors.black54))),
//         const SizedBox(height: 18),
//         Card(
//           elevation: 2,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           child: Column(
//             children: const [
//               ListTile(
//                   leading: Icon(Icons.settings), title: Text("Account Settings")),
//               Divider(height: 1),
//               ListTile(
//                   leading: Icon(Icons.help_outline),
//                   title: Text("Help & Support")),
//               Divider(height: 1),
//               ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'main.dart'; // ✅ to access SplashScreen

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to logout?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(), // ❌ Cancel
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () async {
//               Navigator.of(ctx).pop(); // close dialog
//               await FirebaseAuth.instance.signOut();

//               // Clear navigation stack & go back to Splash
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => SplashScreen()),
//                 (route) => false,
//               );
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
//       children: [
//         const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
//         const SizedBox(height: 12),
//         const Center(
//           child: Text("User Name",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 6),
//         const Center(
//             child: Text("user@email.com",
//                 style: TextStyle(color: Colors.black54))),
//         const SizedBox(height: 18),
//         Card(
//           elevation: 2,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           child: Column(
//             children: [
//               const ListTile(
//                   leading: Icon(Icons.settings), title: Text("Account Settings")),
//               const Divider(height: 1),
//               const ListTile(
//                   leading: Icon(Icons.help_outline),
//                   title: Text("Help & Support")),
//               const Divider(height: 1),

//               // ✅ Logout with confirmation
//               ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: const Text("Logout"),
//                 onTap: () => _confirmLogout(context),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'profile_details_entry.dart';
import 'user_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart'; // ✅ QR generation

// Import your new pages
import 'logout_page.dart';
import 'account_settings_page.dart';
import 'help_support_page.dart';
import 'about_us_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "User Name";
  String _userEmail = "user@email.com";
  String? _userPhone;
  String _vehicleType = "";
  String _vehicleNumber = "";
  String _address = "";
  String _vehicleColor = "";
  String _vehicleModel = "";


  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // ✅ Fetch profile data on page load
  }

  Future<void> _loadUserProfile() async {
    final phone = await UserPreferences.getPhoneNumber();
    if (phone != null) {
      _userPhone = phone;
      final url = "http://10.193.188.44:5155/api/UserProfiles/by-phone/$phone";

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _userName = data["name"] ?? _userName;
            _userEmail = data["email"] ?? _userEmail;
            _vehicleType = data["vehicleType"] ?? "";
            _vehicleNumber = data["vehicleNumber"] ?? "";
            _address = data["address"] ?? "";
            _vehicleColor = data["vehicleColor"] ?? "";
            _vehicleModel = data["vehicleModel"] ?? "";
          });
        }
      } catch (e) {
        debugPrint("Failed to load profile: $e");
      }
    }
  }

  // ✅ QR Popup function
  void _showQrPopup(BuildContext context) {
    if (_userPhone == null) return;

    final userData = jsonEncode({
      "name": _userName,
      "email": _userEmail,
      "phone": _userPhone,
      "vehicleType": _vehicleType,
      "vehicleNumber": _vehicleNumber,
      "address": _address,
      "vehicleColor": _vehicleColor,
      "vehicleModel": _vehicleModel,
    });

    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to close
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Your QR Code"),
          content: SizedBox(
            width: 220,
            height: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: userData,
                  version: QrVersions.auto,
                  size: 180,
                ),
                const SizedBox(height: 12),
                Text(
                  "Scan to get user details",
                  style: TextStyle(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: const Color(0xFFD7EE46),
          child: Text(
            _userName.isNotEmpty ? _userName[0].toUpperCase() : "U",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _userName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            _userEmail,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // ✅ Profile + QR buttons side by side
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final phone = await UserPreferences.getPhoneNumber();
                if (phone != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileDetailsEntryPage(phoneNumber: phone),
                    ),
                  );

                  if (result != null && result is Map<String, String>) {
                    setState(() {
                      _userName = result["name"] ?? _userName;
                      _userEmail = result["email"] ?? _userEmail;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD7EE46),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Profile",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            // ✅ QR Button
            ElevatedButton.icon(
              onPressed: () => _showQrPopup(context),
              icon: const Icon(Icons.qr_code, size: 18),
              label: const Text(
                "Show QR",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Account Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AccountSettingsPage()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Help & Support"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpSupportPage()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("About Us"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsPage()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}