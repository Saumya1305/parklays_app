// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:csv/csv.dart';

// class ParkingReportsPage extends StatefulWidget {
//   final int lotId;

//   const ParkingReportsPage({super.key, required this.lotId});

//   @override
//   State<ParkingReportsPage> createState() => _ParkingReportsPageState();
// }

// class _ParkingReportsPageState extends State<ParkingReportsPage> {
//   final Color darkBlack = const Color(0xFF060606);
//   final Color limeGreen = const Color(0xFFD7EE46);
//   final Color softWhite = const Color(0xFFEFF0EF);
//   final Color pureWhite = const Color(0xFFFFFFFF);

//   bool isLoading = true;
//   List<Map<String, dynamic>> sessions = [];
//   List<Map<String, dynamic>> filteredSessions = [];
//   String filterStatus = "all"; // all, active, completed

//   static const String baseUrl = "http://192.168.1.15:5155/api";

//   @override
//   void initState() {
//     super.initState();
//     _fetchSessions();
//   }

//   // ------------------- Fetch sessions from API -------------------
//   Future<void> _fetchSessions() async {
//     setState(() => isLoading = true);

//     try {
//       final url =
//           Uri.parse("$baseUrl/parkingsessions/byLot?lotId=${widget.lotId}");
//       final resp = await http.get(url);

//       if (resp.statusCode == 200) {
//         final data = jsonDecode(resp.body);
//         if (data is List) {
//           sessions = List<Map<String, dynamic>>.from(data);
//           _applyFilter();
//         }
//       } else {
//         throw Exception("Failed to load sessions");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   // ------------------- Apply status filter -------------------
//   void _applyFilter() {
//     if (filterStatus == "all") {
//       filteredSessions = sessions;
//     } else {
//       filteredSessions =
//           sessions.where((s) => s['status'] == filterStatus).toList();
//     }
//     setState(() {});
//   }

//   // ------------------- Format date -------------------
//   String formatDateTime(String? isoTime) {
//     if (isoTime == null || isoTime.isEmpty) return "N/A";
//     try {
//       final dt = DateTime.parse(isoTime).toLocal();
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//     } catch (e) {
//       return isoTime;
//     }
//   }

//   // ------------------- Export CSV -------------------
//   Future<void> _exportCSV() async {
//     List<List<String>> csvData = [
//       ["User Name", "Vehicle", "Vehicle Number", "Slot", "Entry", "Exit", "Status"],
//       ...filteredSessions.map((s) => [
//             s['user_name'] ?? '',
//             s['vehicle_model'] ?? '',
//             s['vehicle_number'] ?? '',
//             s['slotnumber'].toString(),
//             s['entry_time'] ?? '',
//             s['exit_time'] ?? '',
//             s['status'] ?? ''
//           ])
//     ];

//     String csv = const ListToCsvConverter().convert(csvData);
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/parking_sessions.csv');
//     await file.writeAsString(csv);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("CSV exported: ${file.path}")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: softWhite,
//         elevation: 0,
//         title: const Text(
//           "Export / Reports",
//           style: TextStyle(color: Colors.black87),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download_rounded, color: darkBlack),
//             onPressed: _exportCSV,
//           ),
//         ],
//       ),
//       backgroundColor: softWhite,
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // ------------------- Filter Row -------------------
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       _FilterButton(
//                         text: "All",
//                         isSelected: filterStatus == "all",
//                         color: limeGreen,
//                         onTap: () {
//                           filterStatus = "all";
//                           _applyFilter();
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       _FilterButton(
//                         text: "Active",
//                         isSelected: filterStatus == "active",
//                         color: limeGreen,
//                         onTap: () {
//                           filterStatus = "active";
//                           _applyFilter();
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       _FilterButton(
//                         text: "Completed",
//                         isSelected: filterStatus == "completed",
//                         color: limeGreen,
//                         onTap: () {
//                           filterStatus = "completed";
//                           _applyFilter();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ------------------- Session List -------------------
//                 Expanded(
//                   child: filteredSessions.isEmpty
//                       ? const Center(
//                           child: Text("No sessions found."),
//                         )
//                       : ListView.builder(
//                           itemCount: filteredSessions.length,
//                           itemBuilder: (context, index) {
//                             final s = filteredSessions[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               color: pureWhite,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                               child: ListTile(
//                                 title: Text(s['user_name'] ?? 'Unknown'),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Vehicle: ${s['vehicle_model'] ?? 'N/A'} (${s['vehicle_color'] ?? 'N/A'})",
//                                     ),
//                                     Text("Number: ${s['vehicle_number'] ?? 'N/A'}"),
//                                     Text(
//                                         "Entry: ${formatDateTime(s['entry_time'])}"),
//                                     Text(
//                                         "Exit: ${formatDateTime(s['exit_time'])}"),
//                                     Text(
//                                       "Status: ${s['status'] ?? 'N/A'}",
//                                       style: TextStyle(
//                                         color: s['status'] == 'active'
//                                             ? Colors.orange
//                                             : Colors.green,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: limeGreen.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     "Slot ${s['slotnumber']}",
//                                     style: TextStyle(
//                                       color: darkBlack,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // ------------------- Filter Button -------------------
// class _FilterButton extends StatelessWidget {
//   final String text;
//   final bool isSelected;
//   final Color color;
//   final VoidCallback onTap;

//   const _FilterButton({
//     required this.text,
//     required this.isSelected,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? color : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.black : color,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';


class ParkingReportsPage extends StatefulWidget {
  final int lotId;

  const ParkingReportsPage({super.key, required this.lotId});

  @override
  State<ParkingReportsPage> createState() => _ParkingReportsPageState();
}

class _ParkingReportsPageState extends State<ParkingReportsPage> {
  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  bool isLoading = true;
  List<Map<String, dynamic>> sessions = [];
  List<Map<String, dynamic>> filteredSessions = [];
  String filterStatus = "all"; // all, active, completed

  static const String baseUrl = "http://10.193.188.44:5155/api";

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  // ------------------- Fetch sessions -------------------
  Future<void> _fetchSessions() async {
    setState(() => isLoading = true);

    try {
      final url =
          Uri.parse("$baseUrl/parkingsessions/byLot?lotId=${widget.lotId}");
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          sessions = List<Map<String, dynamic>>.from(data);
          _applyFilter();
        }
      } else {
        throw Exception("Failed to load sessions");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ------------------- Apply filter -------------------
  void _applyFilter() {
    if (filterStatus == "all") {
      filteredSessions = sessions;
    } else {
      filteredSessions =
          sessions.where((s) => s['status'] == filterStatus).toList();
    }
    setState(() {});
  }

  // ------------------- Format Time -------------------
  String formatDateTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return isoTime;
    }
  }

  // ------------------- Export CSV -------------------
  Future<void> _exportCSV() async {
  try {
    // ---- Create CSV data ----
    List<List<String>> csvData = [
      ["User Name", "Vehicle", "Vehicle Number", "Slot", "Entry", "Exit", "Status"],
      ...filteredSessions.map((s) => [
            s['userName'] ?? '',
            s['vehicleModel'] ?? '',
            s['vehicleNumber'] ?? '',
            s['slotNumber']?.toString() ?? '',
            s['entryTime'] ?? '',
            s['exitTime'] ?? '',
            s['status'] ?? '',
          ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    // ---- Best Practice: app-specific external directory (no permission needed) ----
    final Directory? directory = await getExternalStorageDirectory();

    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to access storage")),
      );
      return;
    }

    final String filePath = '${directory.path}/parking_sessions.csv';
    final File file = File(filePath);

    await file.writeAsString(csv);

    // ---- Share CSV using share_plus ----
    await Share.shareXFiles([XFile(filePath)],
        text: "Parking sessions CSV exported from Parklays.");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("CSV exported successfully.")),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Export failed: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: softWhite,
        elevation: 0,
        title: const Text(
          "Export / Reports",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: darkBlack),
            onPressed: _exportCSV,
          ),
        ],
      ),
      backgroundColor: softWhite,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Row
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      _FilterButton(
                        text: "All",
                        isSelected: filterStatus == "all",
                        color: limeGreen,
                        onTap: () {
                          filterStatus = "all";
                          _applyFilter();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterButton(
                        text: "Active",
                        isSelected: filterStatus == "active",
                        color: limeGreen,
                        onTap: () {
                          filterStatus = "active";
                          _applyFilter();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterButton(
                        text: "Completed",
                        isSelected: filterStatus == "completed",
                        color: limeGreen,
                        onTap: () {
                          filterStatus = "completed";
                          _applyFilter();
                        },
                      ),
                    ],
                  ),
                ),

                // Sessions List
                Expanded(
                  child: filteredSessions.isEmpty
                      ? const Center(
                          child: Text("No sessions found."),
                        )
                      : ListView.builder(
                          itemCount: filteredSessions.length,
                          itemBuilder: (context, index) {
                            final s = filteredSessions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              color: pureWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                title: Text(s['userName'] ?? 'Unknown'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Vehicle: ${s['vehicleModel'] ?? 'N/A'} (${s['vehicleColor'] ?? 'N/A'})",
                                    ),
                                    Text("Number: ${s['vehicleNumber'] ?? 'N/A'}"),
                                    Text("Entry: ${formatDateTime(s['entryTime'])}"),
                                    Text("Exit: ${formatDateTime(s['exitTime'])}"),
                                    Text(
                                      "Status: ${s['status'] ?? 'N/A'}",
                                      style: TextStyle(
                                        color: s['status'] == 'active'
                                            ? Colors.orange
                                            : Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: limeGreen.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Slot ${s['slotNumber']}",
                                    style: TextStyle(
                                      color: darkBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ------------------- Filter Button Widget -------------------
class _FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterButton({
    required this.text,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
