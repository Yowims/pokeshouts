import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';

class TestPokemonPage extends StatefulWidget {
  const TestPokemonPage({Key? key}) : super(key: key);

  @override
  State<TestPokemonPage> createState() => _TestPokemonPageState();
}

class _TestPokemonPageState extends State<TestPokemonPage> {

  AudioPlayer audioPlugin = AudioPlayer();

  int index = 1;
  Pokemon pokemon = Pokemon.empty();
  Pokemon pkmnFromHtmlPage = Pokemon.empty();

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  loadPokemonInfos()
  {
    setState(() {
      isLoading = true;
    });
    ApiController().searchStringsInHtml("https://www.pokepedia.fr/${PokedexHelper.pokedex[index]!}").then((value) {
      try
      {
        pkmnFromHtmlPage.index = index;
        pkmnFromHtmlPage.name = PokedexHelper.pokedex[index]!;
        pkmnFromHtmlPage.imageUrl = value.firstWhere((element) => element.contains(".png"));
        pkmnFromHtmlPage.shoutUrl = value.firstWhere((element) => element.contains(".ogg"));

        setState(() {
          isLoading = false;
        });
      }
      catch(error)
      {
        var pkmnName = PokedexHelper.pokedex[index]!;
        var urlFormatted = pkmnName.replaceAll(r" ","_");
        ApiController().searchStringsInHtml("https://www.pokepedia.fr/$urlFormatted").then((value) {
          pkmnFromHtmlPage.index = index;
          pkmnFromHtmlPage.name = PokedexHelper.pokedex[index]!;
          pkmnFromHtmlPage.imageUrl = value.firstWhere((element) => element.contains(".png"));
          pkmnFromHtmlPage.shoutUrl = value.firstWhere((element) => element.contains(".ogg"));

          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }
  
  @override
  void initState(){
    index = 1;
    super.initState();
    loadPokemonInfos();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                index = int.parse(value);
                loadPokemonInfos();
              });
          }),
        )
      ),
      body: isLoading
        ? const WaitingIndicator()
        : Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInImage.assetNetwork(placeholder: "assets/images/waiting.gif", image: pkmnFromHtmlPage.imageUrl, height: 300,),
                Text("#${pkmnFromHtmlPage.index} - ${pkmnFromHtmlPage.name}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Cri : "),
                    pkmnFromHtmlPage.shoutUrl != "" ? const Icon(Icons.check) : const Icon(Icons.close),
                  ],
                ),
                const Divider(),
                pkmnFromHtmlPage.shoutUrl != "" 
                  ? TextButton(child: const Icon(Icons.play_arrow), onPressed: (){
                    audioPlugin.play(UrlSource("https://${pkmnFromHtmlPage.shoutUrl}"));
                  },) 
                  : const TextButton(onPressed: null, child: Icon(Icons.play_arrow)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Icon(Icons.arrow_left, size: 48),
                      onPressed: (){
                        setState(() {
                          index--;
                          loadPokemonInfos();
                          _searchController.text = "";
                        });
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.arrow_right, size: 48,),
                      onPressed: (){
                        setState(() {
                          index++;
                          loadPokemonInfos();
                          _searchController.text = "";
                        });
                      },
                    )
                  ]
                ),
              ],
            ),
          )
        )
    );
  }
}