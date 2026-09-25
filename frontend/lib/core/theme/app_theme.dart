import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF5A65AB);
  static const authBg = Color(0xFFFAFAFA);
  static const textPrimary = Color(0xFF171717);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral900 = Color(0xFF171717);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary),
        scaffoldBackgroundColor: AppColors.authBg,
        textTheme: GoogleFonts.dmSansTextTheme(),
        fontFamily: GoogleFonts.dmSans().fontFamily,
      );
}