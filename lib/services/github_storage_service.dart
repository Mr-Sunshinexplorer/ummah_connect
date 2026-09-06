import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/secrets.dart' show AppSecrets;

class GitHubStorageService {
  // Use values from secrets.dart
  static String get _owner => AppSecrets.githubUsername;
  static String get _token => AppSecrets.githubToken;
  static const String _repo = 'ummah_connect';
  static const String _branch = 'main';
  
  // Read data from GitHub (Free, no auth needed for public repos)
  Future<Map<String, dynamic>> readData(String path) async {
    try {
      final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/$_owner/$_repo/$_branch/$path'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error reading from GitHub: $e');
    }
    return {};
  }
  
  // Read list from GitHub
  Future<List<dynamic>> readList(String path) async {
    try {
      final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/$_owner/$_repo/$_branch/$path'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error reading list: $e');
    }
    return [];
  }
  
  // Write data to GitHub
  Future<bool> writeData(String path, Map<String, dynamic> data) async {
    if (_token == 'YOUR_GITHUB_TOKEN_HERE' || _token.isEmpty) {
      print('Please set your GitHub token in lib/config/secrets.dart');
      return false;
    }
    
    try {
      final existingSha = await _getFileSha(path);
      
      final response = await http.put(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.github.v3+json',
        },
        body: json.encode({
          'message': 'Update $path',
          'content': base64.encode(utf8.encode(json.encode(data))),
          'branch': _branch,
          if (existingSha != null) 'sha': existingSha,
        }),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error writing to GitHub: $e');
      return false;
    }
  }
  
  // Write list to GitHub
  Future<bool> writeList(String path, List<dynamic> data) async {
    return await writeData(path, {'data': data});
  }
  
  // Get file SHA
  Future<String?> _getFileSha(String path) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $_token',
          'Accept': 'application/vnd.github.v3+json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['sha'];
      }
    } catch (e) {
      print('Error getting file SHA: $e');
    }
    return null;
  }
  
  // Upload file to GitHub
  Future<bool> uploadFile(String path, String content) async {
    try {
      final response = await http.put(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': 'Upload $path',
          'content': base64.encode(utf8.encode(content)),
          'branch': _branch,
        }),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }
  
  // List files in repository
  Future<List<Map<String, dynamic>>> listFiles({String path = ''}) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $_token',
          'Accept': 'application/vnd.github.v3+json',
        },
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      print('Error listing files: $e');
    }
    return [];
  }
  
  // Delete file from GitHub
  Future<bool> deleteFile(String path) async {
    try {
      final sha = await _getFileSha(path);
      if (sha == null) return false;
      
      final response = await http.delete(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': 'Delete $path',
          'sha': sha,
          'branch': _branch,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
  
  // ============ HIGH-LEVEL METHODS ============
  
  // Store chat messages
  Future<bool> storeChatMessages(List<Map<String, dynamic>> messages) async {
    return await writeData('data/chat_messages.json', {
      'messages': messages,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Read chat messages
  Future<List<Map<String, dynamic>>> readChatMessages() async {
    final data = await readData('data/chat_messages.json');
    return List<Map<String, dynamic>>.from(data['messages'] ?? []);
  }
  
  // Store posts
  Future<bool> storePosts(List<Map<String, dynamic>> posts) async {
    return await writeData('data/posts.json', {
      'posts': posts,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Read posts
  Future<List<Map<String, dynamic>>> readPosts() async {
    final data = await readData('data/posts.json');
    return List<Map<String, dynamic>>.from(data['posts'] ?? []);
  }
  
  // Store user data
  Future<bool> storeUserData(Map<String, dynamic> userData) async {
    final userId = userData['id'] ?? 'anonymous';
    return await writeData('data/users/$userId.json', userData);
  }
  
  // Read user data
  Future<Map<String, dynamic>> readUserData(String userId) async {
    return await readData('data/users/$userId.json');
  }
  
  // Store global feed
  Future<bool> storeGlobalFeed(List<Map<String, dynamic>> feed) async {
    return await writeData('data/global_feed.json', {
      'feed': feed,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Read global feed
  Future<List<Map<String, dynamic>>> readGlobalFeed() async {
    final data = await readData('data/global_feed.json');
    return List<Map<String, dynamic>>.from(data['feed'] ?? []);
  }
}