import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Controllers/gameplay_controller.dart';
import 'package:pokeshouts/Models/pick_pokemon_result.dart';

part 'pokemon_loaded_event.dart';
part 'pokemon_loaded_state.dart';

class PokemonLoadedBloc extends Bloc<PokemonLoadedEvent, PokemonLoadedState> {
  PokemonLoadedBloc() : super(PokemonLoadedStateInitial(PickPokemonResult([], 0, ""))) {
    on<OnPokemonLoadedRequestEvent>((event, emit) async {
      // On lance les appels vers Poképédia pour récupérer nos pokémons
      PickPokemonResult result = await GameplayController.pickPokemons();
      // Et une fois qu'on a nos pokémons on les renvoie à la vue via un emit pour envoyer tout ça à la vuie et déclencher la manche
      emit(PokemonLoadedStateInitial(result));
    });
  }
}
