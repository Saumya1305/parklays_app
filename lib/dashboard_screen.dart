import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String currentAddress = "Fetching location...";
  String destination = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => currentAddress = "Location service is disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => currentAddress = "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => currentAddress =
          "Location permissions are permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    setState(() {
      currentAddress =
          "${place.street}, ${place.locality}, ${place.administrativeArea}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Location",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              currentAddress,
              style: TextStyle(fontSize: 14, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // TODO: Open Hamburger Menu
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: Destination search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Destination Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: Colors.redAccent),
                hintText: "Where do you want to go?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() => destination = value);
              },
            ),
          ),

          // Lottie Car Parking Animation
          Expanded(
            child: Center(
              child: Lottie.network(
                  "https://lottie.host/your-car-parking-animation.json"),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.conciergeBell), label: "Services"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        ],
        onTap: (index) {
          if (index == 0) {
            // TODO: Services page
          } else if (index == 1) {
            // TODO: History page
          } else if (index == 2) {
            // TODO: Home
          }
        },
      ),
    );
  }
}
