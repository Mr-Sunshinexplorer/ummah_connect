import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'screens/main_navigation.dart';

class UmmahConnectApp extends StatelessWidget {
  const UmmahConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ummah Connect',
      debugShowCheckedModeBanner: false,
      theme: DarkTheme.theme,
      home: const MainNavigation(),
    );
  }
}