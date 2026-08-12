// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../models/parking_lot.dart';
// import '../models/parking_session.dart';

// class ApiService {
//   static const String baseUrl = "http://localhost:5155/api";

//   // Parking Lots
//   static Future<List<ParkingLot>> fetchParkingLots() async {
//     final response = await http.get(Uri.parse('$baseUrl/parkinglots'));
//     if (response.statusCode == 200) {
//       List jsonData = json.decode(response.body);
//       return jsonData.map((lot) => ParkingLot.fromJson(lot)).toList();
//     } else {
//       throw Exception('Failed to load parking lots');
//     }
//   }

//   // Parking Sessions
//   static Future<List<ParkingSession>> fetchParkingSessions() async {
//     final response = await http.get(Uri.parse('$baseUrl/parkingsessions'));
//     if (response.statusCode == 200) {
//       List jsonData = json.decode(response.body);
//       return jsonData.map((s) => ParkingSession.fromJson(s)).toList();
//     } else {
//       throw Exception('Failed to load parking sessions');
//     }
//   }
// }






import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/parking_lot.dart';
import '../models/parking_session.dart';
import '../models/parking_slot.dart'; // <- added

class ApiService {
  static const String baseUrl = "http://192.168.29.185:5155/api";

  // Parking Lots
  static Future<List<ParkingLot>> fetchParkingLots() async {
    final response = await http.get(Uri.parse('$baseUrl/parkinglots'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((lot) => ParkingLot.fromJson(lot)).toList();
    } else {
      throw Exception('Failed to load parking lots');
    }
  }

  // Parking Sessions
  static Future<List<ParkingSession>> fetchParkingSessions() async {
    final response = await http.get(Uri.parse('$baseUrl/parkingsessions'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((s) => ParkingSession.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load parking sessions');
    }
  }

  // ✅ Fetch slots for a specific lot
  static Future<List<ParkingSlot>> fetchParkingSlots(int lotId) async {
    final response = await http.get(Uri.parse('$baseUrl/parkinglots/$lotId/slots'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => ParkingSlot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load parking slots');
    }
  }
  static Future<List<ParkingSession>> fetchHistory(String phone) async {
  final url = Uri.parse("$baseUrl/parkingsessions/by-phone/$phone");  // 👈 FIXED

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => ParkingSession.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load history");
  }
}
}
