import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/breathing_session.dart';
import '../../domain/entities/session_config.dart';
import '../../domain/usecases/start_session_usecase.dart';
import 'breathing_event.dart';
import 'breathing_state.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  BreathingBloc({
    StartSessionUseCase? startSessionUseCase,
  })  : _startSession = startSessionUseCase ?? StartSessionUseCase(),
        super(BreathingInitial()) {
    on<StartSession>(_onStartSession);
    on<NextPhase>(_onNextPhase);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<TickSecond>(_onTickSecond);
    on<CompleteSession>(_onCompleteSession);
  }

  final StartSessionUseCase _startSession;
  SessionConfig? _lastConfig;

  void _onStartSession(StartSession event, Emitter<BreathingState> emit) {
    final config = event.config ?? _lastConfig;
    if (config == null) return;
    _lastConfig = config;
    final session = _startSession(config: config);
    emit(BreathingInProgress(session));
  }

  void _onNextPhase(NextPhase event, Emitter<BreathingState> emit) {
    final s = state;
    if (s is! BreathingInProgress || s.secondsRemaining != 0) return;
    _emitNextPhase(emit, s.session);
  }

  void _onPauseSession(PauseSession event, Emitter<BreathingState> emit) {
    final s = state;
    if (s is! BreathingInProgress || s.isPaused) return;
    emit(BreathingInProgress(BreathingSession(
      phase: s.phase,
      secondsRemaining: s.secondsRemaining,
      currentCycle: s.currentCycle,
      totalCycles: s.totalCycles,
      isPaused: true,
      config: s.session.config,
      elapsedSeconds: s.session.elapsedSeconds,
    )));
  }

  void _onResumeSession(ResumeSession event, Emitter<BreathingState> emit) {
    final s = state;
    if (s is! BreathingInProgress || !s.isPaused) return;
    emit(BreathingInProgress(BreathingSession(
      phase: s.phase,
      secondsRemaining: s.secondsRemaining,
      currentCycle: s.currentCycle,
      totalCycles: s.totalCycles,
      isPaused: false,
      config: s.session.config,
      elapsedSeconds: s.session.elapsedSeconds,
    )));
  }

  void _onTickSecond(TickSecond event, Emitter<BreathingState> emit) {
    final s = state;
    if (s is! BreathingInProgress) return;
    if (s.isPaused) return;
    if (s.secondsRemaining > 0) {
      emit(BreathingInProgress(BreathingSession(
        phase: s.phase,
        secondsRemaining: s.secondsRemaining - 1,
        currentCycle: s.currentCycle,
        totalCycles: s.totalCycles,
        isPaused: false,
        config: s.session.config,
        elapsedSeconds: s.session.elapsedSeconds + 1,
      )));
      return;
    }
    _emitNextPhase(emit, s.session);
  }

  void _emitNextPhase(Emitter<BreathingState> emit, BreathingSession session) {
    final c = session.config;
    switch (session.phase) {
      case BreathingPhase.getReady:
        _emit(emit, session, BreathingPhase.breatheIn, c.breatheInSeconds);
        break;
      case BreathingPhase.breatheIn:
        _emit(emit, session, BreathingPhase.holdIn, c.holdInSeconds);
        break;
      case BreathingPhase.holdIn:
        _emit(emit, session, BreathingPhase.breatheOut, c.breatheOutSeconds);
        break;
      case BreathingPhase.breatheOut:
        _emit(emit, session, BreathingPhase.holdOut, c.holdOutSeconds);
        break;
      case BreathingPhase.holdOut:
        if (session.currentCycle < session.totalCycles) {
          _emit(emit, session, BreathingPhase.breatheIn, c.breatheInSeconds,
              nextCycle: session.currentCycle + 1);
        } else {
          emit(BreathingComplete(
              session.elapsedSeconds, session.config));
        }
        break;
    }
  }

  void _emit(
    Emitter<BreathingState> emit,
    BreathingSession session,
    BreathingPhase nextPhase,
    int nextSeconds, {
    int? nextCycle,
  }) {
    emit(BreathingInProgress(BreathingSession(
      phase: nextPhase,
      secondsRemaining: nextSeconds,
      currentCycle: nextCycle ?? session.currentCycle,
      totalCycles: session.totalCycles,
      isPaused: false,
      config: session.config,
      elapsedSeconds: session.elapsedSeconds,
    )));
  }

  void _onCompleteSession(CompleteSession event, Emitter<BreathingState> emit) {
    final s = state;
    if (s is BreathingInProgress) {
      emit(BreathingComplete(s.session.elapsedSeconds, s.session.config));
    }
  }
}
