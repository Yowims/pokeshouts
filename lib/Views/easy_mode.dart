import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Controllers/gameplay_controller.dart';
import 'package:pokeshouts/Models/pick_pokemon_result.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:pokeshouts/Providers/round_timer_provider.dart';
import 'package:pokeshouts/Views/Components/pokemon_choice_grid.dart';
import 'package:pokeshouts/Views/Components/timer_indicator.dart';
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
  bool roundFinished = false;
  bool? rightAnswer;
  bool? badAnswer;
  int score = 0;

  AudioPlayer audioPlugin = AudioPlayer();

  Map<int, Pokemon> pokemonChoices = {};
  String pokemonShout = "";
  int goodAnswerIndex = 0;
  double pokeballScale = 1;

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

  void _changeScaleDown() {
    setState(() => pokeballScale = 0.95);
  }

  void _changeScaleUp() {
    setState(() => pokeballScale = 1);
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
        Future.delayed(const Duration(milliseconds: 200), () async {
          print("---");
          await audioPlugin.stop();
          await audioPlugin.setUrl(pokemonShout);
          await audioPlugin.play();
          await audioPlugin.stop();
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        RoundTimerProvider roundTimerProvider = Provider.of<RoundTimerProvider>(context, listen: false);
        roundTimerProvider.setTimer = 60;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.easy_mode, style: DesignHelper.titleStyle()),
        ),
        body: isLoading
            ? const WaitingIndicator()
            : Stack(
                children: [
                  Positioned(
                    top: 5,
                    right: 5,
                    child: TimerIndicator(
                      seconds: 600,
                      onTimerFinished: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Temps écoulé !"),
                              content: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Le temps imparti pour cette manche est écoulé."),
                                    Text("Vous avez marqué $score points."),
                                    const Text("Félicitations !"),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                                  },
                                  child: const Text("OK"),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Score: $score pts"),
                        GestureDetector(
                          onTap: () async {
                            _changeScaleDown();
                            if (!audioPlugin.playing) {
                              await audioPlugin.stop();
                            }
                            await audioPlugin.setUrl(pokemonShout);
                            await audioPlugin.play();
                            await audioPlugin.stop();
                            _changeScaleUp();
                          },
                          child: AnimatedScale(
                            scale: pokeballScale,
                            duration: const Duration(milliseconds: 200),
                            child: Image.asset(
                              "assets/images/pokeball.png",
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            PokemonChoiceGrid(
                              pokemonChoices: pokemonChoices,
                              onChoiceMade: (index) {
                                if (goodAnswerIndex == index) {
                                  // Si le joueur tape sur la bonne case, on met un écran vert devant les choix et on passe au suivant
                                  setState(() {
                                    score += 50;
                                    rightAnswer = true;
                                  });
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    setState(() {
                                      rightAnswer = null;
                                      getFileInfo();
                                    });
                                  });
                                } else {
                                  // Sinon on met un écran rouge devant les choix
                                  setState(() {
                                    badAnswer = true;
                                  });
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    setState(() {
                                      badAnswer = null;
                                    });
                                  });
                                }
                              },
                            ),
                            PokemonGoodChoiceWidget(
                              isVisible: rightAnswer,
                            ),
                            PokemonBadChoiceWidget(
                              isVisible: badAnswer,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
