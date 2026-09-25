import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Placeholders - we'll replace these with exact Figma values.
  static const primary = Color(0xFF5B63AB);
  static const background = Color(0xFFFAFAFA);
  static const textDark = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF6B6B6B);
  static const border = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.dmSansTextTheme(),
      );
}