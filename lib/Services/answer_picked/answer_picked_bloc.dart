import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeshouts/Models/pick_answer_model.dart';

part 'answer_picked_event.dart';
part 'answer_picked_state.dart';

class AnswerPickedBloc extends Bloc<AnswerPickedEvent, AnswerPickedState> {
  AnswerPickedBloc() : super(const AnswerPickedInitial(PickAnswerModel(null, 0))) {
    on<OnRightAnswerPickedEvent>((event, emit) {
      emit(const AnswerPickedInitial(PickAnswerModel(true, 50)));
    });
    on<OnWrongAnswerPickedEvent>((event, emit) {
      emit(const AnswerPickedInitial(PickAnswerModel(false, 0)));
    });
    on<OnResetAnswerPickedEvent>((event, emit) {
      emit(const AnswerPickedInitial(PickAnswerModel(null, 0)));
    });
  }
}
