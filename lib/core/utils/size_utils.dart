import 'package:flutter/material.dart';

/// Responsive size helpers: getH/getW (% of screen), getSp (font size). Breakpoint = 600px for web.
abstract final class SizeUtils {
  SizeUtils._();

  /// Breakpoint for web vs mobile layout (width >= this = web).
  static const double breakpoint = 600;

  static const double _designShortSide = 400.0;
  static const double _spScaleMin = 0.85;
  static const double _spScaleMax = 1.35;

  /// Current screen width in logical pixels.
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Current screen height in logical pixels.
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Height as % of screen (0–100); null = full height.
  static double getH(BuildContext context, [double? percent]) {
    final h = screenHeight(context);
    return percent == null ? h : h * (percent / 100);
  }

  /// Width as % of screen (0–100); null = full width.
  static double getW(BuildContext context, [double? percent]) {
    final w = screenWidth(context);
    return percent == null ? w : w * (percent / 100);
  }

  /// Responsive font size; scaled by screen short side, clamped for readability.
  static double getSp(BuildContext context, double baseSize) {
    final size = MediaQuery.sizeOf(context);
    final short = size.width < size.height ? size.width : size.height;
    final scale = (short / _designShortSide).clamp(_spScaleMin, _spScaleMax);
    return (baseSize * scale).roundToDouble();
  }

  static double _spacing(BuildContext context, double percent) =>
      getH(context, percent);

  static double spacingXs(BuildContext context) => _spacing(context, 0.8);
  static double spacingSm(BuildContext context) => _spacing(context, 1.2);
  static double spacingMd(BuildContext context) => _spacing(context, 2);
  static double spacingLg(BuildContext context) => _spacing(context, 3);
  static double spacingXl(BuildContext context) => _spacing(context, 4);
}

/// context.getH, getW, getSp, spacing*.
extension SizeUtilsExtension on BuildContext {
  double get screenWidth => SizeUtils.screenWidth(this);
  double get screenHeight => SizeUtils.screenHeight(this);

  double getH([double? percent]) => SizeUtils.getH(this, percent);
  double getW([double? percent]) => SizeUtils.getW(this, percent);
  double getSp(double baseSize) => SizeUtils.getSp(this, baseSize);

  double get spacingXs => SizeUtils.spacingXs(this);
  double get spacingSm => SizeUtils.spacingSm(this);
  double get spacingMd => SizeUtils.spacingMd(this);
  double get spacingLg => SizeUtils.spacingLg(this);
  double get spacingXl => SizeUtils.spacingXl(this);
}
