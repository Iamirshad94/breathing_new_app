import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_utils.dart';

class CycleIndicator extends StatelessWidget {
  const CycleIndicator({
    required this.currentCycle,
    required this.totalCycles,
    required this.elapsedSeconds,
    required this.totalSessionSeconds,
    required this.isDark,
    super.key,
  });

  final int currentCycle;
  final int totalCycles;
  final int elapsedSeconds;
  final int totalSessionSeconds;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: isDark ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
      fontSize: context.getSp(15),
    );
    final progress = totalSessionSeconds > 0
        ? (elapsedSeconds / totalSessionSeconds).clamp(0.0, 1.0)
        : 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.getW(42),
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(context.getSp(12)),
            minHeight: 6.0,
            value: progress,
            backgroundColor: isDark ? Colors.white24 : AppColors.lightSurface,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.progressBarFillDark : AppColors.progressBarFill,
            ),
          ),
        ),
        SizedBox(height: context.spacingSm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cycle ', style: style),
            Text('$currentCycle', style: style?.copyWith(fontWeight: FontWeight.w600)),
            Text(' of $totalCycles', style: style),
          ],
        ),
      ],
    );
  }
}
