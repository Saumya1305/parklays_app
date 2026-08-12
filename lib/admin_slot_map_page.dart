import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'qr_scan_page.dart';
import 'package:intl/intl.dart';
import 'parking_history_page.dart';
//import 'active_session_page.dart';

class SlotFeature {
  final List<LatLng> points;
  final int slotId;
  final int slotNumber;
  bool isFree;
  final bool isBike;

  SlotFeature({
    required this.points,
    required this.slotId,
    required this.slotNumber,
    required this.isFree,
    required this.isBike,
  });
}

class AdminSlotMapPage extends StatefulWidget {
  final int adminId;
  final int lotId;
  final Map<String, dynamic>? scannedUser;

  const AdminSlotMapPage({
    super.key,
    required this.adminId,
    required this.lotId,
    this.scannedUser,
  });

  @override
  State<AdminSlotMapPage> createState() => _AdminSlotMapPageState();
}

class _AdminSlotMapPageState extends State<AdminSlotMapPage> {
  final MapController _mapController = MapController();
  bool isLoading = true;
  bool isSaving = false;
  List<SlotFeature> _features = [];

  LatLng _center = LatLng(26.9124, 75.7873);
  double _initialZoom = 18;

  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  static const String baseUrl = "http://10.193.188.44:5155/api";

  // ----------------- MOVED scannedUser TO STATE -----------------
  Map<String, dynamic>? scannedUser;

  @override
  void initState() {
    super.initState();
    scannedUser = widget.scannedUser; 
    _loadSlots();
  }

  // ------------------ HELPER FUNCTION ------------------
  String formatDateTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(isoTime).toLocal(); // convert UTC → local
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return isoTime; // fallback
    }
  }

  //----------------Fetch live parking session details-----------------//
  Future<Map<String, dynamic>?> fetchActiveSession(int slotId) async {
    final url = Uri.parse("$baseUrl/parkingsessions/active?slotId=$slotId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) return null;
      return data;
    } else {
      print("❌ Failed to fetch active session: ${response.body}");
      return null;
    }
  }

  // ------------------- START PARKING SESSION -------------------//
  Future<void> startParkingSession(SlotFeature slot) async {
    if (scannedUser == null) {
      print("❌ No scanned user found");
      return;
    }

    final url = Uri.parse("$baseUrl/parkingsessions/start");

    final body = {
      "lotId": widget.lotId,
      "slotId": slot.slotId,
      "slotNumber": slot.slotNumber, // ✅ send actual slot number
      "scannedBy": widget.adminId,
      "userName": scannedUser!["name"] ?? "",
      "vehicleType": scannedUser!["vehicle_type"] ?? "",
      "vehicleNumber": scannedUser!["vehicle_number"] ?? "",
      "email": scannedUser!["email"] ?? "",
      "phone": scannedUser!["phone"] ?? "",
      "vehicleColor": scannedUser!["vehicle_color"] ?? "",
      "vehicleModel": scannedUser!["vehicle_model"] ?? "",
    };

    print("📤 Sending session body: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Parking session started successfully");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Parking session created")));
    } else {
      print("❌ Error: ${response.body}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
    }
  }

  // ------------------- END PARKING SESSION -------------------
  Future<void> endParkingSession(int slotId) async {
    final url = Uri.parse("$baseUrl/parkingsessions/end");

    final body = {"slotId": slotId};

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("🟢 Session ended for slot $slotId");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Parking session ended")));
    } else {
      print("❌ Error ending session: ${response.body}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
    }
  }

  Future<void> _loadSlots() async {
    setState(() => isLoading = true);

    try {
      await _fetchSlots(widget.adminId);

      if (_features.isNotEmpty) {
        _center = _getPolygonCenter(_features.first.points);
      }
    } catch (e) {
      debugPrint("Error loading slots: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load map: $e")));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchSlots(int adminId) async {
    final url = Uri.parse("$baseUrl/admin/$adminId/slots");
    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Failed to load slots: ${resp.statusCode}");
    }

    final List<dynamic> data = json.decode(resp.body);
    final List<SlotFeature> parsed = [];

    for (final slot in data) {
      final id = slot['id'] ?? 0;
      final slotNum = slot['slotNumber'] ?? slot['slotnumber'] ?? 0;
      final isFree = (slot['isFree'] ?? false) == true;
      final isBike = (slot['isBike'] ?? false) == true;

      final geoField = slot['GeoJson'] ?? slot['geoJson'] ?? slot['geom'];
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
        final lng = _toDoubleNullable(p[0]);
        final lat = _toDoubleNullable(p[1]);
        if (lat != null && lng != null) {
          points.add(LatLng(lat, lng));
        }
      }

      if (points.isEmpty) continue;

      parsed.add(
        SlotFeature(
          points: points,
          slotId: int.tryParse(id.toString()) ?? 0,
          slotNumber: int.tryParse(slotNum.toString()) ?? 0,
          isFree: isFree,
          isBike: isBike,
        ),
      );
    }

    setState(() => _features = parsed);
  }

  static double? _toDoubleNullable(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  LatLng _getPolygonCenter(List<LatLng> pts) {
    double lat = 0, lng = 0;
    for (var p in pts) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / pts.length, lng / pts.length);
  }

  Future<void> _launchGoogleMaps() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${_center.latitude},${_center.longitude}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  Future<void> _updateSlotStatus(int slotId, bool isFree) async {
    setState(() => isSaving = true);

    try {
      final url = Uri.parse("$baseUrl/admin/slot-status/$slotId");

      final resp = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"isFree": isFree}),
      );

      if (resp.statusCode != 200 && resp.statusCode != 204) {
        throw Exception("Failed: ${resp.statusCode}");
      }

      final idx = _features.indexWhere((f) => f.slotId == slotId);
      if (idx >= 0) {
        setState(() => _features[idx].isFree = isFree);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Slot updated")));
    } catch (e) {
      debugPrint("Update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  // ----------------- SLOT BOTTOM SHEET -----------------
  void _openSlotSheet(BuildContext ctx, SlotFeature f) async {
    Map<String, dynamic>? activeSession;

    if (!f.isFree) {
      // Slot is occupied → fetch active session
      activeSession = await fetchActiveSession(f.slotId);
    }

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Slot ${f.slotNumber}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              /// STATUS
              Text(
                f.isFree ? "Status: Free" : "Status: Occupied",
                style: TextStyle(
                  fontSize: 16,
                  color: f.isFree ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------------------
              /// OCCUPIED SLOT → SHOW DETAILS
              /// ---------------------------
              if (!f.isFree)
                activeSession == null
                    ? const Text("No session details found")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("👤 User: ${activeSession['userName']}"),
                          //Text("🔢 Number: ${activeSession['vehicleNumber']}"),
                          Text("📞 Phone: ${activeSession['phone']}"),
                          Text("📧 Email: ${activeSession['email']}"),
                          Text(
                            "⏰ Start Time: ${formatDateTime(activeSession['entryTime'])}",
                          ),
                          const SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              endParkingSession(f.slotId);
                              _updateSlotStatus(f.slotId, true);
                            },
                            child: const Text("Mark Free (End Session)"),
                          ),
                        ],
                      ),

              /// -----------------------------------------
              /// FREE SLOT → NORMAL OCCUPY FLOW
              /// -----------------------------------------
              if (f.isFree)
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);

                    final scanned = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScanQRPage(
                          adminId: widget.adminId,
                          lotId: widget.lotId,
                        ),
                      ),
                    );

                    if (scanned != null) {
                      this.scannedUser = scanned;
                      await startParkingSession(
                        f,
                      ); // ✅ pass SlotFeature, not just slotId
                      await _updateSlotStatus(f.slotId, false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("Mark Occupied"),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: softWhite,
        elevation: 0,
        title: const Text("Admin — Parking Lot Map"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: _launchGoogleMaps,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ParkingHistoryPage(
                    lotId: widget.lotId,
                    adminId: widget.adminId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _features.isEmpty
          ? const Center(child: Text("No slot geometries found."))
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: _initialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolygonLayer(
                  polygons: _features
                      .map(
                        (f) => Polygon(
                          points: f.points,
                          color: f.isFree
                              ? limeGreen.withOpacity(0.35)
                              : Colors.red.withOpacity(0.35),
                          borderColor: Colors.black,
                          borderStrokeWidth: 1,
                        ),
                      )
                      .toList(),
                ),
                MarkerLayer(
                  markers: _features.map((f) {
                    final c = _getPolygonCenter(f.points);
                    return Marker(
                      point: c,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _openSlotSheet(context, f),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: pureWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: f.isFree ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            f.slotNumber.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkBlack,
                            ),
                          ),
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
