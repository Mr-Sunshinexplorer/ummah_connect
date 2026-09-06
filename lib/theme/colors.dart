import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Theme
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color secondaryDark = Color(0xFF16213E);
  static const Color tertiaryDark = Color(0xFF0F3460);
  
  // Accent Colors
  static const Color islamicGold = Color(0xFFD4AF37);
  static const Color paradiseGreen = Color(0xFF50C878);
  static const Color softWhite = Color(0xFFF5F5F5);
  static const Color moonlight = Color(0xFFE8E8E8);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
      Color(0xFF0F3460),
    ],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFF4D03F),
      Color(0xFFD4AF37),
    ],
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    colors: [
      Color(0xFF50C878),
      Color(0xFF2ECC71),
      Color(0xFF27AE60),
    ],
  );
}

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.primaryDark,
      
      // Use Google Fonts in theme
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.softWhite,
        displayColor: AppColors.softWhite,
      ),
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.islamicGold,
        secondary: AppColors.paradiseGreen,
        surface: AppColors.secondaryDark,
        background: AppColors.primaryDark,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.islamicGold),
        titleTextStyle: GoogleFonts.cairo(
          color: AppColors.islamicGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Fixed: Use CardThemeData instead of CardTheme
      cardTheme: CardThemeData(
        color: AppColors.secondaryDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryDark,
        selectedItemColor: AppColors.islamicGold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.islamicGold,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}