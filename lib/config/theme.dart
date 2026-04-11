import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Website palette constants
  static const Color _darkBg = Color(0xFF0D1117);
  static const Color _darkBgAlt = Color(0xFF111418);
  static const Color _darkSurface = Color(0xFF1A2433);
  static const Color _darkBorder = Color(0xFF2A3441);
  static const Color _darkFg = Color(0xFFEEEEE8);
  static const Color _darkFgMuted = Color(0xFF8B919E);
  static const Color _darkFgFaint = Color(0xFF5A6270);

  static const Color _lightBg = Color(0xFFEEEEE8);
  static const Color _lightBgAlt = Color(0xFFE2E1DA);
  static const Color _lightSurface = Color(0xFFD8D6CF);
  static const Color _lightBorder = Color(0xFFB8B5AC);
  static const Color _lightFg = Color(0xFF0D1117);
  static const Color _lightFgMuted = Color(0xFF5A6270);
  static const Color _lightFgFaint = Color(0xFF8B919E);

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    return baseTheme.copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _darkFg,
        onPrimary: _darkBg,
        secondary: _darkFgMuted,
        onSecondary: _darkBg,
        surface: _darkSurface,
        onSurface: _darkFg,
        surfaceContainerHighest: _darkBgAlt,
        outline: _darkBorder,
        outlineVariant: _darkBorder,
        error: Color(0xFFF85149),
        onError: _darkBg,
        background: _darkBg,
        onBackground: _darkFg,
      ),
      scaffoldBackgroundColor: _darkBg,
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(baseTheme.textTheme).apply(
        bodyColor: _darkFg,
        displayColor: _darkFg,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: _darkBgAlt,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: _darkBorder),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _darkBgAlt,
        foregroundColor: _darkFg,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _darkFg,
        ),
        iconTheme: const IconThemeData(color: _darkFgMuted),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: _darkBgAlt,
        selectedItemColor: _darkFg,
        unselectedItemColor: _darkFgFaint,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w500, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: _darkBorder,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkBgAlt,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _darkBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _darkBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _darkFg, width: 1),
        ),
        hintStyle: GoogleFonts.jetBrainsMono(color: _darkFgFaint, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkFg,
          foregroundColor: _darkBg,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkFg,
          side: const BorderSide(color: _darkFg),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkFg,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: _darkFgMuted,
        textColor: _darkFg,
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _lightFg,
        onPrimary: _lightBg,
        secondary: _lightFgMuted,
        onSecondary: _lightBg,
        surface: _lightSurface,
        onSurface: _lightFg,
        surfaceContainerHighest: _lightBgAlt,
        outline: _lightBorder,
        outlineVariant: _lightBorder,
        error: Color(0xFFCF222E),
        onError: _lightBg,
        background: _lightBg,
        onBackground: _lightFg,
      ),
      scaffoldBackgroundColor: _lightBg,
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(baseTheme.textTheme).apply(
        bodyColor: _lightFg,
        displayColor: _lightFg,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: _lightBgAlt,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: _lightBorder),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _lightBgAlt,
        foregroundColor: _lightFg,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _lightFg,
        ),
        iconTheme: const IconThemeData(color: _lightFgMuted),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: _lightBgAlt,
        selectedItemColor: _lightFg,
        unselectedItemColor: _lightFgFaint,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w500, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: _lightBorder,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightBgAlt,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _lightBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _lightBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _lightFg, width: 1),
        ),
        hintStyle: GoogleFonts.jetBrainsMono(color: _lightFgFaint, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightFg,
          foregroundColor: _lightBg,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightFg,
          side: const BorderSide(color: _lightFg),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightFg,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(fontSize: 13),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: _lightFgMuted,
        textColor: _lightFg,
      ),
    );
  }

  static Color get successColor => const Color(0xFF3FB950);
  static Color get errorColor => const Color(0xFFF85149);
  static Color get warningColor => const Color(0xFFD29922);
  static Color get infoColor => const Color(0xFF8B919E);
}

extension TextThemeExtension on TextTheme {
  TextStyle? get bodySmallBold => bodySmall?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get bodyMediumBold => bodyMedium?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get bodyLargeBold => bodyLarge?.copyWith(fontWeight: FontWeight.w600);
}
