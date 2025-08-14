import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileSetupScreen extends StatefulWidget {
  final String phoneNumber;
  const ProfileSetupScreen({super.key, required this.phoneNumber});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _carModelController = TextEditingController();
  final _colorController = TextEditingController();
  final _insuranceNumberController = TextEditingController();

  String? _selectedCarBrand;
  bool _isLoading = false;

  final List<String> _carBrands = [
    'Toyota',
    'Honda',
    'Tesla',
    'BMW',
    'Mercedes',
    'Ford',
    'Hyundai',
    'Other'
  ];

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: 'jwt_token');

      final response = await http.post(
        Uri.parse('http://YOUR_BACKEND_URL/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': widget.phoneNumber,
          'carNumber': _carNumberController.text.trim(),
          'carModel': _carModelController.text.trim(),
          'carBrand': _selectedCarBrand,
          'color': _colorController.text.trim().isEmpty
              ? null
              : _colorController.text.trim(),
          'insuranceNumber': _insuranceNumberController.text.trim().isEmpty
              ? null
              : _insuranceNumberController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0C1633),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Info Section
              const Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1633),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                validator: (value) =>
                    value!.isEmpty ? 'Full Name is required' : null,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required';
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Phone Number',
                initialValue: widget.phoneNumber,
                readOnly: true,
              ),

              const SizedBox(height: 30),

              // Car Details Section
              const Text(
                "Car Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1633),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _carNumberController,
                label: 'Car Number / License Plate',
                validator: (value) =>
                    value!.isEmpty ? 'Car Number is required' : null,
              ),
              _buildTextField(
                controller: _carModelController,
                label: 'Car Model',
                validator: (value) =>
                    value!.isEmpty ? 'Car Model is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCarBrand,
                decoration: InputDecoration(
                  labelText: 'Car Brand',
                  filled: true,
                  fillColor: const Color(0xFFF0F1F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _carBrands.map((brand) {
                  return DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCarBrand = value);
                },
                validator: (value) =>
                    value == null ? 'Car Brand is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _colorController,
                label: 'Color (Optional)',
              ),
              _buildTextField(
                controller: _insuranceNumberController,
                label: 'Insurance Number (Optional)',
              ),

              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF508A1E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? initialValue,
    required String label,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF0F1F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFF508A1E), width: 2),
          ),
        ),
      ),
    );
  }
}
