import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';

part 'answer_picked_event.dart';
part 'answer_picked_state.dart';

class AnswerPickedBloc extends Bloc<AnswerPickedEvent, AnswerPickedState> {
  final PokemonLoadedBloc pokemonLoadedBloc;
  AnswerPickedBloc(this.pokemonLoadedBloc) : super(AnswerPickedInitial()) {
    on<OnRightAnswerPickedEvent>((event, emit) {
      score = event.score + 50;
      emit(AnswerGoodPickState());
      pokemonLoadedBloc.add(OnPokemonLoadedRequestEvent());
      Future.delayed(const Duration(milliseconds: 200), () {
        add(const OnResetAnswerPickedEvent());
      });
    });
    on<OnWrongAnswerPickedEvent>((event, emit) {
      emit(AnswerBadPickState());
      Future.delayed(const Duration(milliseconds: 200), () => add(const OnResetAnswerPickedEvent()));
    });
    on<OnLeaveQuizEvent>((event, emit) {
      score = 0;
      emit(AnswerPickedInitial());
    });
    on<OnResetAnswerPickedEvent>(((event, emit) {
      emit(AnswerPickedInitial());
    }));
  }

  int score = 0;
}
