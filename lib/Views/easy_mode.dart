import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Controllers/gameplay_controller.dart';
import 'package:pokeshouts/Models/file_info.dart';
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
  
  Map<int,String> pokemonChoices = {};
  Map<int,String> pokemonNames = {};
  String pokemonShout = "";
  int goodAnswerIndex = 0;

  Future getFileInfo() async
  {
    FileInfo? fileInfo;
    // On définit les 4 cases du choix de Pokémon
    for(var i = 0; i<4; i++)
    {
      var randomPokemon = PokedexHelper.pokedex[Random().nextInt(650)+1]!; // De 1 à 649
      pokemonNames.addAll({i: randomPokemon});
      await ApiController().getPokemonInfos("Fichier:$randomPokemon.png").then((value){
        setState(() {
          fileInfo = value;
          pokemonChoices.addAll({i: fileInfo!.url});
        });
      });
    }

    // Et là, parmi les 4 choix, on choisit la bonne réponse
    int goodChoice = Random().nextInt(100)+1; // De 1 à 100
    var goodPokemon;

    if(1 <= goodChoice && goodChoice <= 25) // De 1 à 25 : Case 1
    {
      goodPokemon = pokemonNames[0];
      goodAnswerIndex = 0;
    }
    else if(26 <= goodChoice && goodChoice <= 50) // De 26 à 50 : Case 2
    {
      goodPokemon = pokemonNames[1];
      goodAnswerIndex = 1;
    }
    else if(51 <= goodChoice && goodChoice <= 75) // De 51 à 75 : Case 3
    {
      goodPokemon = pokemonNames[2];
      goodAnswerIndex = 2;
    }
    else // De 76 à 100 : Case 4
    {
      goodPokemon = pokemonNames[3];
      goodAnswerIndex = 3;
    }
    
    // On récupère le cri, et on charge son URL dans une variable
    await ApiController().getPokemonShout(goodPokemon).then((value){
      setState(() {
        pokemonShout = value!.url;
        // Et une fois que le cri est récupéré, on attend 1 seconde avant de le jouer
        Future.delayed(const Duration(seconds: 1), (){
          audioPlugin.play(UrlSource(pokemonShout));
        });
      });
    });
  }

  @override
  void initState(){
    getFileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.easy_mode, style: DesignHelper.titleStyle()),
      ),
      body: pokemonShout.isEmpty
            ? WaitingIndicator()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Score: $score pts"),
                    Image.asset("assets/images/pokeball.png", width: MediaQuery.of(context).size.width * 0.6),
                    const SizedBox(height: 20,),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: (){
                            if(goodAnswerIndex == index)
                            {
                              // Si le joueur tape sur la bonne case, on affiche une model d'info et on passe à la manche suivante
                              GameplayController.win(50, context, (){
                                Navigator.of(context).pop();
                                setState(() {
                                  score += 50;
                                  initState();
                                });
                              });
                            }
                            else
                            {
                              // Sinon on l'informe qu'il s'est trompé et on reste sur cette manche
                              GameplayController.lose(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: Image.network(pokemonChoices[index]!)
                            )
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