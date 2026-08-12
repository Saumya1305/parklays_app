import 'package:shared_preferences/shared_preferences.dart';

/// A helper class to manage logged-in user's phone number using SharedPreferences
class UserPreferences {
  static const String _keyPhoneNumber = 'loggedInPhone';

  /// Save the logged-in user's phone number
  static Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  /// Get the logged-in user's phone number
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  /// Remove the saved phone number (e.g., on logout)
  static Future<void> clearPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoneNumber);
  }
}