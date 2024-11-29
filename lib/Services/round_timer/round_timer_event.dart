part of 'round_timer_bloc.dart';

sealed class RoundTimerEvent extends Equatable {
  const RoundTimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimerEvent extends RoundTimerEvent {
  final int duration; // Duration in seconds
  const StartTimerEvent(this.duration);

  @override
  List<Object> get props => [duration];
}

class TickEvent extends RoundTimerEvent {
  final int remainingTime;
  final int totalDuration;

  const TickEvent(this.remainingTime, this.totalDuration);

  @override
  List<Object> get props => [remainingTime, totalDuration];
}

class StopTimerEvent extends RoundTimerEvent {}
