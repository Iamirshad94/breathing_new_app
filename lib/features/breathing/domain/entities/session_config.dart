import 'package:equatable/equatable.dart';

class SessionConfig extends Equatable {
  const SessionConfig({
    required this.cycles,
    required this.breatheInSeconds,
    required this.holdInSeconds,
    required this.breatheOutSeconds,
    required this.holdOutSeconds,
    required this.soundOn,
  });

  final int cycles;
  final int breatheInSeconds;
  final int holdInSeconds;
  final int breatheOutSeconds;
  final int holdOutSeconds;
  final bool soundOn;

  int get totalPhaseSecondsPerCycle =>
      breatheInSeconds + holdInSeconds + breatheOutSeconds + holdOutSeconds;

  static const int getReadySeconds = 2;

  int get totalSessionSeconds =>
      getReadySeconds + totalPhaseSecondsPerCycle * cycles;

  @override
  List<Object?> get props => [
        cycles,
        breatheInSeconds,
        holdInSeconds,
        breatheOutSeconds,
        holdOutSeconds,
        soundOn,
      ];
}
