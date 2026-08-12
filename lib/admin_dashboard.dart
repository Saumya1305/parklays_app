import 'package:flutter/material.dart';
import 'admin_slot_map_page.dart';
import 'qr_scan_page.dart';
import 'parking_history_page.dart';
import 'active_sessions_page.dart';
import 'parking_reports_page.dart';
import 'admin_profile_page.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic> admin;

  const AdminDashboard({super.key, required this.admin});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color darkBlack = const Color(0xFF060606);
  final Color limeGreen = const Color(0xFFD7EE46);
  final Color softWhite = const Color(0xFFEFF0EF);
  final Color pureWhite = const Color(0xFFFFFFFF);

  int _selectedIndex = 0;

  void _onTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _AdminHome(admin: widget.admin),
      ScanQRPage(
        adminId: widget.admin['admin']['id'],
        lotId: widget.admin['admin']['lotId'],
      ),
      const _PendingPage(),
      _AdminProfile(admin: widget.admin),
    ];

    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: softWhite,
        elevation: 0,
        title: Text(
          "Hello, ${widget.admin['admin']['name']}",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(child: _pages[_selectedIndex]),

          // Floating bottom nav same as user dashboard
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: _AdminBottomNav(
                background: darkBlack,
                selected: limeGreen,
                unselected: pureWhite,
                currentIndex: _selectedIndex,
                onTap: _onTab,
                admin: widget.admin,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =================== ADMIN HOME PAGE =================== */

class _AdminHome extends StatelessWidget {
  final Map<String, dynamic> admin;

  const _AdminHome({required this.admin});

  @override
  Widget build(BuildContext context) {
    final pureWhite = Colors.white;
    final softWhite = const Color(0xFFEFF0EF);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assigned Parking Lot",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text("Lot ID: ${admin['admin']['lotId']}"),
              Text("Name: ${admin['admin']['name'] ?? 'N/A'}"),
              Text(
                "Status: ${admin['admin']['isActive'] == true ? 'Active' : 'Inactive'}",
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          "Actions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),

        _ActionTile(
          icon: Icons.local_parking,
          title: "Update Slot Availability",
          color: softWhite,
          onPress: () {
            print("NAVIGATING WITH ADMIN ID → ${admin['admin']['id']}");
            print("NAVIGATING WITH LOT ID → ${admin['admin']['lotId']}");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminSlotMapPage(
                  adminId: admin['admin']['id'], // ← FIXED
                  lotId: admin['admin']['lotId'], // ← FIXED
                ),
              ),
            );
          },
        ),

        // ✅ Add QR Scan tile here
        _ActionTile(
          icon: Icons.history, // changed from QR code scanner
          title: "View Parking History", // updated title
          color: softWhite,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ParkingHistoryPage(
                  lotId: admin['admin']['lotId'],
                  adminId: admin['admin']['id'],
                ),
              ),
            );
          },
        ),
        _ActionTile(
          icon: Icons.verified_user,
          title: "View Pending Confirmations",
          color: softWhite,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ActiveSessionsListPage(lotId: admin['admin']['lotId']),
              ),
            );
          },
        ),
        _ActionTile(
          icon: Icons.download_rounded,
          title: "Reports",
          color: softWhite,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ParkingReportsPage(lotId: admin['admin']['lotId']),
              ),
            );
          },
        ),
      ],
    );
  }
}

/* =================== ACTION TILE =================== */

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPress;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
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
              Icon(icon, size: 30, color: Colors.black87),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/* =================== PENDING CONFIRMATIONS =================== */

class _PendingPage extends StatelessWidget {
  const _PendingPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pending Confirmations", style: TextStyle(fontSize: 18)),
    );
  }
}

/* =================== PROFILE =================== */

class _AdminProfile extends StatelessWidget {
  final Map<String, dynamic> admin;

  const _AdminProfile({required this.admin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profile Page\n${admin['name']}",
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/* =================== BOTTOM NAV =================== */

class _AdminBottomNav extends StatelessWidget {
  const _AdminBottomNav({
    required this.background,
    required this.selected,
    required this.unselected,
    required this.currentIndex,
    required this.onTap,
    required this.admin, // <-- add this
  });

  final Color background;
  final Color selected;
  final Color unselected;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Map<String, dynamic> admin; // <-- add this

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
            _AdminNavItem(
              icon: Icons.dashboard_rounded,
              index: 0,
              isSelected: currentIndex == 0,
              selected: selected,
              unselected: unselected,
              onTap: onTap,
            ),
            _AdminNavItem(
              icon: Icons.history_rounded, // changed from QR code scanner
              index: 1,
              isSelected: currentIndex == 1,
              selected: selected,
              unselected: unselected,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ParkingHistoryPage(
                        lotId: admin['admin']['lotId'],
                        adminId: admin['admin']['id'],
                      ),
                    ),
                  );
                } else {
                  onTap(index);
                }
              },
            ),

            _AdminNavItem(
              icon: Icons.list_alt_rounded,
              index: 2,
              isSelected: currentIndex == 2,
              selected: selected,
              unselected: unselected,
              onTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ActiveSessionsListPage(lotId: admin['admin']['lotId']),
                  ),
                );
              },
            ),
            _AdminNavItem(
              icon: Icons.person_rounded,
              index: 3,
              isSelected: currentIndex == 3,
              selected: selected,
              unselected: unselected,
              onTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminProfilePage(admin: admin),
      ),
    );
  },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  const _AdminNavItem({
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
      child: Icon(icon, size: 26, color: isSelected ? selected : unselected),
    );
  }
}
