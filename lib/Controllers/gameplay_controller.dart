import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Models/pick_pokemon_result.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';
import 'package:provider/provider.dart';

class GameplayController {
  static final ApiController apiController = ApiController();

  static Future<PickPokemonResult> pickPokemons(BuildContext context, Map<int, Pokemon> pokemonChoices, int goodAnswerIndex, String pokemonShout) async {
    // On définit les 4 cases du choix de Pokémon
    for (var i = 0; i < 4; i++) {
      Pokemon pkmn = Pokemon.empty();

      // On itère dans une boucle infinie car il existe quelques entrées dans Poképédia (ex: Shifours et Wushours) qui n'ont pas de cri sur leur page
      while (true) {
        var randomPokemonIndex = Random().nextInt(PokedexHelper.pokedex.length) + 1; // De 1 à 1025

        // Si l'un de mes éléments dans le tableau des Pokémon a le même index que celui défini aléatoirement,
        // alors on relance l'aléatoire pour récupérer un autre index et ce jusqu'à ce qu'il soit différent
        // de toutes les entrées existantes dans la liste déjà récupérée
        while (pokemonChoices.entries.any((element) => element.value.index == randomPokemonIndex)) {
          randomPokemonIndex = Random().nextInt(PokedexHelper.pokedex.length) + 1;
        }

        // On récupère les infos du pokémon depuis MediaWiki
        pkmn = await apiController.getPokemonInfosAsync(randomPokemonIndex);

        // Si l'élément recherché ne contient pas de cri ou d'image, alors on repart dans la boucle pour relancer une nouvelle recherche
        if (pkmn.imageUrl == "" || pkmn.shoutUrl == "") {
          continue;
        }

        pokemonChoices.addAll({i: pkmn});
        break;
      }
    }

    // Et là, parmi les 4 choix, on choisit la bonne réponse
    int goodChoice = Random().nextInt(100) + 1; // De 1 à 100

    if (1 <= goodChoice && goodChoice <= 25) // De 1 à 25 : Case 1
    {
      goodAnswerIndex = 0;
      pokemonShout = pokemonChoices[0]!.shoutUrl;
    } else if (26 <= goodChoice && goodChoice <= 50) // De 26 à 50 : Case 2
    {
      goodAnswerIndex = 1;
      pokemonShout = pokemonChoices[1]!.shoutUrl;
    } else if (51 <= goodChoice && goodChoice <= 75) // De 51 à 75 : Case 3
    {
      goodAnswerIndex = 2;
      pokemonShout = pokemonChoices[2]!.shoutUrl;
    } else // De 76 à 100 : Case 4
    {
      goodAnswerIndex = 3;
      pokemonShout = pokemonChoices[3]!.shoutUrl;
    }

    if (context.mounted) {
      PokemonLoadedProvider pokemonLoadedProvider = Provider.of<PokemonLoadedProvider>(context, listen: false);
      pokemonLoadedProvider.setPokemonImagesLoaded = pokemonChoices;
    }

    return PickPokemonResult(pokemonChoices, goodAnswerIndex, pokemonShout);
  }
}
