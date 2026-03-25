import 'package:flutter/material.dart';

class AppColors {
  // Brand palette: logo crimson red + steel gray — no pink
  static const Color primary = Color(0xFFCC0A14);      // deep logo crimson
  static const Color primaryDark = Color(0xFF8A0610);  // dark maroon
  static const Color primaryLight = Color(0xFFE82530); // bright clean red

  static const Color secondary = Color(0xFF5C626F);    // steel gray
  static const Color secondaryDark = Color(0xFF1E2229);// near-black steel
  static const Color secondaryLight = Color(0xFF8C929F);// silver

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF2F3F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFEBECEF);
  static const Color lightBorder = Color(0xFFCDD0D7);

  // Dark theme surfaces — dark charcoal with maroon undertone
  static const Color darkBackground = Color(0xFF0A0A0E);
  static const Color darkSurface = Color(0xFF111318);
  static const Color darkSurfaceRaised = Color(0xFF191C25);
  static const Color darkBorder = Color(0xFF262B36);

  // Gradient wash tints
  static const Color darkWashMaroon = Color(0xFF3D0408); // maroon tint for dark gradient

  // Feedback
  static const Color error = Color(0xFFCF3333);
}
