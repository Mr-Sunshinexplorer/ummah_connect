import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  // Use Google Fonts with fallbacks
  static TextStyle get quranicText => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.islamicGold,
    height: 1.8,
  );
  
  static TextStyle get heading => GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.softWhite,
  );
  
  static TextStyle get title => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.softWhite,
  );
  
  static TextStyle get body => GoogleFonts.cairo(
    fontSize: 14,
    color: AppColors.moonlight,
    height: 1.6,
  );
  
  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 12,
    color: Colors.grey,
  );
  
  // Dynamic font size methods
  static TextStyle quranicTextWithSize(double fontSize) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.islamicGold,
      height: 1.8,
    );
  }
  
  static TextStyle arabicText(double fontSize) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      color: Colors.white,
      height: 1.8,
    );
  }
  
  static TextStyle urduText(double fontSize) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      color: Colors.grey[300],
      height: 1.8,
    );
  }
}