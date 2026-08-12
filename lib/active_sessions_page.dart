// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class ActiveSessionsListPage extends StatefulWidget {
//   final int lotId;

//   const ActiveSessionsListPage({super.key, required this.lotId});

//   @override
//   State<ActiveSessionsListPage> createState() => _ActiveSessionsListPageState();
// }

// class _ActiveSessionsListPageState extends State<ActiveSessionsListPage> {
//   bool isLoading = true;
//   List<Map<String, dynamic>> activeSessions = [];

//   static const String baseUrl = "http://172.18.223.127:5155/api";

//   @override
//   void initState() {
//     super.initState();
//     _fetchActiveSessions();
//   }

//   Future<void> _fetchActiveSessions() async {
//     setState(() => isLoading = true);

//     try {
//       final url = Uri.parse(
//           "$baseUrl/ParkingSessions/status/active/byLot?lotId=${widget.lotId}");

//       final resp = await http.get(url);

//       if (resp.statusCode == 200) {
//         final data = jsonDecode(resp.body);
//         if (data is List) {
//           setState(() => activeSessions = List<Map<String, dynamic>>.from(data));
//         }
//       } else {
//         throw Exception("Failed to load active sessions");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   String formatDateTime(String? isoTime) {
//     if (isoTime == null || isoTime.isEmpty) return "N/A";
//     try {
//       final dt = DateTime.parse(isoTime).toLocal();
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//     } catch (e) {
//       return isoTime;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Active Sessions")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : activeSessions.isEmpty
//               ? const Center(child: Text("No active sessions."))
//               : ListView.builder(
//                   itemCount: activeSessions.length,
//                   itemBuilder: (context, index) {
//                     final s = activeSessions[index];
//                     return Card(
//                       margin:
//                           const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       child: ListTile(
//                         title: Text(s['userName'] ?? "Unknown User"),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 "Vehicle: ${s['vehicleModel'] ?? 'N/A'} (${s['vehicleColor'] ?? 'N/A'})"),
//                             Text("Number: ${s['vehicleNumber'] ?? 'N/A'}"),
//                             Text("Entry: ${formatDateTime(s['entryTime'])}"),
//                           ],
//                         ),
//                         trailing: Text("Slot ${s['slotNumber']}"),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }







import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ActiveSessionsListPage extends StatefulWidget {
  final int lotId;

  const ActiveSessionsListPage({super.key, required this.lotId});

  @override
  State<ActiveSessionsListPage> createState() => _ActiveSessionsListPageState();
}

class _ActiveSessionsListPageState extends State<ActiveSessionsListPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> activeSessions = [];

  // Colors
  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  static const String baseUrl = "http://10.193.188.44:5155/api";

  @override
  void initState() {
    super.initState();
    _fetchActiveSessions();
  }

  Future<void> _fetchActiveSessions() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
          "$baseUrl/ParkingSessions/status/active/byLot?lotId=${widget.lotId}");

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          setState(() => activeSessions = List<Map<String, dynamic>>.from(data));
        }
      } else {
        throw Exception("Failed to load active sessions");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatDateTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return isoTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        backgroundColor: pureWhite,
        elevation: 1,
        title: const Text(
          "Active Sessions",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : activeSessions.isEmpty
              ? Center(
                  child: Text(
                    "No active sessions.",
                    style: TextStyle(color: darkBlack, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  itemCount: activeSessions.length,
                  itemBuilder: (context, index) {
                    final session = activeSessions[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: darkBlack.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: softWhite, width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        title: Text(
                          session['userName'] ?? "Unknown User",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: darkBlack),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.directions_car, size: 16, color: limeGreen),
                                const SizedBox(width: 6),
                                Text(
                                  "${session['vehicleModel'] ?? 'N/A'} (${session['vehicleColor'] ?? 'N/A'})",
                                  style: TextStyle(color: darkBlack.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.confirmation_number, size: 16, color: limeGreen),
                                const SizedBox(width: 6),
                                Text(
                                  "Number: ${session['vehicleNumber'] ?? 'N/A'}",
                                  style: TextStyle(color: darkBlack.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.login, size: 16, color: limeGreen),
                                const SizedBox(width: 6),
                                Text(
                                  "Entry: ${formatDateTime(session['entryTime'])}",
                                  style: TextStyle(color: darkBlack.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: limeGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Slot ${session['slotNumber'] ?? 'N/A'}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: darkBlack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
