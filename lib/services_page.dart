import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.ev_station, "EV Charging"),
      (Icons.local_car_wash, "Car Wash"),
      (Icons.security, "Security"),
      (Icons.local_gas_station, "Fuel"),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final (icon, label) = items[i];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 34),
                  const SizedBox(height: 10),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
