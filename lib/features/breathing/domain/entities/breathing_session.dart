import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums.dart';
import 'session_config.dart';

class BreathingSession extends Equatable {
  const BreathingSession({
    required this.phase,
    required this.secondsRemaining,
    required this.currentCycle,
    required this.totalCycles,
    required this.isPaused,
    required this.config,
    this.elapsedSeconds = 0,
  });

  final BreathingPhase phase;
  final int secondsRemaining;
  final int currentCycle;
  final int totalCycles;
  final bool isPaused;
  final SessionConfig config;
  final int elapsedSeconds;

  int get totalSessionSeconds => config.totalSessionSeconds;
  int get phaseDurationSeconds => _phaseDuration(phase, config);

  static int _phaseDuration(BreathingPhase phase, SessionConfig config) {
    switch (phase) {
      case BreathingPhase.getReady:
        return SessionConfig.getReadySeconds;
      case BreathingPhase.breatheIn:
        return config.breatheInSeconds;
      case BreathingPhase.holdIn:
        return config.holdInSeconds;
      case BreathingPhase.breatheOut:
        return config.breatheOutSeconds;
      case BreathingPhase.holdOut:
        return config.holdOutSeconds;
    }
  }

  int phaseDurationSecondsFor(BreathingPhase p) => _phaseDuration(p, config);

  @override
  List<Object?> get props => [
        phase,
        secondsRemaining,
        currentCycle,
        totalCycles,
        isPaused,
        config,
        elapsedSeconds,
      ];
}
