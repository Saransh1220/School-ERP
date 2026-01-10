import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/auth/domain/user_entity.dart';

class ThemeFactory {
  // Shared Colors
  static const Color scaffoldBackground = Color(0xFFF7F9FC);
  static const Color textDark = Color(0xFF2D3242);
  static const Color textGrey = Color(0xFF757575);

  // Semantic Colors
  static const Color successColor = Color(0xFF98FF98);
  static const Color warningColor = Color(0xFFFFE082);
  static const Color errorColor = Color(0xFFFFAB91);

  // --- Parent Theme Colors (Pastel/Emotional) ---
  static const Color parentPrimary = Color(0xFF87CEEB); // Sky Blue
  static const Color parentSecondary = Color(0xFFFFCCB0); // Peach
  static const Color parentAccent = Color(0xFFE6E6FA); // Lavender

  // --- Teacher Theme Colors (Functional/Calm) ---
  static const Color teacherPrimary = Color(0xFF5C93FA); // Calm Blue
  static const Color teacherSecondary = Color(0xFFFFF59D); // Soft Yellow
  static const Color teacherAccent = Color(0xFF81C784); // Soft Green

  // --- Admin Theme Colors (Professional/Data) ---
  static const Color adminPrimary = Color(0xFF2C3E50); // Deep Blue
  static const Color adminSecondary = Color(0xFF26A69A); // Teal
  static const Color adminAccent = Color(0xFFECEFF1); // Light Grey

  static ThemeData getThemeForRole(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return _buildParentTheme();
      case UserRole.teacher:
        return _buildTeacherTheme();
      case UserRole.admin:
        return _buildAdminTheme();
    }
  }

  static ThemeData _buildParentTheme() {
    final textTheme = GoogleFonts.nunitoTextTheme().apply(bodyColor: textDark, displayColor: textDark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: parentPrimary,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: parentPrimary,
        primary: parentPrimary,
        secondary: parentSecondary,
        tertiary: parentAccent,
        surface: Colors.white,
        background: scaffoldBackground,
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textDark),
      ),
      /*
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Extra rounded
        margin: const EdgeInsets.all(8),
      ),
      */
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: parentPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData _buildTeacherTheme() {
    final textTheme = GoogleFonts.interTextTheme().apply(bodyColor: textDark, displayColor: textDark); // Cleaner font
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: teacherPrimary,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Slightly denser grey
      colorScheme: ColorScheme.fromSeed(
        seedColor: teacherPrimary,
        primary: teacherPrimary,
        secondary: teacherSecondary,
        tertiary: teacherAccent,
        surface: Colors.white,
        background: const Color(0xFFF5F5F5),
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false, // Left align for utility
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textDark),
      ),
      /*
       cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Tighter radius
        margin: const EdgeInsets.all(4),
      ),
      */
       floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: teacherPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))), // Squarish
      ),
    );
  }

  static ThemeData _buildAdminTheme() {
    final textTheme = GoogleFonts.robotoTextTheme().apply(bodyColor: textDark, displayColor: textDark); // Standard font
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: adminPrimary,
      scaffoldBackgroundColor: const Color(0xFFECEFF1),
      colorScheme: ColorScheme.fromSeed(
        seedColor: adminPrimary,
        primary: adminPrimary,
        secondary: adminSecondary,
        tertiary: adminAccent,
        surface: Colors.white,
        background: const Color(0xFFECEFF1),
      ),
       textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: adminPrimary,
        elevation: 2,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      /*
       cardTheme: CardTheme(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Professional/Boxy
        margin: const EdgeInsets.all(4),
      ),
      */
    );
  }
}

// Deprecated AppTheme class kept for backward compatibility if needed temporarily
class AppTheme {
  static const Color primaryColor = ThemeFactory.parentPrimary;
  static const Color secondaryColor = ThemeFactory.parentSecondary;
  static const Color successColor = Color(0xFF98FF98);
  static const Color warningColor = Color(0xFFFFE082);
  static const Color errorColor = Color(0xFFFFAB91);
  static const Color scaffoldBackground = ThemeFactory.scaffoldBackground;
  static const Color textDark = ThemeFactory.textDark;
  static const Color textGrey = ThemeFactory.textGrey;
}
