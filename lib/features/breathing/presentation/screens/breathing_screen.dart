import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/dark_mode_scope.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/utils/chime_player.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/breathing_bloc.dart';
import '../bloc/breathing_event.dart';
import '../bloc/breathing_state.dart';
import '../widgets/breathing_bubble.dart';
import '../widgets/cloud_layer.dart';
import '../widgets/cycle_indicator.dart';
import '../widgets/pause_button.dart';
import '../widgets/phase_text.dart';
import 'pace_screen.dart';
import 'result_screen.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  Timer? _timer;
  bool _timerRunning = false;
  int _lastChimeCycle = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(BuildContext context) {
    _timer?.cancel();
    _timerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!context.mounted) return;
      context.read<BreathingBloc>().add(TickSecond());
    });
  }

  void _maybePlayChime(BreathingInProgress state) {
    if (!state.session.config.soundOn) return;
    if (state.phase != BreathingPhase.breatheIn) return;
    if (state.currentCycle <= _lastChimeCycle) return;
    _lastChimeCycle = state.currentCycle;
    ChimePlayer.play().catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BreathingBloc, BreathingState>(
      listener: (context, state) {
        if (state is BreathingInProgress) {
          if (!state.isPaused) {
            _startTimer(context);
            _maybePlayChime(state);
          } else {
            _timer?.cancel();
            _timerRunning = false;
          }
        } else if (state is BreathingComplete) {
          _timer?.cancel();
          _timerRunning = false;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => ResultScreen(
                totalDurationSeconds: state.totalDurationSeconds,
                config: state.config,
                isDark: DarkModeScope.of(context).isDark,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CloudLayer(isDark: DarkModeScope.of(context).isDark),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.getW(2), vertical: context.getH(0.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                builder: (_) => const PaceScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.close,
                            color: DarkModeScope.of(context).isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: DarkModeScope.of(context).toggleDark,
                          icon: Icon(
                            DarkModeScope.of(context).isDark ? Icons.light_mode : Icons.dark_mode,
                            color: DarkModeScope.of(context).isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<BreathingBloc, BreathingState>(
                    builder: (context, state) {
                      if (state is BreathingInitial) {
                        return _buildStart(context);
                      }
                      if (state is BreathingInProgress) {
                        if (!state.isPaused && !_timerRunning) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _startTimer(context);
                          });
                        }
                        return _buildInProgress(context, state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStart(BuildContext context) {
    final isDark = DarkModeScope.of(context).isDark;
    return ResponsiveLayout(
      mobile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.spacingLg),
          Text(
            'Ready to breathe?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
          ),
          SizedBox(height: context.spacingXl),
          FilledButton(
            onPressed: () =>
                context.read<BreathingBloc>().add(StartSession()),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkBubble : AppColors.lightBubble,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: context.getW(12), vertical: context.getH(2)),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
      web: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.spacingLg),
              Text(
                'Ready to breathe?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
              ),
              SizedBox(height: context.spacingXl),
              FilledButton(
                onPressed: () =>
                    context.read<BreathingBloc>().add(StartSession()),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkBubble : AppColors.lightBubble,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.getW(12), vertical: context.getH(2)),
                ),
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInProgress(BuildContext context, BreathingInProgress state) {
    final isDark = DarkModeScope.of(context).isDark;
    return ResponsiveLayout(
      mobile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BreathingBubble(
            phase: state.phase,
            secondsRemaining: state.secondsRemaining,
            phaseDurationSeconds: state.phaseDurationSeconds,
            isPaused: state.isPaused,
            isDark: isDark,
          ),
          SizedBox(height: context.spacingLg),
          PhaseText(phase: state.phase, isDark: isDark),
          SizedBox(height: context.getH(6)),
          PauseButton(
            isPaused: state.isPaused,
            isDark: isDark,
            onPressed: () => context.read<BreathingBloc>().add(
                  state.isPaused ? ResumeSession() : PauseSession(),
                ),
          ),
          SizedBox(height: context.spacingLg),
          CycleIndicator(
            currentCycle: state.currentCycle,
            totalCycles: state.totalCycles,
            elapsedSeconds: state.elapsedSeconds,
            totalSessionSeconds: state.totalSessionSeconds,
            isDark: isDark,
          ),
          SizedBox(height: context.spacingXl),
        ],
      ),
      web: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BreathingBubble(
                phase: state.phase,
                secondsRemaining: state.secondsRemaining,
                phaseDurationSeconds: state.phaseDurationSeconds,
                isPaused: state.isPaused,
                isDark: isDark,
              ),
              SizedBox(height: context.spacingSm),
              PhaseText(phase: state.phase, isDark: isDark),
              SizedBox(height: context.getH(6)),
              PauseButton(
                isPaused: state.isPaused,
                isDark: isDark,
                onPressed: () => context.read<BreathingBloc>().add(
                      state.isPaused ? ResumeSession() : PauseSession(),
                    ),
              ),
              SizedBox(height: context.spacingLg),
              CycleIndicator(
                currentCycle: state.currentCycle,
                totalCycles: state.totalCycles,
                elapsedSeconds: state.elapsedSeconds,
                totalSessionSeconds: state.totalSessionSeconds,
                isDark: isDark,
              ),
              SizedBox(height: context.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}
