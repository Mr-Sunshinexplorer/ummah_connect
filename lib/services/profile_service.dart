import 'dart:convert';
import 'package:http/http.dart' as http;
import 'github_storage_service.dart';

class ProfileService {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  
  // Create new user profile
  Future<Map<String, dynamic>> createProfile({
    required String name,
    String? gender,
    String? location,
    String? madhab,
  }) async {
    final profile = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'gender': gender ?? 'private',
      'location': location ?? 'Unknown',
      'madhab': madhab ?? 'Not specified',
      'level': 1,
      'hasanatPoints': 0,
      'achievements': [],
      'prayersCompleted': 0,
      'quranVersesRead': 0,
      'postsCreated': 0,
      'messagesSent': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'lastActive': DateTime.now().toIso8601String(),
    };
    
    await _githubStorage.storeUserData(profile);
    return profile;
  }
  
  // Update profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final current = await getProfile();
    final updated = {...current, ...updates, 'lastActive': DateTime.now().toIso8601String()};
    await _githubStorage.storeUserData(updated);
  }
  
  // Get profile
  Future<Map<String, dynamic>> getProfile() async {
    final profile = await _githubStorage.readUserData('current_user');
    if (profile.isEmpty) {
      return await createProfile(name: 'Anonymous_${DateTime.now().millisecondsSinceEpoch % 10000}');
    }
    return profile;
  }
  
  // Add hasanat points
  Future<void> addHasanatPoints(int points) async {
    final profile = await getProfile();
    final currentPoints = profile['hasanatPoints'] ?? 0;
    await updateProfile({
      'hasanatPoints': currentPoints + points,
    });
  }
  
  // Increment prayer count
  Future<void> incrementPrayers() async {
    final profile = await getProfile();
    final currentCount = profile['prayersCompleted'] ?? 0;
    await updateProfile({
      'prayersCompleted': currentCount + 1,
      'hasanatPoints': (profile['hasanatPoints'] ?? 0) + 10,
    });
  }
  
  // Increment Quran reading
  Future<void> incrementQuranReading() async {
    final profile = await getProfile();
    final currentCount = profile['quranVersesRead'] ?? 0;
    await updateProfile({
      'quranVersesRead': currentCount + 1,
      'hasanatPoints': (profile['hasanatPoints'] ?? 0) + 5,
    });
  }
  
  // Add achievement
  Future<void> addAchievement(String achievement) async {
    final profile = await getProfile();
    final achievements = List<String>.from(profile['achievements'] ?? []);
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      await updateProfile({
        'achievements': achievements,
        'hasanatPoints': (profile['hasanatPoints'] ?? 0) + 50,
      });
    }
  }
  
  // Update level based on points
  Future<void> updateLevel() async {
    final profile = await getProfile();
    final points = profile['hasanatPoints'] ?? 0;
    final newLevel = (points ~/ 100) + 1;
    await updateProfile({'level': newLevel});
  }
}