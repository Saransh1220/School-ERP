import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // --- Core Palette (Leo's Journal Theme) ---
  static const Color iceWhite = Color(0xFFFAFAFA); // Clean Off-White
  static const Color creamWhite = iceWhite; 
  static const Color offWhite = iceWhite; 
  static const Color pureWhite = Colors.white;
  
  static const Color textNavy = Color(0xFF263238); // Dark Navy/Black for High Contrast Headers
  static const Color textGreyBlue = Color(0xFF78909C); // Cool Grey for secondary text

  // Compatibility Aliases 
  static const Color textMain = textNavy; 
  static const Color textSecondary = textGreyBlue;

  // --- Vibrant Primaries (From Images) ---
  static const Color parentTeal = Color(0xFF00BFA5); // Vibrant Teal (Primary Action)
  static const Color parentOrange = Color(0xFFFF9100); // Warm Orange (Food)
  static const Color parentGreen = Color(0xFF00C853); // Vibrant Green (Status)
  
  // Re-mapping Storybook -> Vibrant Image Theme
  static const Color parentDeepTeal = parentTeal; 
  static const Color parentOceanBlue = parentTeal; 
  static const Color parentActiveGreen = parentGreen; 
  
  static const Color parentCyan = Color(0xFFE0F2F1); // Very light teal for backgrounds
  static const Color parentLime = parentOrange; // Map Yellow/Lime to Orange
  
  static const Color parentCoral = parentOrange; 
  static const Color parentSky = parentCyan;   
  static const Color parentYellow = parentOrange; 
  static const Color parentLavender = Color(0xFF26A69A); // Secondary Teal
  static const Color parentMint = parentGreen; 

  // Mapped for compatibility 
  static const Color parentBlue = parentTeal;
  static const Color parentPeach = parentOrange; 
  static const Color parentAmber = parentOrange;

  // --- Role Primaries (Restored) ---
  static const Color teacherBlue = Color(0xFF64B5F6); 
  static const Color teacherYellow = Color(0xFFFFF176); 
  static const Color adminNavy = Color(0xFF37474F); 
  static const Color adminTeal = Color(0xFF80CBC4); 

  // --- Gradients (Restored) ---
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

  // --- Gradients (Subtle to None - Clean Look) ---
  static const LinearGradient storyGradient = LinearGradient(
    colors: [parentTeal, parentTeal], // Solid line look
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient parentGradient = LinearGradient(
    colors: [Colors.white, Colors.white], // Clean White Header
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
     colors: [Colors.white, Colors.white], // Clean White Cards
     begin: Alignment.topLeft,
     end: Alignment.bottomRight
  );

  // --- Shadows (Soft & Subtle) ---
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: const Color(0xFF37474F).withOpacity(0.08), // Soft grey shadow
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF37474F).withOpacity(0.05),
      blurRadius: 4,
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
