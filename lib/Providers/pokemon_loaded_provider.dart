import 'package:flutter/material.dart';

typedef PokemonLoadedChangeCallback = void Function(Map<int, bool> pokemonImagesLoaded);

class PokemonLoadedProvider extends ChangeNotifier {
  PokemonLoadedChangeCallback? onPokemonImageLoaded;
  Map<int, bool> _pokemonImagesLoaded = {0: false, 1: false, 2: false, 3: false};
  Map<int, bool> get getPokemonImagesLoaded => _pokemonImagesLoaded;
  set setPokemonImagesLoaded(Map<int, bool> pokemonImagesLoaded) {
    _pokemonImagesLoaded = pokemonImagesLoaded;
    onPokemonImageLoaded?.call(_pokemonImagesLoaded);
  }
}
