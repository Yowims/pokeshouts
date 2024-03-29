import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Controllers/gameplay_controller.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';
import 'package:pokeshouts/Views/Helpers/design_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';

class EasyModePage extends StatefulWidget {
  const EasyModePage({Key? key}) : super(key: key);

  @override
  State<EasyModePage> createState() => _EasyModePageState();
}

class _EasyModePageState extends State<EasyModePage> {
  int score = 0;

  AudioPlayer audioPlugin = AudioPlayer();

  Map<int, Pokemon> pokemonChoices = {};
  String pokemonShout = "";
  int goodAnswerIndex = 0;

  bool isLoading = false;

  Future getFileInfo() async {
    setState(() {
      isLoading = true;
    });
    // On définit les 4 cases du choix de Pokémon
    for (var i = 0; i < 4; i++) {
      Pokemon pkmn = Pokemon.empty();
      var randomPokemonIndex = Random().nextInt(649) + 1; // De 1 à 649

      // Si l'un de mes éléments dans le tableau des Pokémon a le même index que celui défini aléatoirement,
      // alors on relance l'aléatoire pour récupérer un autre index et ce jusqu'à ce qu'il soit différent
      // de toutes les entrées existantes dans la liste déjà récupérée
      while (pokemonChoices.entries.any((element) => element.value.index == randomPokemonIndex)) {
        randomPokemonIndex = Random().nextInt(649) + 1;
      }
      var randomPokemon = PokedexHelper.pokedex[randomPokemonIndex]!;

      // On récupère les infos du pokémon depuis Poképédia
      List<String> firstSearch = await ApiController().searchStringsInHtml("https://www.pokepedia.fr/$randomPokemon");
      try {
        pkmn.index = randomPokemonIndex;
        pkmn.name = randomPokemon;
        pkmn.imageUrl = firstSearch.firstWhere((element) => element.contains(".png"));
        pkmn.shoutUrl = firstSearch.firstWhere((element) => element.contains(".ogg"));
      } catch (error) {
        var urlFormatted = randomPokemon.replaceAll(r" ", "_");
        List<String> secondSearch = await ApiController().searchStringsInHtml("https://www.pokepedia.fr/$urlFormatted");
        pkmn.index = randomPokemonIndex;
        pkmn.name = randomPokemon;
        pkmn.imageUrl = secondSearch.firstWhere((element) => element.contains(".png"));
        pkmn.shoutUrl = secondSearch.firstWhere((element) => element.contains(".ogg"));
      }

      pokemonChoices.addAll({i: pkmn});
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getFileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      Future.delayed(const Duration(seconds: 1), () async {
        await audioPlugin.stop();
        await audioPlugin.setUrl("https://$pokemonShout");
        await audioPlugin.play();
        await audioPlugin.stop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.easy_mode, style: DesignHelper.titleStyle()),
      ),
      body: isLoading
          ? const WaitingIndicator()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Score: $score pts"),
                  GestureDetector(
                    onTap: () async {
                      if (!audioPlugin.playing) {
                        await audioPlugin.setUrl("https://$pokemonShout");
                        await audioPlugin.play();
                        await audioPlugin.stop();
                      }
                    },
                    child: Image.asset("assets/images/pokeball.png", width: MediaQuery.of(context).size.width * 0.6),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (goodAnswerIndex == index) {
                            // Si le joueur tape sur la bonne case, on affiche une model d'info et on passe à la manche suivante
                            GameplayController.win(50, context, () {
                              Navigator.of(context).pop();
                              setState(() {
                                score += 50;
                                getFileInfo();
                              });
                            });
                          } else {
                            // Sinon on l'informe qu'il s'est trompé et on reste sur cette manche
                            GameplayController.lose(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.height * 0.2,
                            child: FadeInImage.assetNetwork(placeholder: "assets/images/waiting.gif", image: pokemonChoices[index]!.imageUrl),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
    );
  }
}
