import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'round_timer_event.dart';
part 'round_timer_state.dart';

class RoundTimerBloc extends Bloc<RoundTimerEvent, RoundTimerState> {
  RoundTimerBloc() : super(const RoundTimerStateInitial(60)) {
    on<RoundTimerProgressEvent>((event, emit) {
      emit(RoundTimerStateInitial(event.newValue));
    });
  }
}
