import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ParkingMap extends StatelessWidget {
  final double userLat;
  final double userLng;
  final List<Map<String, dynamic>> nearbyParkings;

  const ParkingMap({
    Key? key,
    required this.userLat,
    required this.userLng,
    required this.nearbyParkings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Parking Map"),
        backgroundColor: Colors.green[400],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(userLat, userLng), // <-- updated
          initialZoom: 15.0,                       // <-- updated
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.parklays',
          ),
          MarkerLayer(
            markers: [
              // User location marker
              Marker(
                width: 40,
                height: 40,
                point: LatLng(userLat, userLng),
                child: const Icon(          // <-- use 'child' instead of 'builder'
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              // Nearby parking markers
              for (var p in nearbyParkings)
                Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(p['lat'], p['lng']),
                  child: const Icon(        // <-- use 'child'
                    Icons.local_parking,
                    color: Colors.green,
                    size: 36,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
