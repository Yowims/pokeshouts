part of 'round_timer_bloc.dart';

abstract class RoundTimerEvent extends Equatable {
  const RoundTimerEvent();
}

class RoundTimerProgressEvent extends RoundTimerEvent {
  final double newValue;

  const RoundTimerProgressEvent(this.newValue);

  @override
  List<Object?> get props => [
        newValue,
      ];
}
