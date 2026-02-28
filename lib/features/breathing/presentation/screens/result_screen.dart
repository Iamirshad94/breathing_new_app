import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_utils.dart';
import '../bloc/breathing_bloc.dart';
import '../bloc/breathing_event.dart';
import '../widgets/cloud_layer.dart';
import '../../../../core/widgets/layout_scope.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/session_config.dart';
import 'pace_screen.dart';
import 'breathing_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.totalDurationSeconds,
    required this.config,
    required this.isDark,
    super.key,
  });

  final int totalDurationSeconds;
  final SessionConfig config;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CloudLayer(isDark: isDark),
          SafeArea(
            child: ResponsiveLayout(
              mobile: Padding(
                padding: EdgeInsets.all(context.getW(6)),
                child: _buildContent(context),
              ),
              web: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: EdgeInsets.all(context.getW(6)),
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: context.scaleH(14),
          child: Icon(Icons.check_circle, color: Colors.green, size: context.scaleSp(80)),
        ),
        SizedBox(height: context.scaleH(1.2)),
        Text(
          'You did it!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
            fontSize: context.scaleSp(26),
          ),
        ),
        SizedBox(height: context.scaleH(1.2)),
        Text(
          'Great rounds of calm, just like that. Your mind thanks you.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
            fontSize: context.scaleSp(16),
          ),
        ),
        SizedBox(height: context.scaleH(4)),
        _buildButtonsColumn(context),
        SizedBox(height: context.scaleH(4)),
      ],
    );
  }

  Widget _buildButtonsColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _startAgainButton(context),
        SizedBox(height: context.scaleH(2)),
        _backToSetupButton(context),
      ],
    );
  }

  Widget _startAgainButton(BuildContext context) {
    final fontSize = context.scaleSp(16).clamp(12.0, 24.0);
    final iconSize = context.scaleSp(20).clamp(16.0, 28.0);
    return FilledButton.icon(
      onPressed: () {
        context.read<BreathingBloc>().add(StartSession(config: config));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const BreathingScreen(),
          ),
        );
      },
      icon: Icon(Icons.air, size: iconSize, color: Colors.white),
      iconAlignment: IconAlignment.end,
      label: Text(
        'Start again',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkBubble : AppColors.lightPrimary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: context.scaleW(context.isWeb?8:16), vertical: context.scaleH(context.isWeb?4:2)),
        minimumSize: Size(context.scaleW(context.isWeb?35:60), context.scaleH(context.isWeb?10:5)),
        maximumSize: Size(context.scaleW(context.isWeb?40:70), context.scaleH(context.isWeb?15:10)),
      ),
    );
  }

  Widget _backToSetupButton(BuildContext context) {
    final fontSize = context.scaleSp(16).clamp(12.0, 24.0);
    final iconSize = context.scaleSp(18).clamp(14.0, 24.0);
    final fgColor = isDark ? Colors.white : Colors.black;
    return FilledButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => const PaceScreen(),
          ),
          (route) => false,
        );
      },
      style: FilledButton.styleFrom(
        // fixedSize: Size(context.scaleW(25), context.scaleW(5)),
        backgroundColor: isDark ? Colors.black38 : Colors.blueGrey.withOpacity(0.2),
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(horizontal: context.scaleW(8), vertical: context.scaleH(context.isWeb?4:2)),
        minimumSize: Size(context.scaleW(context.isWeb?25:40), context.scaleH(context.isWeb?10:5)),
        maximumSize: Size(context.scaleW(context.isWeb?30:50), context.scaleH(context.isWeb?15:10)),
      ),
      child: Text(
        'Back to set up',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: fgColor,
        ),
      ),
    );
  }
}
