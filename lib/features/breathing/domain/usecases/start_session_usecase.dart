import '../../../../core/utils/enums.dart';
import '../entities/breathing_session.dart';
import '../entities/session_config.dart';

class StartSessionUseCase {
  BreathingSession call({required SessionConfig config}) {
    return BreathingSession(
      phase: BreathingPhase.getReady,
      secondsRemaining: SessionConfig.getReadySeconds,
      currentCycle: 1,
      totalCycles: config.cycles,
      isPaused: false,
      config: config,
    );
  }
}
