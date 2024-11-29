import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'round_timer_event.dart';
part 'round_timer_state.dart';

class RoundTimerBloc extends Bloc<RoundTimerEvent, RoundTimerState> {
  RoundTimerBloc() : super(TimerInitial()) {
    on<StartTimerEvent>(_onStartTimer);
    on<TickEvent>(_onTick);
    on<StopTimerEvent>(_onStopTimer);
  }

  Timer? _timer; // Use to handle periodic ticks

  void _onStartTimer(StartTimerEvent event, Emitter<RoundTimerState> emit) {
    _timer?.cancel(); // Cancel any existing timer
    final totalDuration = event.duration;
    int remainingTime = totalDuration;

    // Emit the first state with full progress
    emit(TimerRunning(remainingTime, 1.0));

    // Start ticking every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        add(TickEvent(remainingTime, totalDuration));
      } else {
        add(StopTimerEvent());
      }
    });
  }

  void _onTick(TickEvent event, Emitter<RoundTimerState> emit) {
    emit(TimerRunning(
      event.remainingTime,
      event.remainingTime / event.totalDuration, // Progress as a fraction
    ));
  }

  void _onStopTimer(StopTimerEvent event, Emitter<RoundTimerState> emit) {
    _timer?.cancel();
    emit(TimerComplete());
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Cleanup the timer on bloc disposal
    return super.close();
  }
}
