import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTimesService {
  static const String _baseUrl = 'https://api.aladhan.com/v1';
  
  Future<Map<String, dynamic>> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 2, // Islamic Society of North America
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/timings?latitude=$latitude&longitude=$longitude&method=$method'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
  
  Future<Map<String, dynamic>> getPrayerTimesByCity({
    required String city,
    required String country,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/timingsByCity?city=$city&country=$country'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
  
  Future<Map<String, dynamic>> getQiblaDirection({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/qibla/$latitude/$longitude'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load qibla direction');
    }
  }
}