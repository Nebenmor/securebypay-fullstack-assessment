import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF5A65AB);
  static const authBg = Color(0xFFFAFAFA);
  static const textPrimary = Color(0xFF171717);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral900 = Color(0xFF171717);

  // dashboard
  static const sidebarBorder = Color(0xFFE5E5E5);
  static const textSecondary = Color(0xFF525252);
  static const bannerBg = Color(0xFF262A48);
  static const neutral500 = Color(0xFF737373);
  static const statusInTransitBg = Color(0xFFFFEAD9);
  static const statusInTransitText = Color(0xFFCB854B);
  static const statusPaidBg = Color(0xFFEFEDED);
  static const statusPaidText = Color(0xFF808080);
  static const statusDelayedBg = Color(0xFFC0FBFF);
  static const statusDelayedText = Color(0xFF003337);
  static const statusDeliveredBg = Color(0xFFDDF5E4);
  static const statusDeliveredText = Color(0xFF1F8A4C);
  static const rowLabel = Color(0xFF808080);
  static const rowValue = Color(0xFF3A3A3A);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.authBg,
    textTheme: GoogleFonts.dmSansTextTheme(),
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
}
