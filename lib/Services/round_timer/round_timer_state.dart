part of 'round_timer_bloc.dart';

sealed class RoundTimerState extends Equatable {
  final double newValue;
  const RoundTimerState(this.newValue);

  @override
  List<Object> get props => [
        newValue,
      ];
}

class RoundTimerStateInitial extends RoundTimerState {
  const RoundTimerStateInitial(super.newValue);
}
