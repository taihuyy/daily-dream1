import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF090D1A);
  static const Color bgDeep = Color(0xFF040713);
  static const Color bgSoft = Color(0xFF11172A);
  static const Color dusk = Color(0xFF241C3E);
  static const Color panel = Color(0xD8121830);
  static const Color panelStrong = Color(0xEF17213F);
  static const Color glass = Color(0x22FFFFFF);
  static const Color glassStrong = Color(0x34FFFFFF);
  static const Color text = Color(0xFFEEF1FF);
  static const Color muted = Color(0xFFAAB3D9);
  static const Color line = Color(0x20FFFFFF);
  static const Color primary = Color(0xFF8F87FF);
  static const Color primary2 = Color(0xFF5BD8E8);
  static const Color moon = Color(0xFFF4D68D);
  static const Color rose = Color(0xFFFF8FB3);
  static const Color mint = Color(0xFF7CE5B4);
  static const Color success = Color(0xFF70E2A8);
  static const Color warning = Color(0xFFFFCA7A);
  static const Color chip = Color(0x2A8F87FF);
  static const Color shadow = Color(0x99040713);

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
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: moon,
          foregroundColor: const Color(0xFF08101C),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
