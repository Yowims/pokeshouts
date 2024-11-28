import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_scale_event.dart';
part 'change_scale_state.dart';

class ChangeScaleBloc extends Bloc<ChangeScaleEvent, ChangeScaleState> {
  ChangeScaleBloc() : super(const ChangeScaleStateInitial(1)) {
    on<ChangeScaleTriggerEvent>((event, emit) => const ChangeScaleStateInitial(0.95));
    on<ChangeScaleDefaultEvent>((event, emit) => const ChangeScaleStateInitial(1));
  }
}
