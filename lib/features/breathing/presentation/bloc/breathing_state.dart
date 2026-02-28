import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/breathing_session.dart';
import '../../domain/entities/session_config.dart';

sealed class BreathingState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class BreathingInitial extends BreathingState {}

final class BreathingInProgress extends BreathingState {
  BreathingInProgress(this.session);

  final BreathingSession session;

  BreathingPhase get phase => session.phase;
  int get secondsRemaining => session.secondsRemaining;
  int get currentCycle => session.currentCycle;
  int get totalCycles => session.totalCycles;
  bool get isPaused => session.isPaused;
  int get elapsedSeconds => session.elapsedSeconds;
  int get totalSessionSeconds => session.totalSessionSeconds;
  int get phaseDurationSeconds => session.phaseDurationSeconds;

  @override
  List<Object?> get props => [session];
}

final class BreathingComplete extends BreathingState {
  BreathingComplete(this.totalDurationSeconds, this.config);

  final int totalDurationSeconds;
  final SessionConfig config;

  @override
  List<Object?> get props => [totalDurationSeconds, config];
}
