import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color lightBackground = Color(0xFFFFF9F0);
  static const Color lightPrimary = Color(0xFF630168);
  static const Color lightAccent = Color(0xFFE6830F);
  static const Color lightSurface = Color(0xFFF7F7F7);

  static const Color darkBackground = Color(0xFF392955);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkBrown = Color(0xFF5C2E00);
  static const Color darkOrange = Color(0xFFCC6C00);
  static const Color darkAccentPurple = Color(0xFF833386);

  static const Color lightTextPrimary = lightPrimary;
  static const Color lightTextSecondary = Color(0xCC630168);
  static const Color lightBubble = Color(0xFFe3d2e5);
  static const Color lightPauseButton = lightSurface;
  static const Color lightSelectedOption = lightAccent;

  static const Color darkTextPrimary = Colors.white;
  static const Color darkBubble = Color(0xFF58377c);
  static const Color darkPauseButton = darkAccentPurple;
  /// Card background in dark theme.
  static const Color darkCardBackground = Color(0xFF453A58);

  static const Color progressBarFill = lightPrimary;
  static const Color progressBarFillDark = darkAccentPurple;
}
