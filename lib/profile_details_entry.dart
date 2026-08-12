import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileDetailsEntryPage extends StatefulWidget {
  final String phoneNumber;

  const ProfileDetailsEntryPage({super.key, required this.phoneNumber});

  @override
  State<ProfileDetailsEntryPage> createState() =>
      _ProfileDetailsEntryPageState();
}

class _ProfileDetailsEntryPageState extends State<ProfileDetailsEntryPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();

  String? _selectedVehicleType;

  bool _isSaved = false;
  bool _loading = true;
  int? _profileId;

  final String _baseUrl = "http://10.193.188.44:5155/api/UserProfiles";

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/by-phone/${widget.phoneNumber}"));
      if (response.statusCode == 200) {
        final profile = jsonDecode(response.body);
        setState(() {
          _profileId = profile["id"];
          _nameController.text = profile["name"] ?? "";
          _emailController.text = profile["email"] ?? "";
          _addressController.text = profile["address"] ?? "";
          _vehicleNumberController.text = profile["vehicleNumber"] ?? "";
          _vehicleModelController.text = profile["vehicleModel"] ?? "";
          _vehicleColorController.text = profile["vehicleColor"] ?? "";
          _selectedVehicleType = profile["vehicleType"] ?? "";
          _loading = false;
        });
      } else {
        // Profile not found → new user
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      setState(() {
        _loading = false;
      });
    }
  }

Future<void> _saveProfile() async {
  final profileData = {
    "Name": _nameController.text.trim(),
    "Email": _emailController.text.trim(),
    "PhoneNumber": widget.phoneNumber,
    "Address": _addressController.text.trim(),
    "VehicleType": _selectedVehicleType ?? "",
    "VehicleNumber": _vehicleNumberController.text.trim(),
    "VehicleModel": _vehicleModelController.text.trim(),
    "VehicleColor": _vehicleColorController.text.trim(),
  };

  try {
    http.Response response;

    if (_profileId != null) {
      response = await http.put(
        Uri.parse("$_baseUrl/by-phone/${widget.phoneNumber}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileData),
      );
    } else {
      response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileData),
      );
    }

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isSaved = true;
          if (_profileId == null) {
            _profileId = jsonDecode(response.body)["id"];
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_profileId != null
                ? "✅ Profile updated"
                : "✅ Profile created"),
          ),
        );

        Navigator.pop(context, {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("❌ Failed [${response.statusCode}]: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final softWhite = const Color(0xFFEFF0EF);
    final limeGreen = const Color(0xFFD7EE46);

    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: softWhite,
        elevation: 0,
        title: const Text(
          "Profile Details",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCardTextField(_nameController, "Full Name", Icons.person),
                _buildCardTextField(_emailController, "Email", Icons.email),
                _buildCardTextField(_addressController, "Address", Icons.home),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<String>(
                      value: _selectedVehicleType?.isEmpty == true
                          ? null
                          : _selectedVehicleType,
                      items: ["2 Wheeler", "4 Wheeler"]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedVehicleType = value);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                  ),
                ),
                _buildCardTextField(
                    _vehicleNumberController, "Vehicle Number", Icons.confirmation_number),
                _buildCardTextField(
                    _vehicleModelController, "Vehicle Model", Icons.directions_car_filled),
                _buildCardTextField(
                    _vehicleColorController, "Vehicle Color", Icons.color_lens),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: limeGreen,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(_isSaved ? "Saved ✅" : "Save Details"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTextField(
      TextEditingController controller, String label, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "This field is required" : null,
        ),
      ),
    );
  }
}
