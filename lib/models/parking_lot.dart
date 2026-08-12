// // class ParkingLot {
// //   final int id;
// //   final String name;
// //   final String location;   // can keep for internal usage
// //   final int capacity;      // total slots
// //   final String address;    // for UI display
// //   final String imageUrl;   // for UI display
// //   final int freeSlots;     // available slots

// //   ParkingLot({
// //     required this.id,
// //     required this.name,
// //     required this.location,
// //     required this.capacity,
// //     required this.address,
// //     required this.imageUrl,
// //     required this.freeSlots,
// //   });

// //   // Factory constructor to create a ParkingLot from JSON
// //   factory ParkingLot.fromJson(Map<String, dynamic> json) {
// //     return ParkingLot(
// //       id: json['id'],
// //       name: json['name'] ?? 'Unknown',
// //       location: json['location'] ?? 'Unknown location',
// //       capacity: json['capacity'] ?? 0,
// //       address: json['address'] ?? json['location'] ?? 'Unknown location',
// //       imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200',
// //       freeSlots: json['freeSlots'] ?? 0,
// //     );
// //   }
// // }







// class ParkingLot {
//   final int id;
//   final String name;
//   final String location;   // internal usage
//   final int capacity;      // total slots
//   final String address;    // for UI display
//   final String imageUrl;   // for UI display
//   final int freeSlots;     // available slots
//   final double? distance;  // NEW: optional distance in km

//   ParkingLot({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.capacity,
//     required this.address,
//     required this.imageUrl,
//     required this.freeSlots,
//     this.distance,
//   });

//   factory ParkingLot.fromJson(Map<String, dynamic> json) {
//     return ParkingLot(
//       id: json['id'],
//       name: json['name'] ?? 'Unknown',
//       location: json['location'] ?? 'Unknown location',
//       capacity: json['capacity'] ?? 0,
//       address: json['address'] ?? json['location'] ?? 'Unknown location',
//       imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200',
//       freeSlots: json['freeSlots'] ?? 0,
//       distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
//     );
//   }
// }







// class ParkingLot {
//   final int id;
//   final String name;
//   final String location;   // internal usage
//   final int capacity;      // total slots
//   final String address;    // for UI display
//   final String imageUrl;   // for UI display
//   final int freeSlots;     // available slots
//   final double? distance;  // NEW: optional distance in km

//   ParkingLot({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.capacity,
//     required this.address,
//     required this.imageUrl,
//     required this.freeSlots,
//     this.distance,
//   });

//   factory ParkingLot.fromJson(Map<String, dynamic> json) {
//     return ParkingLot(
//       id: json['id'],
//       name: json['name'] ?? 'Unknown',
//       location: json['location'] ?? 'Unknown location',
//       capacity: json['capacity'] ?? 0,
//       address: json['address'] ?? json['location'] ?? 'Unknown location',
//       imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200',
//       freeSlots: json['freeSlots'] ?? 0,
//       distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
//     );
//   }
// }






// class ParkingLot {
//   final int id;
//   final String name;
//   final String location;   // internal usage / string
//   final int capacity;      // total slots
//   final String address;    // for UI display
//   final String imageUrl;   // for UI display
//   final int freeSlots;     // available slots
//   final double? latitude;  // NEW: optional latitude
//   final double? longitude; // NEW: optional longitude
//   final double? distance;  // optional distance in km (computed dynamically)

//   ParkingLot({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.capacity,
//     required this.address,
//     required this.imageUrl,
//     required this.freeSlots,
//     this.latitude,
//     this.longitude,
//     this.distance,
//   });

//   factory ParkingLot.fromJson(Map<String, dynamic> json) {
//     return ParkingLot(
//       id: json['id'],
//       name: json['name'] ?? 'Unknown',
//       location: json['location'] ?? 'Unknown location',
//       capacity: json['capacity'] ?? 0,
//       address: json['address'] ?? json['location'] ?? 'Unknown location',
//       imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200',
//       freeSlots: json['freeSlots'] ?? 0,
//       latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
//       longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
//       distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
//     );
//   }
// }










class ParkingLot {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final String address;
  final String imageUrl;
  final int freeSlots;
  final double? latitude;
  final double? longitude;
  final double? distance;

  ParkingLot({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.address,
    required this.imageUrl,
    required this.freeSlots,
    this.latitude,
    this.longitude,
    this.distance,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown location',
      capacity: json['capacity'] ?? 0,
      address: json['address'] ?? json['location'] ?? 'Unknown address',
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200',
      freeSlots: json['freeSlots'] ?? 0,
      latitude: (json['latitude'] != null) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] != null) ? (json['longitude'] as num).toDouble() : null,
      distance: (json['distance'] != null) ? (json['distance'] as num).toDouble() : null,
    );
  }
}
