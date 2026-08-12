import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SlotFeature {
  final List<LatLng> points;
  final int slotNumber;
  final bool isFree;

  SlotFeature({
    required this.points,
    required this.slotNumber,
    required this.isFree,
  });
}

class LotMapView extends StatefulWidget {
  final int lotId;
  final double latitude;
  final double longitude;

  const LotMapView({
    super.key,
    required this.lotId,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LotMapView> createState() => _LotMapViewState();
}

class _LotMapViewState extends State<LotMapView> {
  final MapController _mapController = MapController();
  bool isLoading = true;
  Timer? _refreshTimer;
  List<SlotFeature> _features = [];

  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    fetchGeoJsonData();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) async => await fetchGeoJsonData(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchGeoJsonData() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.193.188.44:5155/api/parkinglots/${widget.lotId}/slots"),
      );

      if (response.statusCode != 200) throw Exception("Failed to load slots");

      final List<dynamic> data = json.decode(response.body);
      final List<SlotFeature> parsed = [];

      for (final slot in data) {
        final slotNumber = slot['slotNumber'] ?? slot['slotnumber'] ?? 0;
        final isFree = (slot['isFree'] ?? slot['IsFree'] ?? false) == true;

        final geoField = slot['geoJson'] ?? slot['geojson'] ?? slot['geom'];
        if (geoField == null) continue;

        Map<String, dynamic> geometry;
        if (geoField is String) {
          geometry = jsonDecode(geoField);
        } else {
          geometry = geoField;
        }

        if (geometry['coordinates'] == null) continue;
        final coords = geometry['coordinates'][0];
        final List<LatLng> points = [];

        for (final p in coords) {
          final lon = _toDoubleNullable(p[0]);
          final lat = _toDoubleNullable(p[1]);
          if (lon != null && lat != null) points.add(LatLng(lat, lon));
        }

        if (points.isEmpty) continue;

        parsed.add(SlotFeature(
          points: points,
          slotNumber: int.tryParse(slotNumber.toString()) ?? 0,
          isFree: isFree,
        ));
      }

      setState(() {
        _features = parsed;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading GeoJSON: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load parking slots: $e")),
        );
      }
    }
  }

  static double? _toDoubleNullable(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  LatLng _getPolygonCenter(List<LatLng> points) {
    double lat = 0, lng = 0;
    for (final p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  Future<void> _launchGoogleMaps() async {
    final lat = widget.latitude;
    final lng = widget.longitude;
    final Uri uri =
        Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: softWhite,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          "Parking Lot Map",
          style: TextStyle(
            color: darkBlack,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.navigation_outlined, color: darkBlack),
            onPressed: _launchGoogleMaps,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _features.isEmpty
              ? const Center(child: Text("No slot geometries found."))
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _features.isNotEmpty
                        ? _getPolygonCenter(_features[0].points)
                        : LatLng(widget.latitude, widget.longitude),
                    initialZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    PolygonLayer(
                      polygons: _features.map((f) {
                        return Polygon(
                          points: f.points,
                          color: f.isFree
                              ? limeGreen.withOpacity(0.35)
                              : Colors.red.withOpacity(0.35),
                          borderColor: Colors.black,
                          borderStrokeWidth: 1,
                        );
                      }).toList(),
                    ),
                    MarkerLayer(
                      markers: _features.map((f) {
                        final center = _getPolygonCenter(f.points);
                        return Marker(
                          point: center,
                          width: 40,
                          height: 40,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pureWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: f.isFree ? Colors.green : Colors.red,
                                  width: 1),
                            ),
                            child: Text(
                              f.slotNumber.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkBlack),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
    );
  }
}
