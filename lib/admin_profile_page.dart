import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  final Map<String, dynamic> admin;

  const AdminProfilePage({super.key, required this.admin});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.admin['admin']['name']);
    dobController = TextEditingController(text: widget.admin['admin']['dob']);
    emailController =
        TextEditingController(text: widget.admin['admin']['email']);
    phoneController =
        TextEditingController(text: widget.admin['admin']['phone']);
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void saveProfile() {
    print("Updated Profile:");
    print("Name: ${nameController.text}");
    print("DOB: ${dobController.text}");
    print("Email: ${emailController.text}");
    print("Phone (static): ${phoneController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    String? hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: softWhite,
        foregroundColor: darkBlack,
        elevation: 0,
        title: const Text(
          "Admin Profile",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= Profile Picture =================
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pureWhite,
                      boxShadow: [
                        BoxShadow(
                          color: darkBlack.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: limeGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: pureWhite, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= Fields =================
            _buildTextField(label: "Name", controller: nameController),
            _buildTextField(
              label: "Date of Birth",
              controller: dobController,
              hintText: "YYYY-MM-DD",
            ),
            _buildTextField(label: "Email", controller: emailController),
            _buildTextField(
              label: "Phone (cannot change)",
              controller: phoneController,
              enabled: false,
            ),

            const SizedBox(height: 24),

            // ================= Save Button =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: limeGreen,
                  foregroundColor: darkBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  shadowColor: darkBlack.withOpacity(0.3),
                  elevation: 6,
                ),
                child: const Text(
                  "Save Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
