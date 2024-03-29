import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Models/pick_pokemon_result.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';

class GameplayController {
  static void win(int points, BuildContext context, Function()? onPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.congrats),
          content: Text("${AppLocalizations.of(context)!.right_choice}$points pts"),
          actions: [TextButton(onPressed: onPressed, child: const Text("OK"))],
        );
      },
    );
  }

  static void lose(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.too_bad),
          content: Text(AppLocalizations.of(context)!.wrong_choice),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  static Future<PickPokemonResult> pickPokemons(Map<int, Pokemon> pokemonChoices, int goodAnswerIndex, String pokemonShout) async {
    // On définit les 4 cases du choix de Pokémon
    for (var i = 0; i < 4; i++) {
      Pokemon pkmn = Pokemon.empty();

      // On itère dans une boucle infinie car il existe quelques entrées dans Poképédia (ex: Shifours et Wushours) qui n'ont pas de cri sur leur page
      while (true) {
        var randomPokemonIndex = Random().nextInt(1025) + 1; // De 1 à 1025

        // Si l'un de mes éléments dans le tableau des Pokémon a le même index que celui défini aléatoirement,
        // alors on relance l'aléatoire pour récupérer un autre index et ce jusqu'à ce qu'il soit différent
        // de toutes les entrées existantes dans la liste déjà récupérée
        while (pokemonChoices.entries.any((element) => element.value.index == randomPokemonIndex)) {
          randomPokemonIndex = Random().nextInt(1025) + 1;
        }
        var randomPokemon = PokedexHelper.pokedex[randomPokemonIndex]!;
        var urlFormatted = randomPokemon.replaceAll(r" ", "_");
        // On récupère les infos du pokémon depuis Poképédia
        List<String> secondSearch = await ApiController().searchStringsInHtml("https://www.pokepedia.fr/$urlFormatted");
        pkmn.index = randomPokemonIndex;
        pkmn.name = randomPokemon;

        pkmn.imageUrl = secondSearch.firstWhere(
          (element) => element.contains(".png"),
          orElse: () => "",
        );
        pkmn.shoutUrl = secondSearch.firstWhere(
          (element) => element.contains(".ogg"),
          orElse: () => "",
        );

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

    return PickPokemonResult(pokemonChoices, goodAnswerIndex, pokemonShout);
  }
}
