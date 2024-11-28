part of 'pokemon_loaded_bloc.dart';

sealed class PokemonLoadedState extends Equatable {
  final PickPokemonResult result;

  const PokemonLoadedState(this.result);

  @override
  List<Object?> get props => [
        result,
      ];
}

class PokemonLoadedStateInitial extends PokemonLoadedState {
  const PokemonLoadedStateInitial(super.result);
}
