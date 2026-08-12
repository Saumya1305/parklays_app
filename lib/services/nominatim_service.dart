import 'dart:convert';
import 'package:http/http.dart' as http;

class NominatimService {
  static Future<List<Map<String, dynamic>>> search(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=10',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'ParklaysApp/1.0 (mishrasaumya134@gmail.com)' // Replace with your email/project name
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => {
        'displayName': e['display_name'],
        'lat': double.parse(e['lat']),
        'lon': double.parse(e['lon']),
      }).toList();
    } else {
      throw Exception("Nominatim request failed: ${response.statusCode}");
    }
  }
}
