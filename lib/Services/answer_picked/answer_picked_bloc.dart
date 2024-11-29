import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeshouts/Models/pick_answer_model.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';

part 'answer_picked_event.dart';
part 'answer_picked_state.dart';

class AnswerPickedBloc extends Bloc<AnswerPickedEvent, AnswerPickedState> {
  final PokemonLoadedBloc pokemonLoadedBloc;
  AnswerPickedBloc(this.pokemonLoadedBloc) : super(const AnswerPickedInitial(PickAnswerModel(null, 0))) {
    on<OnRightAnswerPickedEvent>((event, emit) {
      emit(AnswerPickedInitial(PickAnswerModel(true, event.score + 50)));
      pokemonLoadedBloc.add(OnPokemonLoadedRequestEvent());
      Future.delayed(const Duration(milliseconds: 200), () {
        add(OnResetAnswerPickedEvent(event.score + 50));
      });
    });
    on<OnWrongAnswerPickedEvent>((event, emit) {
      emit(AnswerPickedInitial(PickAnswerModel(false, event.score)));
      Future.delayed(const Duration(milliseconds: 200), () {
        add(OnResetAnswerPickedEvent(event.score));
      });
    });
    on<OnResetAnswerPickedEvent>((event, emit) {
      emit(AnswerPickedInitial(PickAnswerModel(null, event.score)));
    });
  }
}
