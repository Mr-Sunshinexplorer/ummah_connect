import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('user_data');
  await Hive.openBox('app_settings');
  await Hive.openBox('quran_bookmarks');
  await Hive.openBox('quran_notes');
  await Hive.openBox('quran_settings');
  await Hive.openBox('quran_last_read');
  await Hive.openBox('hadith_bookmarks');
  await Hive.openBox('hadith_favorites');
  
  runApp(const UmmahConnectApp());
}