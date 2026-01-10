import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // --- Core Palette (Storybook) ---
  static const Color creamWhite = Color(0xFFFFFDF9); // Warm background
  static const Color offWhite = creamWhite; // Compatibility alias
  static const Color pureWhite = Colors.white;
  
  static const Color textNavy = Color(0xFF2C3A4B); // Soft Navy titles
  static const Color textGreyBlue = Color(0xFF6B7A90); // Muted body

  // Compatibility Aliases (Restoring these to fix build errors)
  static const Color textMain = textNavy; 
  static const Color textSecondary = textGreyBlue;

  // --- Storybook Primaries ---
  static const Color parentCoral = Color(0xFFFF8A80); // Warmth/Care
  static const Color parentSky = Color(0xFF7EC8FF); // Trust/Calm
  static const Color parentYellow = Color(0xFFFFE082); // Happiness
  static const Color parentMint = Color(0xFF8DE6C3); // Health
  static const Color parentLavender = Color(0xFFC7B7FF); // Creativity

  // Mapped for compatibility (updating old references if any remaining)
  static const Color parentBlue = parentSky;
  static const Color parentPeach = parentCoral; 
  static const Color parentAmber = parentYellow;

  // --- Role Primaries (Teachers/Admin kept same or compatible) ---
  static const Color teacherBlue = Color(0xFF64B5F6); 
  static const Color teacherYellow = Color(0xFFFFF176); 
  static const Color adminNavy = Color(0xFF37474F); 
  static const Color adminTeal = Color(0xFF80CBC4); 

  // --- Gradients (Soft & Emotional) ---
  static const LinearGradient storyGradient = LinearGradient(
    colors: [parentSky, parentMint],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient parentGradient = LinearGradient(
    colors: [Color(0xFFFFF0EC), creamWhite], // Coral tint -> Cream
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient teacherGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFFFFDE7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient adminGradient = LinearGradient(
    colors: [Color(0xFFECEFF1), Color(0xFFE0F2F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
     colors: [pureWhite, Color(0xFFFAFAFA)],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight
  );

  // --- Shadows (Colored Glows) ---
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: const Color(0xFF8A9AB9).withOpacity(0.1), // Blue-grey tint
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFFFF8A80).withOpacity(0.05), // Warm coral tint
      blurRadius: 5,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  // Re-map softLift to glowShadow for V2 widgets
  static List<BoxShadow> softLift = glowShadow;

  // --- Typography (Updated Colors) ---
  static TextStyle fontHeader = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textNavy,
    letterSpacing: -0.5,
  );

  static TextStyle fontTitle = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textNavy,
  );

  static TextStyle fontBody = GoogleFonts.dmSans(
    fontSize: 16,
    color: textGreyBlue,
    height: 1.5,
  );
  
  static TextStyle fontSmall = GoogleFonts.dmSans(
    fontSize: 14,
    color: textGreyBlue,
    fontWeight: FontWeight.w500,
  );

  // --- Shape ---
  static BorderRadius radiusxl = BorderRadius.circular(32);
  static BorderRadius radiusL = BorderRadius.circular(24);
  static BorderRadius radiusM = BorderRadius.circular(16);
  static BorderRadius radiusS = BorderRadius.circular(12);
}
