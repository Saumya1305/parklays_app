// class ParkingSlot {
//   final int id;
//   final int parkingLotId; // Link to ParkingLot
//   final int slotNumber;   // Unique number for the slot
//   final String status;    // "free", "occupied", "reserved"

//   ParkingSlot({
//     required this.id,
//     required this.parkingLotId,
//     required this.slotNumber,
//     required this.status,
//   });

//   // Factory constructor to create from JSON
//   factory ParkingSlot.fromJson(Map<String, dynamic> json) {
//     return ParkingSlot(
//       id: json['id'],
//       parkingLotId: json['parkingLotId'],
//       slotNumber: json['slotNumber'],
//       status: json['status'] ?? 'free',
//     );
//   }

//   // Optional: helper to check if slot is occupied
//   bool get isOccupied => status.toLowerCase() == 'occupied';
//   bool get isFree => status.toLowerCase() == 'free';
//   bool get isReserved => status.toLowerCase() == 'reserved';
// }






// class ParkingSlot {
//   final int id;
//   final int lotId;       // ✅ matches backend field name
//   final int slotNumber;
//   final String status;

//   ParkingSlot({
//     required this.id,
//     required this.lotId,
//     required this.slotNumber,
//     required this.status,
//   });

//   factory ParkingSlot.fromJson(Map<String, dynamic> json) {
//     return ParkingSlot(
//       id: json['id'],
//       lotId: json['lotId'], // ✅ changed from parkingLotId
//       slotNumber: json['slotNumber'],
//       status: json['status'] ?? 'free',
//     );
//   }

//   bool get isOccupied => status.toLowerCase() == 'occupied';
//   bool get isFree => status.toLowerCase() == 'free';
//   bool get isReserved => status.toLowerCase() == 'reserved';
// }







class ParkingSlot {
  final int id;
  final int lotId;        // must match backend
  final int slotNumber;
  final String status;

  ParkingSlot({
    required this.id,
    required this.lotId,
    required this.slotNumber,
    required this.status,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'] ?? 0,
      lotId: json['lotId'] ?? 0, // ✅ handles both names
      slotNumber: json['slotNumber'] ?? 0,
      status: json['status'] ?? 'free',
    );
  }

  bool get isOccupied => status.toLowerCase() == 'occupied';
  bool get isFree => status.toLowerCase() == 'free';
  bool get isReserved => status.toLowerCase() == 'reserved';
}
