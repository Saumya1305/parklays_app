// import 'package:flutter/material.dart';
// import '../models/parking_lot.dart';
// import '../services/api_service.dart';
// import 'history_page.dart';
// import 'services_page.dart';
// import 'profile_page.dart';
// import 'search_screen.dart'; // ✅ added
// import 'package:url_launcher/url_launcher.dart'; // ✅ for Google Maps redirection
// import 'package:geolocator/geolocator.dart'; // ✅ for location
// import 'dart:math';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final Color darkBlack = const Color(0xFF060606);
//   final Color limeGreen = const Color(0xFFD7EE46);
//   final Color softWhite = const Color(0xFFEFF0EF);
//   final Color pureWhite = const Color(0xFFFFFFFF);

//   int _selectedIndex = 0;

//   List<ParkingLot> _parkingLots = [];
//   bool _isLoadingParkingLots = true;

//   // ✅ user location
//   double? _userLat;
//   double? _userLng;
//   bool _isFetchingLocation = true;

//   void _onTab(int index) {
//     if (index == 0) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         (route) => false,
//       );
//     } else {
//       setState(() => _selectedIndex = index);
//     }
//   }

//   Future<void> _fetchParkingLots() async {
//     try {
//       final lots = await ApiService.fetchParkingLots();
//       setState(() {
//         _parkingLots = lots;
//         _isLoadingParkingLots = false;
//       });
//     } catch (e) {
//       setState(() => _isLoadingParkingLots = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching parking lots: $e")),
//       );
//     }
//   }

//   // ✅ fetch user location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled.')),
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission denied.')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location permissions are permanently denied.')),
//       );
//       return;
//     }

//     final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _userLat = pos.latitude;
//       _userLng = pos.longitude;
//       _isFetchingLocation = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchParkingLots();
//     _getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       _HomeContent(
//         parkingLots: _parkingLots,
//         isLoading: _isLoadingParkingLots,
//         userLat: _userLat,
//         userLng: _userLng,
//         isFetchingLocation: _isFetchingLocation,
//       ),
//       const HistoryPage(),
//       const ServicesPage(),
//       const ProfilePage(),
//     ];

//     return Scaffold(
//       backgroundColor: softWhite,
//       appBar: AppBar(
//         backgroundColor: softWhite,
//         elevation: 0,
//         centerTitle: false,
//         titleSpacing: 16,
//         title: const Text(
//           "Where are you going?",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.menu, color: Colors.black),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(child: _pages[_selectedIndex]),
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 16,
//             child: SafeArea(
//               top: false,
//               child: _FloatingBottomNav(
//                 background: darkBlack,
//                 selected: limeGreen,
//                 unselected: pureWhite,
//                 currentIndex: _selectedIndex,
//                 onTap: _onTab,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* =================== HOME CONTENT =================== */
// class _HomeContent extends StatelessWidget {
//   const _HomeContent({
//     required this.parkingLots,
//     required this.isLoading,
//     required this.userLat,
//     required this.userLng,
//     required this.isFetchingLocation,
//   });

//   final List<ParkingLot> parkingLots;
//   final bool isLoading;
//   final double? userLat;
//   final double? userLng;
//   final bool isFetchingLocation;

//   double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
//     const p = 0.017453292519943295;
//     final a = 0.5 -
//         (cos((lat2 - lat1) * p) / 2) +
//         cos(lat1 * p) * cos(lat2 * p) *
//             (1 - cos((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final softWhite = const Color(0xFFEFF0EF);
//     final pureWhite = Colors.white;

//     void _launchGoogleMaps(ParkingLot lot) async {
//       final query = Uri.encodeComponent(
//           lot.address.isNotEmpty ? lot.address : lot.name);
//       final url = "https://www.google.com/maps/search/?api=1&query=$query";
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Could not open Google Maps")),
//         );
//       }
//     }

//     if (isFetchingLocation) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     List<ParkingLot> sortedLots = List.from(parkingLots);
//     if (userLat != null && userLng != null) {
//       sortedLots.sort((a, b) {
//         double distA = a.latitude != null && a.longitude != null
//             ? _distanceKm(userLat!, userLng!, a.latitude!, a.longitude!)
//             : double.infinity;
//         double distB = b.latitude != null && b.longitude != null
//             ? _distanceKm(userLat!, userLng!, b.latitude!, b.longitude!)
//             : double.infinity;
//         return distA.compareTo(distB);
//       });
//     }

//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (_) => SearchScreen(parkingLots: parkingLots),
//             ));
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: pureWhite,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.search, color: Colors.grey[700]),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     "Search destination",
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: softWhite,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.tune, size: 18, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 20),
//         const Text(
//           "Parking nearby",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
//         ),
//         const SizedBox(height: 12),

//         if (isLoading)
//           const Center(child: CircularProgressIndicator())
//         else if (parkingLots.isEmpty)
//           const Center(child: Text("No parking lots available"))
//         else
//           Column(
//             children: sortedLots.map((lot) {
//               final image = lot.imageUrl.isNotEmpty
//                   ? lot.imageUrl
//                   : 'https://picsum.photos/200';
//               final address =
//                   lot.address.isNotEmpty ? lot.address : 'Unknown location';
//               final freeSlots = lot.freeSlots >= 0 ? lot.freeSlots : 0;

//               double? dist;
//               if (userLat != null && userLng != null && lot.latitude != null && lot.longitude != null) {
//                 dist = _distanceKm(userLat!, userLng!, lot.latitude!, lot.longitude!);
//               }

//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Card(
//                   child: ListTile(
//                     title: Text(lot.name),
//                     subtitle: Text(
//                       address + (dist != null ? "\n${dist.toStringAsFixed(1)} km away" : ""),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("$freeSlots free places"),
//                         IconButton(
//                           icon: const Icon(Icons.directions, color: Colors.blueGrey),
//                           onPressed: () => _launchGoogleMaps(lot),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }

// /* =================== FLOATING NAV =================== */
// class _FloatingBottomNav extends StatelessWidget {
//   const _FloatingBottomNav({
//     required this.background,
//     required this.selected,
//     required this.unselected,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   final Color background;
//   final Color selected;
//   final Color unselected;
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: 64,
//         decoration: BoxDecoration(
//           color: background,
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.20),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _NavItem(icon: Icons.home_filled, index: 0, isSelected: currentIndex == 0, selected: selected, unselected: unselected, onTap: onTap),
//             _NavItem(icon: Icons.history, index: 1, isSelected: currentIndex == 1, selected: selected, unselected: unselected, onTap: onTap),
//             _NavItem(icon: Icons.room_service, index: 2, isSelected: currentIndex == 2, selected: selected, unselected: unselected, onTap: onTap),
//             _NavItem(icon: Icons.person, index: 3, isSelected: currentIndex == 3, selected: selected, unselected: unselected, onTap: onTap),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   const _NavItem({
//     required this.icon,
//     required this.index,
//     required this.isSelected,
//     required this.selected,
//     required this.unselected,
//     required this.onTap,
//   });

//   final IconData icon;
//   final int index;
//   final bool isSelected;
//   final Color selected;
//   final Color unselected;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkResponse(
//       radius: 28,
//       highlightColor: Colors.transparent,
//       splashColor: Colors.white10,
//       onTap: () => onTap(index),
//       child: Icon(
//         icon,
//         size: 26,
//         color: isSelected ? selected : unselected,
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:geolocator/geolocator.dart';
// import '../models/parking_lot.dart';
// import '../services/api_service.dart';
// import 'history_page.dart';
// import 'services_page.dart';
// import 'profile_page.dart';
// import 'search_screen.dart';
// import 'lot_map_view.dart';
// import 'user_preferences.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final Color darkBlack = const Color(0xFF060606);
//   final Color limeGreen = const Color(0xFFD7EE46);
//   final Color softWhite = const Color(0xFFEFF0EF);
//   final Color pureWhite = const Color(0xFFFFFFFF);

//   int _selectedIndex = 0;
//   List<ParkingLot> _parkingLots = [];
//   bool _isLoadingParkingLots = true;

//   double? _userLat;
//   double? _userLng;
//   bool _isFetchingLocation = true;
//   String? _userPhone;


//   @override
//   void initState() {
//     super.initState();
//     _loadUserPhone();
//     _fetchParkingLots();
//     _getCurrentLocation();
//   }

//   void _onTab(int index) {
//     if (index == 0) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         (route) => false,
//       );
//     } else {
//       setState(() => _selectedIndex = index);
//     }
//   }

//   Future<void> _fetchParkingLots() async {
//     try {
//       final lots = await ApiService.fetchParkingLots();
//       setState(() {
//         _parkingLots = lots;
//         _isLoadingParkingLots = false;
//       });
//     } catch (e) {
//       setState(() => _isLoadingParkingLots = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching parking lots: $e")),
//       );
//     }
//   }
//   Future<void> _loadUserPhone() async {
//   final phone = await UserPreferences.getPhoneNumber();
//   setState(() {
//     _userPhone = phone;
//   });
// }


//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled.')),
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission denied.')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location permissions are permanently denied.'),
//         ),
//       );
//       return;
//     }

//     final pos = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     setState(() {
//       _userLat = pos.latitude;
//       _userLng = pos.longitude;
//       _isFetchingLocation = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       _HomeContent(
//         parkingLots: _parkingLots,
//         isLoading: _isLoadingParkingLots,
//         userLat: _userLat,
//         userLng: _userLng,
//         isFetchingLocation: _isFetchingLocation,
//       ),
//       HistoryPage(userPhone: _userPhone ?? ""),
//       const ServicesPage(),
//       ProfilePage(userPhone: _userPhone ?? ""),
//     ];

//     return Scaffold(
//       backgroundColor: softWhite,
//       appBar: AppBar(
//         backgroundColor: softWhite,
//         elevation: 0,
//         centerTitle: false,
//         titleSpacing: 16,
//         title: const Text(
//           "Where are you going?",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.menu, color: Colors.black),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(child: _pages[_selectedIndex]),
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 16,
//             child: SafeArea(
//               top: false,
//               child: _FloatingBottomNav(
//                 background: darkBlack,
//                 selected: limeGreen,
//                 unselected: pureWhite,
//                 currentIndex: _selectedIndex,
//                 onTap: _onTab,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* =================== HOME CONTENT =================== */
// class _HomeContent extends StatelessWidget {
//   const _HomeContent({
//     required this.parkingLots,
//     required this.isLoading,
//     required this.userLat,
//     required this.userLng,
//     required this.isFetchingLocation,
//   });

//   final List<ParkingLot> parkingLots;
//   final bool isLoading;
//   final double? userLat;
//   final double? userLng;
//   final bool isFetchingLocation;

//   double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
//     const p = 0.017453292519943295;
//     final a =
//         0.5 -
//         (cos((lat2 - lat1) * p) / 2) +
//         cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final softWhite = const Color(0xFFEFF0EF);
//     final pureWhite = Colors.white;

//     void _launchGoogleMaps(ParkingLot lot) async {
//       final query = Uri.encodeComponent(
//         lot.address.isNotEmpty ? lot.address : lot.name,
//       );
//       final url = "https://www.google.com/maps/search/?api=1&query=$query";
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//       }
//     }

//     if (isFetchingLocation) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     List<ParkingLot> sortedLots = List.from(parkingLots);
//     if (userLat != null && userLng != null) {
//       sortedLots.sort((a, b) {
//         double distA = a.latitude != null
//             ? _distanceKm(userLat!, userLng!, a.latitude!, a.longitude!)
//             : double.infinity;
//         double distB = b.latitude != null
//             ? _distanceKm(userLat!, userLng!, b.latitude!, b.longitude!)
//             : double.infinity;
//         return distA.compareTo(distB);
//       });
//     }

//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
//       children: [
//         // Search bar
//         InkWell(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => SearchScreen(parkingLots: parkingLots),
//               ),
//             );
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: pureWhite,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.search, color: Colors.grey[700]),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     "Search destination",
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: softWhite,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.tune,
//                     size: 18,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           "Parking nearby",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
//         ),
//         const SizedBox(height: 12),

//         if (isLoading)
//           const Center(child: CircularProgressIndicator())
//         else if (parkingLots.isEmpty)
//           const Center(child: Text("No parking lots available"))
//         else
//           Column(
//             children: sortedLots.map((lot) {
//               double? dist;
//               if (userLat != null && userLng != null && lot.latitude != null) {
//                 dist = _distanceKm(
//                   userLat!,
//                   userLng!,
//                   lot.latitude!,
//                   lot.longitude!,
//                 );
//               }

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => LotMapView(
//                         lotId: lot.id,
//                         latitude: lot.latitude ?? 0.0,
//                         longitude: lot.longitude ?? 0.0,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: pureWhite,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         lot.name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         lot.address,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_on,
//                                 size: 18,
//                                 color: Colors.red,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 dist != null
//                                     ? "${dist.toStringAsFixed(1)} km"
//                                     : "— km",
//                               ),
//                             ],
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.directions,
//                               color: Colors.blueAccent,
//                             ),
//                             onPressed: () => _launchGoogleMaps(lot),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }

// /* =================== FLOATING NAV =================== */
// class _FloatingBottomNav extends StatelessWidget {
//   const _FloatingBottomNav({
//     required this.background,
//     required this.selected,
//     required this.unselected,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   final Color background;
//   final Color selected;
//   final Color unselected;
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: 64,
//         decoration: BoxDecoration(
//           color: background,
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.20),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _NavItem(
//               icon: Icons.home_filled,
//               index: 0,
//               isSelected: currentIndex == 0,
//               selected: selected,
//               unselected: unselected,
//               onTap: onTap,
//             ),
//             _NavItem(
//               icon: Icons.history,
//               index: 1,
//               isSelected: currentIndex == 1,
//               selected: selected,
//               unselected: unselected,
//               onTap: onTap,
//             ),
//             _NavItem(
//               icon: Icons.room_service,
//               index: 2,
//               isSelected: currentIndex == 2,
//               selected: selected,
//               unselected: unselected,
//               onTap: onTap,
//             ),
//             _NavItem(
//               icon: Icons.person,
//               index: 3,
//               isSelected: currentIndex == 3,
//               selected: selected,
//               unselected: unselected,
//               onTap: onTap,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   const _NavItem({
//     required this.icon,
//     required this.index,
//     required this.isSelected,
//     required this.selected,
//     required this.unselected,
//     required this.onTap,
//   });

//   final IconData icon;
//   final int index;
//   final bool isSelected;
//   final Color selected;
//   final Color unselected;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkResponse(
//       radius: 28,
//       highlightColor: Colors.transparent,
//       splashColor: Colors.white10,
//       onTap: () => onTap(index),
//       child: Icon(icon, size: 26, color: isSelected ? selected : unselected),
//     );
//   }
// }





import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../models/parking_lot.dart';
import '../services/api_service.dart';
import 'history_page.dart';
import 'services_page.dart';
import 'profile_page.dart';
import 'search_screen.dart';
import 'lot_map_view.dart';
import 'user_preferences.dart'; // <<-- import for saved phone

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  int _selectedIndex = 0;
  List<ParkingLot> _parkingLots = [];
  bool _isLoadingParkingLots = true;

  double? _userLat;
  double? _userLng;
  bool _isFetchingLocation = true;

  // ---- Phone loaded from UserPreferences (cleaned, without +91) ----
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _loadUserPhone();        // load saved phone first
    _fetchParkingLots();
    _getCurrentLocation();
  }

  Future<void> _loadUserPhone() async {
    final phone = await UserPreferences.getPhoneNumber();
    setState(() {
      _userPhone = phone;
    });
  }

  void _onTab(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _fetchParkingLots() async {
    try {
      final lots = await ApiService.fetchParkingLots();
      setState(() {
        _parkingLots = lots;
        _isLoadingParkingLots = false;
      });
    } catch (e) {
      setState(() => _isLoadingParkingLots = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching parking lots: $e")),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      setState(() => _isFetchingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        setState(() => _isFetchingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      setState(() => _isFetchingLocation = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLat = pos.latitude;
      _userLng = pos.longitude;
      _isFetchingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _HomeContent(
        parkingLots: _parkingLots,
        isLoading: _isLoadingParkingLots,
        userLat: _userLat,
        userLng: _userLng,
        isFetchingLocation: _isFetchingLocation,
      ),

      // Pass the loaded phone to HistoryPage. If phone is not loaded yet, pass empty string —
      // HistoryPage will handle empty string (it will return no results or show an appropriate message).
      HistoryPage(userPhone: _userPhone ?? ""),

      const ServicesPage(),

      // ProfilePage reads from UserPreferences internally (so no param required).
      // If you prefer to pass phone to ProfilePage, change ProfilePage constructor accordingly.
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: softWhite,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          "Where are you going?",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_selectedIndex]),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: _FloatingBottomNav(
                background: darkBlack,
                selected: limeGreen,
                unselected: pureWhite,
                currentIndex: _selectedIndex,
                onTap: _onTab,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =================== HOME CONTENT =================== */
class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.parkingLots,
    required this.isLoading,
    required this.userLat,
    required this.userLng,
    required this.isFetchingLocation,
  });

  final List<ParkingLot> parkingLots;
  final bool isLoading;
  final double? userLat;
  final double? userLng;
  final bool isFetchingLocation;

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        (cos((lat2 - lat1) * p) / 2) +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final softWhite = const Color(0xFFEFF0EF);
    final pureWhite = Colors.white;

    void _launchGoogleMaps(ParkingLot lot) async {
      final query = Uri.encodeComponent(
        lot.address.isNotEmpty ? lot.address : lot.name,
      );
      final url = "https://www.google.com/maps/search/?api=1&query=$query";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }

    if (isFetchingLocation) {
      return const Center(child: CircularProgressIndicator());
    }

    List<ParkingLot> sortedLots = List.from(parkingLots);
    if (userLat != null && userLng != null) {
      sortedLots.sort((a, b) {
        double distA = a.latitude != null ? _distanceKm(userLat!, userLng!, a.latitude!, a.longitude!) : double.infinity;
        double distB = b.latitude != null ? _distanceKm(userLat!, userLng!, b.latitude!, b.longitude!) : double.infinity;
        return distA.compareTo(distB);
      });
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        // Search bar
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SearchScreen(parkingLots: parkingLots),
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[700]),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Search destination",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: softWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, size: 18, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Parking nearby",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),

        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (parkingLots.isEmpty)
          const Center(child: Text("No parking lots available"))
        else
          Column(
            children: sortedLots.map((lot) {
              double? dist;
              if (userLat != null && userLng != null && lot.latitude != null) {
                dist = _distanceKm(userLat!, userLng!, lot.latitude!, lot.longitude!);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LotMapView(
                        lotId: lot.id,
                        latitude: lot.latitude ?? 0.0,
                        longitude: lot.longitude ?? 0.0,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lot.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lot.address,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(dist != null ? "${dist.toStringAsFixed(1)} km" : "— km"),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.directions, color: Colors.blueAccent),
                            onPressed: () => _launchGoogleMaps(lot),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

/* =================== FLOATING NAV =================== */
class _FloatingBottomNav extends StatelessWidget {
  const _FloatingBottomNav({
    required this.background,
    required this.selected,
    required this.unselected,
    required this.currentIndex,
    required this.onTap,
  });

  final Color background;
  final Color selected;
  final Color unselected;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_filled, index: 0, isSelected: currentIndex == 0, selected: selected, unselected: unselected, onTap: onTap),
            _NavItem(icon: Icons.history, index: 1, isSelected: currentIndex == 1, selected: selected, unselected: unselected, onTap: onTap),
            _NavItem(icon: Icons.room_service, index: 2, isSelected: currentIndex == 2, selected: selected, unselected: unselected, onTap: onTap),
            _NavItem(icon: Icons.person, index: 3, isSelected: currentIndex == 3, selected: selected, unselected: unselected, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.selected,
    required this.unselected,
    required this.onTap,
  });

  final IconData icon;
  final int index;
  final bool isSelected;
  final Color selected;
  final Color unselected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 28,
      highlightColor: Colors.transparent,
      splashColor: Colors.white10,
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 26,
        color: isSelected ? selected : unselected,
      ),
    );
  }
}
