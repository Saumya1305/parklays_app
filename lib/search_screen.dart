
// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'models/parking_lot.dart';
// import 'lot_map_view.dart'; // ✅ NEW: imported to navigate directly to map view

// class PlaceSuggestion {
//   final String displayName;
//   final double lat;
//   final double lon;

//   PlaceSuggestion({
//     required this.displayName,
//     required this.lat,
//     required this.lon,
//   });
// }

// class SearchScreen extends StatefulWidget {
//   final List<ParkingLot> parkingLots;
//   const SearchScreen({required this.parkingLots, Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _controller = TextEditingController();
//   Timer? _debounce;
//   List<ParkingLot> _localResults = [];
//   List<PlaceSuggestion> _nominatimSuggestions = [];
//   bool _loadingSuggestions = false;

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   // Called when user types something
//   void _onSearchChanged(String query) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       _doLocalSearch(query);
//       if (query.trim().length >= 2) {
//         _fetchNominatimSuggestions(query.trim());
//       } else {
//         setState(() => _nominatimSuggestions = []);
//       }
//     });
//   }

//   // Searches inside local list of parking lots
//   void _doLocalSearch(String q) {
//     final query = q.toLowerCase();
//     if (query.isEmpty) {
//       setState(() => _localResults = []);
//       return;
//     }
//     final results = widget.parkingLots.where((p) {
//       return p.name.toLowerCase().contains(query) ||
//           p.address.toLowerCase().contains(query);
//     }).toList();
//     setState(() => _localResults = results);
//   }

//   // Fetches online location suggestions from OpenStreetMap Nominatim API
//   Future<void> _fetchNominatimSuggestions(String input) async {
//     setState(() => _loadingSuggestions = true);
//     try {
//       final url = Uri.parse(
//           'https://nominatim.openstreetmap.org/search?q=$input&format=json&addressdetails=1&limit=5');
//       final resp =
//           await http.get(url, headers: {'User-Agent': 'ParklaysApp/1.0'});
//       final data = json.decode(resp.body) as List;
//       final suggestions = data.map((e) {
//         return PlaceSuggestion(
//           displayName: e['display_name'],
//           lat: double.parse(e['lat']),
//           lon: double.parse(e['lon']),
//         );
//       }).toList();
//       setState(() => _nominatimSuggestions = suggestions);
//     } catch (e) {
//       setState(() => _nominatimSuggestions = []);
//     } finally {
//       setState(() => _loadingSuggestions = false);
//     }
//   }

//   double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371.0; // km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = (sin(dLat / 2) * sin(dLat / 2)) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             (sin(dLon / 2) * sin(dLon / 2));
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);

//   void _onSelectPlace(PlaceSuggestion s) {
//     _checkAndShowParking(s.lat, s.lon, s.displayName);
//   }

//   // Shows info when you tap a place suggestion
//   void _checkAndShowParking(double lat, double lon, String label) {
//     List<MapEntry<ParkingLot, double>> nearby = [];
//     for (final lot in widget.parkingLots) {
//       if (lot.latitude != null && lot.longitude != null) {
//         final dist = _distanceKm(lat, lon, lot.latitude!, lot.longitude!);
//         nearby.add(MapEntry(lot, dist));
//       }
//     }
//     nearby.sort((a, b) => a.value.compareTo(b.value));

//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               const Text("We are not there yet."),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   _showNearbyParkingSheet(nearby);
//                 },
//                 icon: const Icon(Icons.local_parking),
//                 label: const Text("Show nearest parking"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Shows a list of nearby parking lots after tapping a place
//   void _showNearbyParkingSheet(List<MapEntry<ParkingLot, double>> nearby) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         if (nearby.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text("No parking lot coordinates available nearby."),
//           );
//         }
//         return ListView.separated(
//           padding: const EdgeInsets.all(8),
//           itemCount: nearby.length,
//           separatorBuilder: (_, __) => const Divider(),
//           itemBuilder: (context, index) {
//             final entry = nearby[index];
//             final lot = entry.key;
//             final dist = entry.value;
//             return ListTile(
//               title: Text(lot.name),
//               subtitle:
//                   Text("${lot.address}\n${dist.toStringAsFixed(2)} km away"),
//               isThreeLine: true,
//               onTap: () {
//                 Navigator.of(context).pop();
//                 // ✅ Changed here:
//                 // Previously opened LotDetailScreen
//                 // Now directly opens LotMapView
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => LotMapView(
//     lotId: lot.id,
//     latitude: lot.latitude ?? 0.0,
//     longitude: lot.longitude ?? 0.0,
//   ),
//                 ));
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   // UI layout of the search screen
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _controller,
//           autofocus: true,
//           onChanged: _onSearchChanged,
//           decoration: const InputDecoration(
//             hintText: "Search parking lots or places",
//             border: InputBorder.none,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               _controller.clear();
//               _onSearchChanged('');
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           if (_loadingSuggestions) const LinearProgressIndicator(),
//           Expanded(
//             child: ListView(
//               children: [
//                 // ✅ Local parking lot results
//                 if (_localResults.isNotEmpty) ...[
//                   const Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text("Parking lots",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   ..._localResults.map((lot) => ListTile(
//                         leading: const Icon(Icons.local_parking),
//                         title: Text(lot.name),
//                         subtitle: Text(lot.address),
//                         trailing: Text("${lot.freeSlots} free"),
//                         // ✅ Changed this navigation
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (_) => LotMapView(
//     lotId: lot.id,
//     latitude: lot.latitude ?? 0.0,
//     longitude: lot.longitude ?? 0.0,
//   ),
//                           ));
//                         },
//                       )),
//                   const Divider(),
//                 ],

//                 // Online place suggestions
//                 if (_nominatimSuggestions.isNotEmpty) ...[
//                   const Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text("Places",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   ..._nominatimSuggestions.map((s) => ListTile(
//                         leading: const Icon(Icons.place),
//                         title: Text(s.displayName),
//                         onTap: () => _onSelectPlace(s),
//                       )),
//                 ],

//                 // Message when empty
//                 if (_localResults.isEmpty && _nominatimSuggestions.isEmpty)
//                   const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Text("Type a place or parking lot name to search."),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'models/parking_lot.dart';
// import 'lot_map_view.dart'; // ✅ NEW: imported to navigate directly to map view

// class PlaceSuggestion {
//   final String displayName;
//   final double lat;
//   final double lon;

//   PlaceSuggestion({
//     required this.displayName,
//     required this.lat,
//     required this.lon,
//   });
// }

// class SearchScreen extends StatefulWidget {
//   final List<ParkingLot> parkingLots;
//   const SearchScreen({required this.parkingLots, Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _controller = TextEditingController();
//   Timer? _debounce;
//   List<ParkingLot> _localResults = [];
//   List<PlaceSuggestion> _nominatimSuggestions = [];
//   bool _loadingSuggestions = false;

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   // Called when user types something
//   void _onSearchChanged(String query) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       _doLocalSearch(query);
//       if (query.trim().length >= 2) {
//         _fetchNominatimSuggestions(query.trim());
//       } else {
//         setState(() => _nominatimSuggestions = []);
//       }
//     });
//   }

//   // Searches inside local list of parking lots
//   void _doLocalSearch(String q) {
//     final query = q.toLowerCase();
//     if (query.isEmpty) {
//       setState(() => _localResults = []);
//       return;
//     }
//     final results = widget.parkingLots.where((p) {
//       return p.name.toLowerCase().contains(query) ||
//           p.address.toLowerCase().contains(query);
//     }).toList();
//     setState(() => _localResults = results);
//   }

//   // Fetches online location suggestions from OpenStreetMap Nominatim API
//   Future<void> _fetchNominatimSuggestions(String input) async {
//     setState(() => _loadingSuggestions = true);
//     try {
//       final url = Uri.parse(
//           'https://nominatim.openstreetmap.org/search?q=$input&format=json&addressdetails=1&limit=5');
//       final resp =
//           await http.get(url, headers: {'User-Agent': 'ParklaysApp/1.0'});
//       final data = json.decode(resp.body) as List;
//       final suggestions = data.map((e) {
//         return PlaceSuggestion(
//           displayName: e['display_name'],
//           lat: double.parse(e['lat']),
//           lon: double.parse(e['lon']),
//         );
//       }).toList();
//       setState(() => _nominatimSuggestions = suggestions);
//     } catch (e) {
//       setState(() => _nominatimSuggestions = []);
//     } finally {
//       setState(() => _loadingSuggestions = false);
//     }
//   }

//   double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371.0; // km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = (sin(dLat / 2) * sin(dLat / 2)) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             (sin(dLon / 2) * sin(dLon / 2));
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);

//   void _onSelectPlace(PlaceSuggestion s) {
//     _checkAndShowParking(s.lat, s.lon, s.displayName);
//   }

//   // Shows info when you tap a place suggestion
//   void _checkAndShowParking(double lat, double lon, String label) {
//     List<MapEntry<ParkingLot, double>> nearby = [];
//     for (final lot in widget.parkingLots) {
//       if (lot.latitude != null && lot.longitude != null) {
//         final dist = _distanceKm(lat, lon, lot.latitude!, lot.longitude!);
//         nearby.add(MapEntry(lot, dist));
//       }
//     }
//     nearby.sort((a, b) => a.value.compareTo(b.value));

//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               const Text("We are not there yet."),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   _showNearbyParkingSheet(nearby);
//                 },
//                 icon: const Icon(Icons.local_parking),
//                 label: const Text("Show nearest parking"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Shows a list of nearby parking lots after tapping a place
//   void _showNearbyParkingSheet(List<MapEntry<ParkingLot, double>> nearby) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         if (nearby.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text("No parking lot coordinates available nearby."),
//           );
//         }
//         return ListView.separated(
//           padding: const EdgeInsets.all(8),
//           itemCount: nearby.length,
//           separatorBuilder: (_, __) => const Divider(),
//           itemBuilder: (context, index) {
//             final entry = nearby[index];
//             final lot = entry.key;
//             final dist = entry.value;
//             return ListTile(
//               title: Text(lot.name),
//               subtitle:
//                   Text("${lot.address}\n${dist.toStringAsFixed(2)} km away"),
//               isThreeLine: true,
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => LotMapView(
//                     lotId: lot.id,
//                     latitude: lot.latitude ?? 0.0,
//                     longitude: lot.longitude ?? 0.0,
//                   ),
//                 ));
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   // ✅ UI layout with soft faded white background
//   @override
//   Widget build(BuildContext context) {
//     const Color softWhite = Color(0xFFEFF0EF);
//     const Color darkBlack = Color(0xFF060606);
//     const Color neonLime = Color(0xFF00FF66);

//     return Scaffold(
//       backgroundColor: softWhite,
//       appBar: AppBar(
//         backgroundColor: softWhite,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: neonLime),
//         title: TextField(
//           controller: _controller,
//           autofocus: true,
//           style: const TextStyle(color: darkBlack),
//           onChanged: _onSearchChanged,
//           decoration: const InputDecoration(
//             hintText: "Search parking lots or places",
//             hintStyle: TextStyle(color: Colors.black54),
//             border: InputBorder.none,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.clear, color: neonLime),
//             onPressed: () {
//               _controller.clear();
//               _onSearchChanged('');
//             },
//           )
//         ],
//       ),
//       body: Container(
//         color: softWhite,
//         child: Column(
//           children: [
//             if (_loadingSuggestions)
//               const LinearProgressIndicator(color: neonLime),
//             Expanded(
//               child: ListView(
//                 children: [
//                   if (_localResults.isNotEmpty) ...[
//                     const Padding(
//                       padding: EdgeInsets.all(8),
//                       child: Text(
//                         "Parking lots",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: darkBlack),
//                       ),
//                     ),
//                     ..._localResults.map((lot) => ListTile(
//                           leading:
//                               const Icon(Icons.local_parking, color: neonLime),
//                           title: Text(lot.name,
//                               style: const TextStyle(color: darkBlack)),
//                           subtitle: Text(lot.address,
//                               style: const TextStyle(color: Colors.black54)),
//                           trailing: Text("${lot.freeSlots} free",
//                               style: const TextStyle(color: darkBlack)),
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (_) => LotMapView(
//                                 lotId: lot.id,
//                                 latitude: lot.latitude ?? 0.0,
//                                 longitude: lot.longitude ?? 0.0,
//                               ),
//                             ));
//                           },
//                         )),
//                     const Divider(color: darkBlack),
//                   ],
//                   if (_nominatimSuggestions.isNotEmpty) ...[
//                     const Padding(
//                       padding: EdgeInsets.all(8),
//                       child: Text(
//                         "Places",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: darkBlack),
//                       ),
//                     ),
//                     ..._nominatimSuggestions.map((s) => ListTile(
//                           leading: const Icon(Icons.place, color: neonLime),
//                           title: Text(s.displayName,
//                               style: const TextStyle(color: darkBlack)),
//                           onTap: () => _onSelectPlace(s),
//                         )),
//                   ],
//                   if (_localResults.isEmpty && _nominatimSuggestions.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Text(
//                         "Type a place or parking lot name to search.",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/parking_lot.dart';
import 'lot_map_view.dart';

class PlaceSuggestion {
  final String displayName;
  final double lat;
  final double lon;

  PlaceSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}

class SearchScreen extends StatefulWidget {
  final List<ParkingLot> parkingLots;
  const SearchScreen({required this.parkingLots, Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<ParkingLot> _localResults = [];
  List<PlaceSuggestion> _nominatimSuggestions = [];
  bool _loadingSuggestions = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _doLocalSearch(query);
      if (query.trim().length >= 2) {
        _fetchNominatimSuggestions(query.trim());
      } else {
        setState(() => _nominatimSuggestions = []);
      }
    });
  }

  void _doLocalSearch(String q) {
    final query = q.toLowerCase();
    if (query.isEmpty) {
      setState(() => _localResults = []);
      return;
    }
    final results = widget.parkingLots.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.address.toLowerCase().contains(query);
    }).toList();
    setState(() => _localResults = results);
  }

  Future<void> _fetchNominatimSuggestions(String input) async {
    setState(() => _loadingSuggestions = true);
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$input&format=json&addressdetails=1&limit=5');
      final resp =
          await http.get(url, headers: {'User-Agent': 'ParklaysApp/1.0'});
      final data = json.decode(resp.body) as List;
      final suggestions = data.map((e) {
        return PlaceSuggestion(
          displayName: e['display_name'],
          lat: double.parse(e['lat']),
          lon: double.parse(e['lon']),
        );
      }).toList();
      setState(() => _nominatimSuggestions = suggestions);
    } catch (e) {
      setState(() => _nominatimSuggestions = []);
    } finally {
      setState(() => _loadingSuggestions = false);
    }
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  void _onSelectPlace(PlaceSuggestion s) {
    _checkAndShowParking(s.lat, s.lon, s.displayName);
  }

  void _checkAndShowParking(double lat, double lon, String label) {
    List<MapEntry<ParkingLot, double>> nearby = [];
    for (final lot in widget.parkingLots) {
      if (lot.latitude != null && lot.longitude != null) {
        final dist = _distanceKm(lat, lon, lot.latitude!, lot.longitude!);
        nearby.add(MapEntry(lot, dist));
      }
    }
    nearby.sort((a, b) => a.value.compareTo(b.value));

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF6F8F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF060606))),
              const SizedBox(height: 8),
              const Text("We are not there yet.",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  foregroundColor: const Color(0xFF060606),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showNearbyParkingSheet(nearby);
                },
                icon: const Icon(Icons.local_parking),
                label: const Text("Show nearest parking"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNearbyParkingSheet(List<MapEntry<ParkingLot, double>> nearby) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF6F8F3),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        if (nearby.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No parking lot coordinates available nearby."),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: nearby.length,
          separatorBuilder: (_, __) =>
              Divider(color: Colors.black.withOpacity(0.1)),
          itemBuilder: (context, index) {
            final entry = nearby[index];
            final lot = entry.key;
            final dist = entry.value;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.local_parking,
                    color: Color(0xFF00FF66), size: 30),
                title: Text(lot.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF060606))),
                subtitle: Text(
                  "${lot.address}\n${dist.toStringAsFixed(2)} km away",
                  style: const TextStyle(color: Colors.black54),
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LotMapView(
                      lotId: lot.id,
                      latitude: lot.latitude ?? 0.0,
                      longitude: lot.longitude ?? 0.0,
                    ),
                  ));
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color softWhite = Color(0xFFF6F8F3);
    const Color pastelGreen = Color(0xFFE7F3C7);
    const Color darkBlack = Color(0xFF060606);
    const Color neonLime = Color(0xFF00FF66);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: neonLime),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: darkBlack),
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              hintText: "Search parking lots or places",
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: neonLime),
            onPressed: () {
              _controller.clear();
              _onSearchChanged('');
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [softWhite, pastelGreen],
          ),
        ),
        child: Column(
          children: [
            if (_loadingSuggestions)
              const LinearProgressIndicator(color: neonLime),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (_localResults.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Parking lots",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkBlack,
                              fontSize: 16)),
                    ),
                    ..._localResults.map((lot) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.local_parking,
                                color: neonLime, size: 28),
                            title: Text(lot.name,
                                style: const TextStyle(color: darkBlack)),
                            subtitle: Text(lot.address,
                                style:
                                    const TextStyle(color: Colors.black54)),
                            trailing: Text("${lot.freeSlots} free",
                                style: const TextStyle(color: darkBlack)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LotMapView(
                                  lotId: lot.id,
                                  latitude: lot.latitude ?? 0.0,
                                  longitude: lot.longitude ?? 0.0,
                                ),
                              ));
                            },
                          ),
                        )),
                  ],
                  if (_nominatimSuggestions.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Places",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkBlack,
                              fontSize: 16)),
                    ),
                    ..._nominatimSuggestions.map((s) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.place,
                                color: neonLime, size: 28),
                            title: Text(s.displayName,
                                style: const TextStyle(color: darkBlack)),
                            onTap: () => _onSelectPlace(s),
                          ),
                        )),
                  ],
                  if (_localResults.isEmpty && _nominatimSuggestions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        "Type a place or parking lot name to search.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 15),
                      ),
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
