part of 'round_timer_bloc.dart';

sealed class RoundTimerState extends Equatable {
  const RoundTimerState();

  @override
  List<Object> get props => [];
}

class TimerInitial extends RoundTimerState {}

class TimerRunning extends RoundTimerState {
  final int remainingTime; // Remaining time in seconds
  final double progress; // Progress for CircularProgressIndicator (0.0 to 1.0)

  const TimerRunning(this.remainingTime, this.progress);

  @override
  List<Object> get props => [remainingTime, progress];
}

class TimerComplete extends RoundTimerState {}
