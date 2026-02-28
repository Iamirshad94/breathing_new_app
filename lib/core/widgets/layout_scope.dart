import 'package:flutter/material.dart';

import '../utils/size_utils.dart';

/// Provides layout mode (mobile vs web) and content scale to the subtree.
class LayoutScope extends InheritedWidget {
  const LayoutScope({
    required this.isWeb,
    required this.contentScale,
    required super.child,
    super.key,
  });

  final bool isWeb;
  final double contentScale;

  /// Mobile: full scale, isWeb = false.
  static Widget mobile({required Widget child}) => LayoutScope(
        isWeb: false,
        contentScale: 1.0,
        child: child,
      );

  /// Web: reduced scale, isWeb = true.
  static Widget web({
    required Widget child,
    double contentScale = defaultWebScale,
  }) =>
      LayoutScope(
        isWeb: true,
        contentScale: contentScale,
        child: child,
      );

  static const double defaultWebScale = 0.82;

  static LayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LayoutScope>();

  static LayoutScope of(BuildContext context) {
    final scope = maybeOf(context);
    return scope ?? LayoutScope(isWeb: false, contentScale: 1.0, child: const SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(LayoutScope oldWidget) =>
      isWeb != oldWidget.isWeb || contentScale != oldWidget.contentScale;
}

/// isWeb and scale from viewport width; use context.isWeb, context.scaleSp/W/H.
extension LayoutScopeExtension on BuildContext {
  /// True when viewport width >= [SizeUtils.breakpoint].
  bool get isWeb => SizeUtils.screenWidth(this) >= SizeUtils.breakpoint;

  /// 1.0 on mobile, [LayoutScope.defaultWebScale] on web.
  double get layoutScale => isWeb ? LayoutScope.defaultWebScale : 1.0;

  /// Scaled font size for web/mobile.
  double scaleSp(num n) =>
      SizeUtils.getSp(this, (n * layoutScale).toDouble());

  /// Scaled width %.
  double scaleW(num n) =>
      SizeUtils.getW(this, n.toDouble()) * layoutScale;

  /// Scaled height %.
  double scaleH(num n) =>
      SizeUtils.getH(this, n.toDouble()) * layoutScale;
}
