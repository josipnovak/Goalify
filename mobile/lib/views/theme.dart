import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF1E3A8A),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E3A8A),
      secondary: Color(0xFF3B82F6),
      inversePrimary: Color(0xFF1E3A8A),
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.robotoTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF3B82F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
      elevation: 2,
    ),
  );
}