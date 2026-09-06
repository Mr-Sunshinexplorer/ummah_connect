import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  
  // Get all 114 Surahs
  Future<List<Surah>> getAllSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final surahs = (data['data'] as List)
          .map((surah) => Surah.fromJson(surah))
          .toList();
      return surahs;
    } else {
      throw Exception('Failed to load surahs');
    }
  }
  
  // Get Surah with translation
  Future<SurahDetail> getSurahWithTranslation({
    required int surahNumber,
    String edition = 'en.asad',
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$surahNumber/$edition'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SurahDetail.fromJson(data['data']);
    } else {
      throw Exception('Failed to load surah');
    }
  }
  
  // Get Arabic Surah
  Future<SurahDetail> getArabicSurah(int surahNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$surahNumber'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SurahDetail.fromJson(data['data']);
    } else {
      throw Exception('Failed to load Arabic surah');
    }
  }
  
  // Search Quran
  Future<List<Map<String, dynamic>>> searchQuran(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/$query/all/en'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Search failed');
    }
  }
  
  // Get audio URL
  String getSurahAudioUrl({
    required int surahNumber,
    String reciter = 'ar.alafasy',
  }) {
    return 'https://cdn.islamic.network/quran/audio/128/$reciter/$surahNumber.mp3';
  }
}