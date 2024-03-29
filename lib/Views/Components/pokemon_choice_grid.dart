import 'package:flutter/material.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:provider/provider.dart';

class PokemonChoiceGrid extends StatelessWidget {
  final Map<int, Pokemon> pokemonChoices;
  final Function(int) onChoiceMade;

  const PokemonChoiceGrid({super.key, required this.pokemonChoices, required this.onChoiceMade});

  @override
  Widget build(BuildContext context) {
    final pokemonLoadedProvider = context.watch<PokemonLoadedProvider>();
    pokemonLoadedProvider.setPokemonImagesLoaded = {0: false, 1: false, 2: false, 3: false};
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            onChoiceMade(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              child: Image.network(
                pokemonChoices[index]!.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null && loadingProgress.expectedTotalBytes != null) {
                    double percentage = (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100;

                    if (percentage < 100) {
                      return Image.asset("assets/images/waiting.gif");
                    } else {
                      Map<int, bool> actualPokemonLoadedImages = pokemonLoadedProvider.getPokemonImagesLoaded;
                      actualPokemonLoadedImages[index] = true;
                      pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
                      return child;
                    }
                  } else {
                    return child;
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
