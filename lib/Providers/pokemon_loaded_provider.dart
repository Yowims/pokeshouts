import 'package:flutter/material.dart';
import 'package:pokeshouts/Models/pokemon.dart';

typedef PokemonLoadedChangeCallback = void Function(Map<int, Pokemon> pokemonImagesLoaded);

class PokemonLoadedProvider extends ChangeNotifier {
  PokemonLoadedChangeCallback? onPokemonImageLoaded;
  Map<int, Pokemon> _pokemonImagesLoaded = {0: Pokemon.empty(), 1: Pokemon.empty(), 2: Pokemon.empty(), 3: Pokemon.empty()};
  Map<int, Pokemon> get getPokemonImagesLoaded => _pokemonImagesLoaded;
  set setPokemonImagesLoaded(Map<int, Pokemon> pokemonImagesLoaded) {
    _pokemonImagesLoaded = pokemonImagesLoaded;
    notifyListeners();
    if (_pokemonImagesLoaded.values.every((element) => element.index != 0)) {
      onPokemonImageLoaded?.call(_pokemonImagesLoaded);
    }
  }
}
