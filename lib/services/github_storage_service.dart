import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/secrets.dart' show AppSecrets;


class GitHubStorageService {
  // Use values from secrets.dart (not hardcoded)
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
  
  // Write data to GitHub (requires personal access token)
  Future<bool> writeData(String path, Map<String, dynamic> data, {String? token}) async {
    if (token == null) {
      print('GitHub token required for writing');
      return false;
    }
    
    try {
      // Check if file exists
      final existingFile = await _getFileSha(path, token);
      
      final response = await http.put(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': 'Update $path',
          'content': base64.encode(utf8.encode(json.encode(data))),
          'branch': _branch,
          if (existingFile != null) 'sha': existingFile,
        }),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error writing to GitHub: $e');
      return false;
    }
  }
  
  // Get file SHA (needed for updates)
  Future<String?> _getFileSha(String path, String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {'Authorization': 'token $token'},
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
  
  // Create repository (one-time setup)
  Future<bool> createRepository(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.github.com/user/repos'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _repo,
          'description': 'Ummah Connect Data Storage',
          'public': true,
          'auto_init': true,
        }),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating repo: $e');
      return false;
    }
  }
  
  // Upload file to GitHub
  Future<bool> uploadFile(String path, String content, String token) async {
    try {
      final response = await http.put(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $token',
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
  Future<bool> deleteFile(String path, String token) async {
    try {
      final sha = await _getFileSha(path, token);
      if (sha == null) return false;
      
      final response = await http.delete(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/contents/$path'),
        headers: {
          'Authorization': 'token $token',
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
}