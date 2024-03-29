import 'package:pokeshouts/Models/pokemon.dart';

class PickPokemonResult {
  Map<int, Pokemon> pokemonChoices;
  int goodAnswerIndex;
  String pokemonShout;

  PickPokemonResult(this.pokemonChoices, this.goodAnswerIndex, this.pokemonShout);
}
