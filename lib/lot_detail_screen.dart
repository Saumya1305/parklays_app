// import 'package:flutter/material.dart';
// import '../models/parking_lot.dart';
// import '../models/parking_slot.dart';
// import '../services/api_service.dart';

// class LotDetailScreen extends StatefulWidget {
//   final ParkingLot lot;
//   const LotDetailScreen({required this.lot, Key? key}) : super(key: key);

//   @override
//   State<LotDetailScreen> createState() => _LotDetailScreenState();
// }

// class _LotDetailScreenState extends State<LotDetailScreen> {
//   List<ParkingSlot> _slots = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSlots();
//   }

//   Future<void> _fetchSlots() async {
//     try {
//       final slots = await ApiService.fetchSlotsForLot(widget.lot.id);
//       setState(() {
//         _slots = slots;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error fetching slots: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.lot.name),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   // Grid of parking slots
//                   Expanded(
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         crossAxisSpacing: 6,
//                         mainAxisSpacing: 6,
//                       ),
//                       itemCount: _slots.length,
//                       itemBuilder: (context, index) {
//                         final slot = _slots[index];
//                         Color color;
//                         switch (slot.status) {
//                           case "occupied":
//                             color = Colors.red;
//                             break;
//                           case "reserved":
//                             color = Colors.orange;
//                             break;
//                           default:
//                             color = Colors.green;
//                         }
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: color,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Center(
//                               child: Text(
//                             "${slot.slotNumber}",
//                             style: const TextStyle(
//                                 color: Colors.white, fontWeight: FontWeight.bold),
//                           )),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   // Swipe-up style info bar
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                             "${widget.lot.address} • ${widget.lot.distance?.toStringAsFixed(1) ?? 0} km away"),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 // Open Google Maps navigation
//                               },
//                               icon: const Icon(Icons.navigation),
//                               label: const Text("Start"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green),
//                             ),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 // Show QR Scanner page
//                               },
//                               icon: const Icon(Icons.qr_code),
//                               label: const Text("Scan QR"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blueGrey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import '../models/parking_lot.dart';
// import '../models/parking_slot.dart';
// import '../services/api_service.dart';
// import 'lot_map_view.dart';

// class LotDetailScreen extends StatefulWidget {
//   final ParkingLot lot;
//   const LotDetailScreen({required this.lot, Key? key}) : super(key: key);

//   @override
//   State<LotDetailScreen> createState() => _LotDetailScreenState();
// }

// class _LotDetailScreenState extends State<LotDetailScreen> {
//   List<ParkingSlot> _slots = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSlots();
//   }

//   Future<void> _fetchSlots() async {
//     try {
//       final slots = await ApiService.fetchParkingSlots(widget.lot.id);
//       setState(() {
//         _slots = slots;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error fetching slots: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.lot.name),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   // Grid of parking slots
//                   Expanded(
//     child: _slots.isEmpty
//       ? const Center(
//           child: Text(
//             "Parking slots are not yet available for this lot.",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             textAlign: TextAlign.center,
//           ),
//         )
//       : GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 6,
//           ),
//           itemCount: _slots.length,
//           itemBuilder: (context, index) {
//             final slot = _slots[index];
//             Color color;
//             switch (slot.status) {
//               case "occupied":
//                 color = Colors.red;
//                 break;
//               case "reserved":
//                 color = Colors.orange;
//                 break;
//               default:
//                 color = Colors.green;
//             }
//             return Container(
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Center(
//                 child: Text(
//                   "${slot.slotNumber}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
// ),


//                   const SizedBox(height: 8),

//                   // Info bar
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${widget.lot.address}" +
//                               (widget.lot.distance != null
//                                   ? " • ${widget.lot.distance!.toStringAsFixed(1)} km away"
//                                   : ""),
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => LotMapView(lotId: widget.lot.id),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(Icons.navigation),
//                               label: const Text("Start"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                               ),
//                             ),

//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 // Show QR Scanner page
//                               },
//                               icon: const Icon(Icons.qr_code),
//                               label: const Text("Scan QR"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blueGrey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/parking_lot.dart';
import '../models/parking_slot.dart';
import '../services/api_service.dart';

class LotDetailScreen extends StatefulWidget {
  final ParkingLot lot;
  const LotDetailScreen({required this.lot, Key? key}) : super(key: key);

  @override
  State<LotDetailScreen> createState() => _LotDetailScreenState();
}

class _LotDetailScreenState extends State<LotDetailScreen> {
  List<ParkingSlot> _slots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    try {
      final slots = await ApiService.fetchParkingSlots(widget.lot.id);
      setState(() {
        _slots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching slots: $e")));
    }
  }

  // ✅ Function to open Google Maps for navigation
  Future<void> _openInGoogleMaps() async {
    final lat = widget.lot.latitude;
    final lon = widget.lot.longitude;
    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not available for this lot.")),
      );
      return;
    }

    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lon");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lot.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Grid of parking slots
                  Expanded(
                    child: _slots.isEmpty
                        ? const Center(
                            child: Text(
                              "Parking slots are not yet available for this lot.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                            ),
                            itemCount: _slots.length,
                            itemBuilder: (context, index) {
                              final slot = _slots[index];
                              Color color;
                              switch (slot.status) {
                                case "occupied":
                                  color = Colors.red;
                                  break;
                                case "reserved":
                                  color = Colors.orange;
                                  break;
                                default:
                                  color = Colors.green;
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    "${slot.slotNumber}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 8),

                  // Info bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.lot.address}" +
                              (widget.lot.distance != null
                                  ? " • ${widget.lot.distance!.toStringAsFixed(1)} km away"
                                  : ""),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ Start button now opens Google Maps navigation
                            ElevatedButton.icon(
                              onPressed: _openInGoogleMaps,
                              icon: const Icon(Icons.navigation),
                              label: const Text("Start"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),

                            // QR Code button placeholder
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Add QR Scanner page navigation
                              },
                              icon: const Icon(Icons.qr_code),
                              label: const Text("Scan QR"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
