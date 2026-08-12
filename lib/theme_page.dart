import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  bool isDarkMode = false; // Local state for theme toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Theme", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text("Dark Mode"),
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isDarkMode ? "Dark Mode Enabled" : "Light Mode Enabled",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
