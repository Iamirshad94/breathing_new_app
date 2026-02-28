import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/asset_paths.dart';
import '../../../../core/utils/size_utils.dart';

class CloudLayer extends StatelessWidget {
  const CloudLayer({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isWeb = context.screenWidth >= SizeUtils.breakpoint;
    if (isWeb) {
      return _buildWeb(context);
    }
    return _buildMobile(context);
  }

  Widget _buildMobile(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    final cloudHeight = context.getH(14);

    if (isDark) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(AssetPaths.darkBg, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: SvgPicture.asset(AssetPaths.stars, fit: BoxFit.cover),
          ),
          _positioned(context, path: AssetPaths.darkSmallCloud1, top: h * 0.15, width: w * 0.8, left: w * 0.2, height: cloudHeight),
          _positioned(context, path: AssetPaths.darkCloud1, bottom: h * 0.35, left: w * 0.15, height: cloudHeight, width: w * 0.42),
          _positioned(context, path: AssetPaths.darkCloud2, bottom: h * 0.44, left: w * 0.15, height: cloudHeight, width: w * 0.42),
          _positioned(context, path: AssetPaths.darkCloudMedium, bottom: h * 0.14, height: cloudHeight, width: w * 1),
        ],
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: SvgPicture.asset(AssetPaths.lightBackground, fit: BoxFit.cover),
        ),
        _positioned(context, path: AssetPaths.mediumBottomCloud, bottom: h * 0.08, height: cloudHeight),
        _positioned(context, path: AssetPaths.bottomCloud, bottom: h * 0.26, left: w * 0.08, height: cloudHeight),
        _positioned(context, path: AssetPaths.cloud2, top: h * 0.02, height: cloudHeight),
        _positioned(context, path: AssetPaths.smallCloud, bottom: h * 0.67, height: cloudHeight),
        _positioned(context, path: AssetPaths.cloud3, bottom: h * 0.66, height: cloudHeight),
        _positioned(context, path: AssetPaths.bigCloud, bottom: h * 0.50, right: w * 0.32, height: cloudHeight),
        _positioned(context, path: AssetPaths.cloud1, top: h * 0.12, height: cloudHeight, width: w * 0.6),
      ],
    );
  }

  Widget _buildWeb(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    final cloudHeight = context.getH(12);

    if (isDark) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(AssetPaths.darkBg, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: SvgPicture.asset(AssetPaths.stars, fit: BoxFit.cover),
          ),
          _positioned(context, path: AssetPaths.darkSmallCloud1, top: h * 0.08, left: w * 0.1, width: w * 0.35, height: cloudHeight),
          _positioned(context, path: AssetPaths.darkCloud1, bottom: h * 0.28, left: w * 0.05, height: cloudHeight, width: w * 0.3),
          _positioned(context, path: AssetPaths.darkCloud2, bottom: h * 0.38, right: w * 0.05, height: cloudHeight, width: w * 0.32),
          _positioned(context, path: AssetPaths.darkCloudMedium, bottom: 0, height: cloudHeight, width: w * 1),
        ],
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: SvgPicture.asset(AssetPaths.lightBackground, fit: BoxFit.cover),
        ),
        _positioned(context, path: AssetPaths.cloud1, top: h * 0.05, width: w * 0.5),
        _positioned(context, path: AssetPaths.bottomCloud, top: h * 0.02, right: w * 0.01, height: cloudHeight, width: w * 0.4),
        _positioned(context, path: AssetPaths.cloud3, top: h * 0.4, left: w * 0.05),
        _positioned(context, path: AssetPaths.smallCloud, bottom: h * 0.55, left: w * 0.15, height: cloudHeight, width: w * 0.2),
        _positioned(context, path: AssetPaths.cloud3, top: h * 0.32, right: w * 0.05, height: cloudHeight, width: w * 0.22),
        _positioned(context, path: AssetPaths.bigCloud, bottom: h * 0.42, left: w * 0.35, height: cloudHeight, width: w * 0.28),
        _positioned(context, path: AssetPaths.bottomCloud, bottom: h * 0.04, left: w * 0.01, height: cloudHeight, width: w * 0.4),
        _positioned(context, path: AssetPaths.bottomCloud, bottom: h * 0.12, left: w * 0.08, height: cloudHeight, width: w * 0.4),
      ],
    );
  }

  Widget _positioned(
    BuildContext context, {
    required String path,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left ?? (right == null && width == null ? 0 : null),
      right: right ?? (left == null && width == null ? 0 : null),
      top: top,
      bottom: bottom,
      width: width,
      height: height,
      child: SvgPicture.asset(path, fit: BoxFit.fill),
    );
  }
}
