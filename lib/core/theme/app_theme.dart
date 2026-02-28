import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Font family for app text (Nunito from assets).
const String appFontFamily = 'Nunito';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: appFontFamily,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.light(
          surface: AppColors.lightBackground,
          primary: AppColors.lightPrimary,
          onSurface: AppColors.lightTextPrimary,
          onSurfaceVariant: AppColors.lightTextSecondary,
        ),
        textTheme: _nunitoTextTheme(ThemeData.light().textTheme),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: appFontFamily,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          surface: AppColors.darkBackground,
          primary: AppColors.darkAccentPurple,
          onSurface: AppColors.darkTextPrimary,
        ),
        textTheme: _nunitoTextTheme(ThemeData.dark().textTheme),
      );

  static TextTheme _nunitoTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: appFontFamily),
      displayMedium: base.displayMedium?.copyWith(fontFamily: appFontFamily),
      displaySmall: base.displaySmall?.copyWith(fontFamily: appFontFamily),
      headlineLarge: base.headlineLarge?.copyWith(fontFamily: appFontFamily),
      headlineMedium: base.headlineMedium?.copyWith(fontFamily: appFontFamily),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: appFontFamily),
      titleLarge: base.titleLarge?.copyWith(fontFamily: appFontFamily),
      titleMedium: base.titleMedium?.copyWith(fontFamily: appFontFamily),
      titleSmall: base.titleSmall?.copyWith(fontFamily: appFontFamily),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: appFontFamily),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: appFontFamily),
      bodySmall: base.bodySmall?.copyWith(fontFamily: appFontFamily),
      labelLarge: base.labelLarge?.copyWith(fontFamily: appFontFamily),
      labelMedium: base.labelMedium?.copyWith(fontFamily: appFontFamily),
      labelSmall: base.labelSmall?.copyWith(fontFamily: appFontFamily),
    );
  }
}
