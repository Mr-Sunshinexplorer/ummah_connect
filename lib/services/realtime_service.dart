import 'dart:async';
import 'github_storage_service.dart';

class RealtimeService {
  final GitHubStorageService _githubStorage = GitHubStorageService();
  Timer? _pollingTimer;
  
  // Callbacks - REMOVED onMessagesUpdated (chat uses Hive, not GitHub)
  Function(List<Map<String, dynamic>>)? onPostsUpdated;
  Function(Map<String, dynamic>)? onUserUpdated;
  
  // Start polling
  void startRealtimeUpdates({int intervalSeconds = 10}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _pollAllData(),
    );
  }
  
  // Stop polling
  void stopRealtimeUpdates() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
  // Poll all data (ONLY posts - NOT chat messages)
  Future<void> _pollAllData() async {
    await _pollPosts();
  }
  
  // Poll posts from GitHub
  Future<void> _pollPosts() async {
    try {
      final posts = await _githubStorage.readPosts();
      if (onPostsUpdated != null) {
        onPostsUpdated!(posts);
      }
    } catch (e) {
      print('Error polling posts: $e');
    }
  }
  
  void dispose() {
    stopRealtimeUpdates();
  }
}