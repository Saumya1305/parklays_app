// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/parking_session.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<ParkingSession> _sessions = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSessions();
//   }

//   Future<void> _fetchSessions() async {
//     try {
//       final sessions = await ApiService.fetchParkingSessions();
//       setState(() {
//         _sessions = sessions;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching sessions: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_sessions.isEmpty) {
//       return const Center(child: Text("No parking history"));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
//       itemCount: _sessions.length,
//       itemBuilder: (_, i) {
//         final s = _sessions[i];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           child: ListTile(
//             leading: const Icon(Icons.local_parking),
//             title: Text("Lot ID: ${s.parkingLotId}"),
//             subtitle: Text(
//               "Start: ${s.startTime}\nEnd: ${s.endTime ?? "Ongoing"}",
//             ),
//           ),
//         );
//       },
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';
// import '../models/parking_session.dart';
// import '../models/parking_lot.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<ParkingSession> _sessions = [];
//   List<ParkingLot> _lots = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       // Fetch sessions and parking lots in parallel
//       final sessions = await ApiService.fetchParkingSessions();
//       final lots = await ApiService.fetchParkingLots();

//       setState(() {
//         _sessions = sessions;
//         _lots = lots;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching data: $e")),
//       );
//     }
//   }

//   String _getLotName(int lotId) {
//     final lot = _lots.firstWhere(
//       (l) => l.id == lotId,
//       orElse: () => ParkingLot(id: lotId, name: "Unknown Lot", location: "Unknown location", capacity: 0, address: "", freeSlots: 0, imageUrl: ""),
//     );
//     return lot.name;
//   }

//   String _formatDate(DateTime date) {
//     return DateFormat('dd MMM yyyy, hh:mm a').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_sessions.isEmpty) {
//       return const Center(child: Text("No parking history"));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
//       itemCount: _sessions.length,
//       itemBuilder: (_, i) {
//         final s = _sessions[i];
//         final start = _formatDate(s.startTime);
//         final end = s.endTime != null ? _formatDate(s.endTime!) : "Ongoing";
//         final lotName = _getLotName(s.lotId);

//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           child: ListTile(
//             leading: const Icon(Icons.local_parking),
//             title: Text(lotName),
//             subtitle: Text("Start: $start\nEnd: $end"),
//           ),
//         );
//       },
//     );
//   }
// }






import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/parking_session.dart';
import '../services/api_service.dart';

class HistoryPage extends StatefulWidget {
  final String userPhone;

  const HistoryPage({
    Key? key,
    required this.userPhone,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}
String normalizePhone(String phone) {
  if (phone.startsWith("+91")) {
    return phone.substring(3);
  }
  return phone;
}

class _HistoryPageState extends State<HistoryPage> {
  bool _loading = true;
  List<ParkingSession> _sessions = [];

  late String userPhone;

  final String baseUrl = "http://10.193.188.44:5155/api";

  @override
  void initState() {
    super.initState();
    userPhone = normalizePhone(widget.userPhone);
    _fetchHistory();
  }

  // DIRECT API CALL (No ApiService usage)
  Future<void> _fetchHistory() async {
  try {
    final sessions = await ApiService.fetchHistory(userPhone);

    setState(() {
      _sessions = sessions;
      _loading = false;
    });
  } catch (e) {
    setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF0EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF0EF),
        elevation: 0,
        title: const Text(
          "Parking History",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(
                  child: Text(
                    "No previous parking sessions found.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.vehicleNumber ?? "Unknown Vehicle",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Lot ID: ${session.lotId}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Entry: ${session.startTime}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Exit: ${session.status.toLowerCase() == 'completed'
                              ? (session.endTime ?? 'Completed')
                                : 'Still Parked'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: session.status == "completed"
                                      ? Colors.green.shade600
                                      : Colors.orange.shade600,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  session.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
