// import 'package:flutter/material.dart';
// import 'package:parklays/services/admin_api.dart';
// import 'admin_dashboard.dart';

// class AdminLoginScreen extends StatefulWidget {
//   const AdminLoginScreen({super.key});

//   @override
//   State<AdminLoginScreen> createState() => _AdminLoginScreenState();
// }

// class _AdminLoginScreenState extends State<AdminLoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   bool loading = false;

//   void login() async {
//     final phoneNumber = phoneController.text.trim();

//     if (phoneNumber.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Enter phone number")));
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       final adminData = await AdminApi.loginAdmin(phoneNumber);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => AdminDashboard(admin: adminData),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Invalid phone number")));
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           width: 340,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4))
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Admin Login",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: "Phone Number",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: loading ? null : login,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Login"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:parklays/services/admin_api.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;

  void login() async {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter phone number")));
      return;
    }

    setState(() => loading = true);

    try {
      final adminData = await AdminApi.loginAdmin(phoneNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(admin: adminData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid phone number")));
    } finally {
      setState(() => loading = false);
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  SizedBox(height: height * 0.08),

                  // App Logo
                  Image.asset(
                    'assets/images/Logoo.png',
                    height: height * 0.2,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    "Admin Login",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF060606),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your registered phone number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Phone Input Field with glassy effect
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
                      controller: phoneController,
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

                  // Login Button
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
                      onPressed: loading ? null : login,
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
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "You’ll receive an SMS for verification",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

