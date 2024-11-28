part of 'pokemon_loaded_bloc.dart';

sealed class PokemonLoadedEvent extends Equatable {
  const PokemonLoadedEvent();

  @override
  List<Object?> get props => [];
}

class OnPokemonLoadedRequestEvent extends PokemonLoadedEvent {}
