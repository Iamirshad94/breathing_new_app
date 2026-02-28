import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_utils.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({
    required this.isPaused,
    required this.isDark,
    required this.onPressed,
    super.key,
  });

  final bool isPaused;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkPauseButton : AppColors.lightPauseButton,
      borderRadius: BorderRadius.circular(context.getSp(28)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.getSp(28)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.getSp(28),
            vertical: context.getSp(14),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.getSp(28)),
            color: isDark ? AppColors.darkBubble : AppColors.lightBubble,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPaused ? Icons.play_arrow : Icons.pause,
                color: isDark ? Colors.white : Colors.black,
                size: context.getSp(28),
              ),
              SizedBox(width: context.getSp(8)),
              Text(
                isPaused ? 'Resume' : 'Pause',
                style: TextStyle(
                  fontSize: context.getSp(16),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
