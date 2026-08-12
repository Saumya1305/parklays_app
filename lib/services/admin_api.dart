// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AdminApi {
//   static const String baseUrl = "http://localhost:5155/api";  
//   // For real device → replace with your LAN IP

//   // ------------------------
//   // 1. ADMIN LOGIN
//   // ------------------------
//   static Future<Map<String, dynamic>> loginAdmin(String phoneNumber) async {
//     final url = Uri.parse("$baseUrl/admin/login");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"phone": phoneNumber}),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Invalid Phone Number");
//     }
//   }

//   // ------------------------
//   // 2. GET SLOTS FOR ADMIN
//   // ------------------------
//   static Future<List<dynamic>> getSlots(int lotId) async {
//     final url = Uri.parse("$baseUrl/admin/slots/$lotId");

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to fetch slots");
//     }
//   }

//   // ------------------------
//   // 3. UPDATE SLOT STATUS (Guard manually updates)
//   // ------------------------
//   static Future<bool> updateSlot(int slotId, bool isAvailable) async {
//     final url = Uri.parse("$baseUrl/admin/updateslot/$slotId");

//     final response = await http.put(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"isAvailable": isAvailable}),
//     );

//     return response.statusCode == 200;
//   }

//   // ------------------------
//   // 4. START PARKING SESSION (QR Scan)
//   // ------------------------
//   static Future<Map<String, dynamic>> startSession(
//       int slotId, String vehicleNumber) async {
//     final url = Uri.parse("$baseUrl/admin/startsession");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "slotId": slotId,
//         "vehicleNumber": vehicleNumber,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to start session");
//     }
//   }

//   // ------------------------
//   // 5. END PARKING SESSION
//   // ------------------------
//   static Future<bool> endSession(int sessionId) async {
//     final url = Uri.parse("$baseUrl/admin/endsession/$sessionId");

//     final response = await http.put(url);

//     return response.statusCode == 200;
//   }
// }






import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApi {
  // ⭐ IMPORTANT: Use your PC LAN IP, not localhost
  static const String baseUrl = "http://192.168.29.185:5155/api";

  // --------------------------------------------------
  // 1. ADMIN LOGIN
  // --------------------------------------------------
  static Future<Map<String, dynamic>> loginAdmin(String phoneNumber) async {
    final url = Uri.parse("$baseUrl/admin/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phoneNumber}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Invalid Phone Number");
    }
  }

  // --------------------------------------------------
  // 2. GET ADMIN PROFILE
  // --------------------------------------------------
  static Future<Map<String, dynamic>> getAdminProfile(int adminId) async {
    final url = Uri.parse("$baseUrl/admin/profile/$adminId");

    final response = await http.get(url, headers: {
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch admin profile");
    }
  }

  // --------------------------------------------------
  // 3. GET SLOTS (by Admin lot)
  // --------------------------------------------------
  static Future<List<dynamic>> getSlots(int adminId) async {
    final url = Uri.parse("$baseUrl/admin/$adminId/slots");

    final response = await http.get(url, headers: {
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("No slots found for this admin");
    } else {
      throw Exception("Failed to load slots: ${response.statusCode}");
    }
  }

  // --------------------------------------------------
// 4. UPDATE SLOT STATUS  ✔ FIXED
// --------------------------------------------------
static Future<bool> updateSlot(int slotId, bool isFree) async {
  final url = Uri.parse("$baseUrl/admin/slot-status/$slotId");

  final body = {
    "isFree": isFree,   // ⭐ MUST match backend DTO name
  };

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print("UPDATE SLOT FAILED → ${response.statusCode}");
    print("BODY SENT → ${jsonEncode(body)}");
    print("SERVER RESPONSE → ${response.body}");
    return false;
  }
}


  // --------------------------------------------------
  // 5. START PARKING SESSION
  // --------------------------------------------------
  static Future<Map<String, dynamic>> startSession(
      int slotId, String vehicleNumber) async {
    final url = Uri.parse("$baseUrl/admin/scan");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "slotId": slotId,
        "vehicleNumber": vehicleNumber,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to start session");
    }
  }

  // --------------------------------------------------
  // 6. END PARKING SESSION
  // --------------------------------------------------
  static Future<bool> endSession(int sessionId) async {
    final url = Uri.parse("$baseUrl/admin/end-session/$sessionId");

    final response = await http.put(url);

    return response.statusCode == 200;
  }
  // --------------------------------------------------
  // 7. FETCH PARKING HISTORY FOR ADMIN
  // --------------------------------------------------

}
