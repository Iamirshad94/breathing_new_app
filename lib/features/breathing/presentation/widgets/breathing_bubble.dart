import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/size_utils.dart';

class BreathingBubble extends StatefulWidget {
  const BreathingBubble({
    required this.phase,
    required this.secondsRemaining,
    required this.phaseDurationSeconds,
    required this.isPaused,
    required this.isDark,
    super.key,
  });

  final BreathingPhase phase;
  final int secondsRemaining;
  final int phaseDurationSeconds;
  final bool isPaused;
  final bool isDark;

  @override
  State<BreathingBubble> createState() => _BreathingBubbleState();
}

class _BreathingBubbleState extends State<BreathingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(BreathingBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused) {
      _controller.stop();
      return;
    }
    if (oldWidget.isPaused && !widget.isPaused) {
      _updateAnimation();
      return;
    }
    if (oldWidget.phase != widget.phase ||
        oldWidget.phaseDurationSeconds != widget.phaseDurationSeconds) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    final duration = Duration(seconds: widget.phaseDurationSeconds);
    _controller.duration = duration;
    switch (widget.phase) {
      case BreathingPhase.getReady:
        _controller.value = 0.0;
        break;
      case BreathingPhase.breatheIn:
        _controller.forward(from: 0.0);
        break;
      case BreathingPhase.holdIn:
        _controller.value = 1.0;
        break;
      case BreathingPhase.holdOut:
        _controller.value = 0.0;
        break;
      case BreathingPhase.breatheOut:
        _controller.reverse(from: 1.0);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDark ? AppColors.darkBubble.withOpacity(0.2) : AppColors.lightBubble.withOpacity(0.2);
    final w = context.screenWidth;
    final h = context.screenHeight;
    final size = w < SizeUtils.breakpoint
        ? (h * 0.32).clamp(160.0, 240.0)
        : (h * 0.36).clamp(220.0, 320.0);

    final showNumber = _shouldShowNumber();
    final numberText = _numberText();

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Container(
          width: size * _scale.value,
          height: size * _scale.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: showNumber
              ? Text(
                  numberText,
                  style: TextStyle(
                    fontSize: (size * _scale.value * 0.25).clamp(14.0, 32.0),
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black54,
                  ),
                )
              : null,
        );
      },
    );
  }

  bool _shouldShowNumber() {
    switch (widget.phase) {
      case BreathingPhase.getReady:
      case BreathingPhase.breatheIn:
      case BreathingPhase.breatheOut:
        return true;
      case BreathingPhase.holdIn:
      case BreathingPhase.holdOut:
        return false;
    }
  }

  /// Displayed second: 1 to phase duration (inclusive).
  String _numberText() {
    final elapsedInPhase =
        (widget.phaseDurationSeconds - widget.secondsRemaining)
            .clamp(0, widget.phaseDurationSeconds - 1);
    return '${elapsedInPhase + 1}';
  }
}
