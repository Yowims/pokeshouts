import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Controllers/api_controller.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestPokemonPage extends StatefulWidget {
  const TestPokemonPage({Key? key}) : super(key: key);

  @override
  State<TestPokemonPage> createState() => _TestPokemonPageState();
}

class _TestPokemonPageState extends State<TestPokemonPage> {
  AudioPlayer audioPlugin = AudioPlayer();
  ApiController apiController = ApiController();

  int index = 1;
  Pokemon pokemon = Pokemon.empty();

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  void loadPokemonInfos() async {
    setState(() {
      isLoading = true;
    });
    if (index > PokedexHelper.pokedex.length || index <= 0) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    pokemon = await apiController.getPokemonInfosAsync(index);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
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
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value == "" || int.parse(value) > PokedexHelper.pokedex.length) {
                value = "1";
              }
              setState(() {
                index = int.parse(value);
                loadPokemonInfos();
              });
            }),
      )),
      body: isLoading
          ? const WaitingIndicator()
          : Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: pokemon.index == 0 ? pkmnError(context) : pkmnWidgetTester(context),
              ),
            ),
    );
  }

  Widget pkmnError(BuildContext context) {
    return Column(
      children: [Text(AppLocalizations.of(context)!.not_implemented_pokemon)],
    );
  }

  Widget pkmnWidgetTester(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pokemon.imageUrl != ""
            ? FadeInImage.assetNetwork(
                placeholder: "assets/images/waiting.gif",
                image: pokemon.imageUrl,
                height: 300,
              )
            : Center(child: Text(AppLocalizations.of(context)!.not_implemented_pokemon)),
        Text("#${pokemon.index} - ${pokemon.name}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Cri : "),
            pokemon.shoutUrl != "" ? const Icon(Icons.check) : const Icon(Icons.close),
          ],
        ),
        const Divider(),
        pokemon.shoutUrl != ""
            ? TextButton(
                child: const Icon(Icons.play_arrow),
                onPressed: () async {
                  if (!audioPlugin.playing) {
                    await audioPlugin.setUrl(pokemon.shoutUrl);
                    await audioPlugin.play();
                    await audioPlugin.stop();
                  }
                },
              )
            : const TextButton(onPressed: null, child: Icon(Icons.play_arrow)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            onPressed: index <= 1
                ? null
                : () {
                    setState(() {
                      int newIndex = index - 1;
                      if (newIndex < 0) {
                        index = 1;
                      } else {
                        index = newIndex;
                      }
                      loadPokemonInfos();
                      _searchController.text = "";
                    });
                  },
            child: const Icon(Icons.arrow_left, size: 48),
          ),
          TextButton(
            onPressed: index >= PokedexHelper.pokedex.length
                ? null
                : () {
                    setState(() {
                      int newIndex = index + 1;
                      if (newIndex > PokedexHelper.pokedex.length) {
                        index = PokedexHelper.pokedex.length - 1;
                      } else {
                        index = newIndex;
                      }
                      loadPokemonInfos();
                      _searchController.text = "";
                    });
                  },
            child: const Icon(
              Icons.arrow_right,
              size: 48,
            ),
          )
        ]),
      ],
    );
  }
}
