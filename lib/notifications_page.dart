import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushEnabled = true;
  bool smsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notification Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Enable or disable app push alerts"),
            value: pushEnabled,
            onChanged: (value) {
              setState(() {
                pushEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? "Push Notifications Enabled"
                      : "Push Notifications Disabled"),
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text("SMS Notifications"),
            subtitle: const Text("Enable or disable SMS alerts"),
            value: smsEnabled,
            onChanged: (value) {
              setState(() {
                smsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? "SMS Notifications Enabled"
                      : "SMS Notifications Disabled"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
