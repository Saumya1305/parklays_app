import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'language_page.dart';
import 'theme_page.dart';
import 'privacy_page.dart';

// ---- Main Account Settings Page ----
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget navigateTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => navigateTo),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Account Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSettingTile(
            context: context,
            icon: Icons.notifications,
            iconColor: Colors.orange,
            title: "Notification Settings",
            subtitle: "Manage push and SMS alerts",
            navigateTo: const NotificationsPage(),
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.language,
            iconColor: Colors.teal,
            title: "Language",
            subtitle: "Choose app display language",
            navigateTo: const LanguagePage(),
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.color_lens,
            iconColor: Colors.purple,
            title: "Theme",
            subtitle: "Light / Dark mode",
            navigateTo: const ThemePage(),
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.privacy_tip,
            iconColor: Colors.indigo,
            title: "Privacy Settings",
            subtitle: "Manage permissions and privacy",
            navigateTo: const PrivacyPage(),
          ),
        ],
      ),
    );
  }
}
