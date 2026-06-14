import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF0A1020);
  static const Color bgSoft = Color(0xFF101833);
  static const Color panel = Color(0xEE121934);
  static const Color panelStrong = Color(0xF51A244A);
  static const Color text = Color(0xFFEEF1FF);
  static const Color muted = Color(0xFF9EA8D5);
  static const Color line = Color(0x14FFFFFF);
  static const Color primary = Color(0xFF8A7DFF);
  static const Color primary2 = Color(0xFF5DE1FF);
  static const Color success = Color(0xFF63E0A4);
  static const Color warning = Color(0xFFFFCA7A);
  static const Color chip = Color(0x288A7DFF);

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.notoSansScTextTheme().apply(
      bodyColor: text,
      displayColor: text,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary2,
        surface: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF08101C),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x08FFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x10FFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x10FFFFFF)),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(color: muted),
      ),
    );
  }
}
