import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Controllers/gameplay_controller.dart';
import 'package:pokeshouts/Models/pick_pokemon_result.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:pokeshouts/Views/Components/pokemon_choice_grid.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';
import 'package:pokeshouts/Views/Helpers/design_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

    PickPokemonResult result = await GameplayController.pickPokemons(pokemonChoices, goodAnswerIndex, pokemonShout);
    pokemonChoices = result.pokemonChoices;
    goodAnswerIndex = result.goodAnswerIndex;
    pokemonShout = result.pokemonShout;

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final pokemonImagesLoadedProvider = context.watch<PokemonLoadedProvider>();
    pokemonImagesLoadedProvider.onPokemonImageLoaded = (pokemonImagesLoaded) {
      if (pokemonImagesLoaded.values.every((element) => element == true)) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          await audioPlugin.stop();
          await audioPlugin.setUrl("https://$pokemonShout");
          await audioPlugin.play();
          await audioPlugin.stop();
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
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
                  PokemonChoiceGrid(
                      pokemonChoices: pokemonChoices,
                      onChoiceMade: (index) {
                        if (goodAnswerIndex == index) {
                          // Si le joueur tape sur la bonne case, on affiche une modal d'info et on passe à la manche suivante
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
                      })
                ],
              ),
            ),
    );
  }
}
