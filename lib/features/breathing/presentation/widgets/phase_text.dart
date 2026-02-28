import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/size_utils.dart';

class PhaseText extends StatelessWidget {
  const PhaseText({
    required this.phase,
    required this.isDark,
    super.key,
  });

  final BreathingPhase phase;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : theme.colorScheme.onSurface,
      fontSize: context.getSp(20),
    );
    final secondaryStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
      fontSize: context.getSp(14),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_label(phase), style: primaryStyle),
        SizedBox(height: context.spacingXs),
        Text(_sublabel(phase), style: secondaryStyle),
      ],
    );
  }

  String _label(BreathingPhase p) {
    switch (p) {
      case BreathingPhase.getReady:
        return 'Get ready';
      case BreathingPhase.breatheIn:
        return 'Breathe in';
      case BreathingPhase.holdIn:
        return 'Hold gently';
      case BreathingPhase.breatheOut:
        return 'Breathe out';
      case BreathingPhase.holdOut:
        return 'Hold softly';
    }
  }

  String _sublabel(BreathingPhase p) {
    switch (p) {
      case BreathingPhase.getReady:
        return 'Get going on your breathing session';
      case BreathingPhase.breatheIn:
        return 'nice and slow';
      case BreathingPhase.holdIn:
        return 'just be here';
      case BreathingPhase.breatheOut:
        return 'nice and slow';
      case BreathingPhase.holdOut:
        return 'just be here';
    }
  }
}
