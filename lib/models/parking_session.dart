// class ParkingSession {
//   final int id;
//   final int parkingLotId;
//   final DateTime startTime;
//   final DateTime? endTime;

//   ParkingSession({
//     required this.id,
//     required this.parkingLotId,
//     required this.startTime,
//     this.endTime,
//   });

//   factory ParkingSession.fromJson(Map<String, dynamic> json) {
//     return ParkingSession(
//       id: json['id'],
//       parkingLotId: json['parkingLotId'],
//       startTime: DateTime.parse(json['startTime']),
//       endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
//     );
//   }
// }

// class ParkingSession {
//   final int id;
//   final int parkingLotId;
//   final DateTime startTime;
//   final DateTime? endTime;

//   ParkingSession({
//     required this.id,
//     required this.parkingLotId,
//     required this.startTime,
//     this.endTime,
//   });

//   factory ParkingSession.fromJson(Map<String, dynamic> json) {
//     return ParkingSession(
//       id: json['id'] ?? 0,
//       parkingLotId: json['parkingLotId'] ?? 0,
//       startTime: json['startTime'] != null
//           ? DateTime.parse(json['startTime'])
//           : DateTime.now(),
//       endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
//     );
//   }
// }

// class ParkingSession {
//   final int id;
//   final int lotId;
//   final int slotId;
//   final int slotNumber;
//   final String userName;
//   final String vehicleType;
//   final String vehicleNumber;
//   final String email;
//   final String phone;
//   final String vehicleColor;
//   final String vehicleModel;
//   final DateTime startTime;
//   final DateTime? endTime;
//   final String status;
//   final int? scannedBy;

//   ParkingSession({
//     required this.id,
//     required this.lotId,
//     required this.slotId,
//     required this.slotNumber,
//     required this.userName,
//     required this.vehicleType,
//     required this.vehicleNumber,
//     required this.email,
//     required this.phone,
//     required this.vehicleColor,
//     required this.vehicleModel,
//     required this.startTime,
//     this.endTime,
//     required this.status,
//     this.scannedBy,
//   });

//   factory ParkingSession.fromJson(Map<String, dynamic> json) {
//     return ParkingSession(
//       id: json['id'] ?? 0,
//       lotId: json['lotId'] ?? 0,
//       slotId: json['slotId'] ?? 0,
//       slotNumber: json['slotNumber'] ?? 0,
//       userName: json['user_name'] ?? '',
//       vehicleType: json['vehicle_type'] ?? '',
//       vehicleNumber: json['vehicle_number'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       vehicleColor: json['vehicle_color'] ?? '',
//       vehicleModel: json['vehicle_model'] ?? '',
//       startTime: json['entry_time'] != null
//           ? DateTime.parse(json['entry_time'])
//           : DateTime.now(),
//       endTime: json['exit_time'] != null
//           ? DateTime.parse(json['exit_time'])
//           : null,
//       status: json['status'] ?? 'active',
//       scannedBy: json['scanned_by'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "lotId": lotId,
//       "slotId": slotId,
//       "slotNumber": slotNumber,
//       "userName": userName,
//       "vehicleType": vehicleType,
//       "vehicleNumber": vehicleNumber,
//       "email": email,
//       "phone": phone,
//       "vehicleColor": vehicleColor,
//       "vehicleModel": vehicleModel,
//       "scannedBy": scannedBy,
//       "entryTime": startTime.toIso8601String(),
//       "exitTime": endTime?.toIso8601String(),
//       "status": status,
//     };
//   }
// }






class ParkingSession {
  final int id;
  final int lotId;
  final int slotId;
  final int slotNumber;
  final String userName;
  final String vehicleType;
  final String vehicleNumber;
  final String email;
  final String phone;
  final String vehicleColor;
  final String vehicleModel;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final int? scannedBy;

  ParkingSession({
    required this.id,
    required this.lotId,
    required this.slotId,
    required this.slotNumber,
    required this.userName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.email,
    required this.phone,
    required this.vehicleColor,
    required this.vehicleModel,
    required this.startTime,
    this.endTime,
    required this.status,
    this.scannedBy,
  });

  factory ParkingSession.fromJson(Map<String, dynamic> json) {
    return ParkingSession(
      id: json['Id'] ?? 0,
      lotId: json['lotId'] ?? 0,        // FIXED
      slotId: json['slotId'] ?? 0,      // FIXED
      slotNumber: json['slotNumber'] ?? 0,  // FIXED

      userName: json['user_name'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',

      startTime: json['entry_time'] != null
          ? DateTime.parse(json['entry_time'])
          : DateTime.now(),
      endTime: json['exit_time'] != null
          ? DateTime.parse(json['exit_time'])
          : null,

      status: json['status'] ?? 'active',
      scannedBy: json['scanned_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lotid": lotId,             // FIXED
      "slotid": slotId,           // FIXED
      "slotnumber": slotNumber,   // FIXED

      "user_name": userName,
      "vehicle_type": vehicleType,
      "vehicle_number": vehicleNumber,
      "email": email,
      "phone": phone,
      "vehicle_color": vehicleColor,
      "vehicle_model": vehicleModel,

      "scanned_by": scannedBy,
      "entry_time": startTime.toIso8601String(),
      "exit_time": endTime?.toIso8601String(),
      "status": status,
    };
  }
}
