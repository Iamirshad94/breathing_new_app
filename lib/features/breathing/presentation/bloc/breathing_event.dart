import 'package:equatable/equatable.dart';

import '../../domain/entities/session_config.dart';

sealed class BreathingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class StartSession extends BreathingEvent {
  StartSession({this.config});
  final SessionConfig? config;
}

final class NextPhase extends BreathingEvent {}

final class PauseSession extends BreathingEvent {}

final class ResumeSession extends BreathingEvent {}

final class TickSecond extends BreathingEvent {}

final class CompleteSession extends BreathingEvent {}
