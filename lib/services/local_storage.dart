import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static late Box userBox;
  static late Box settingsBox;
  static late Box bookmarksBox;
  static late Box notesBox;
  
  static Future<void> init() async {
    userBox = await Hive.openBox('user_data');
    settingsBox = await Hive.openBox('app_settings');
    bookmarksBox = await Hive.openBox('bookmarks');
    notesBox = await Hive.openBox('notes');
  }
  
  // User methods
  static void saveUser(Map<String, dynamic> user) {
    userBox.put('current_user', user);
  }
  
  static Map<String, dynamic>? getUser() {
    final data = userBox.get('current_user');
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }
  
  // Settings methods
  static void saveSetting(String key, dynamic value) {
    settingsBox.put(key, value);
  }
  
  static dynamic getSetting(String key) {
    return settingsBox.get(key);
  }
  
  // Bookmark methods
  static void addBookmark(String key, Map<String, dynamic> data) {
    bookmarksBox.put(key, data);
  }
  
  static void removeBookmark(String key) {
    bookmarksBox.delete(key);
  }
  
  static List<Map<String, dynamic>> getBookmarks() {
    return bookmarksBox.values
        .map((data) => Map<String, dynamic>.from(data))
        .toList();
  }
  
  // Note methods
  static void addNote(String key, Map<String, dynamic> data) {
    notesBox.put(key, data);
  }
  
  static void removeNote(String key) {
    notesBox.delete(key);
  }
  
  static List<Map<String, dynamic>> getNotes() {
    return notesBox.values
        .map((data) => Map<String, dynamic>.from(data))
        .toList();
  }
}