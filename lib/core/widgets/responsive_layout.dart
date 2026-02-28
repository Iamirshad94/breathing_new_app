import 'package:flutter/material.dart';

import '../utils/size_utils.dart';

/// Picks mobile or web layout by [SizeUtils.breakpoint].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    required this.web,
    super.key,
  });

  final Widget mobile;
  final Widget web;

  static bool isMobile(BuildContext context) =>
      SizeUtils.screenWidth(context) < SizeUtils.breakpoint;

  static bool isWeb(BuildContext context) =>
      SizeUtils.screenWidth(context) >= SizeUtils.breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < SizeUtils.breakpoint) {
          return mobile;
        }
        return web;
      },
    );
  }
}
