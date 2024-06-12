import 'package:cached_network_image/cached_network_image.dart';
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
    Map<int, bool> actualPokemonLoadedImages = pokemonLoadedProvider.getPokemonImagesLoaded;
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
              child: CachedNetworkImage(
                imageUrl: pokemonChoices[index]!.imageUrl,
                fadeOutDuration: const Duration(milliseconds: 100),
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  if (downloadProgress.progress != null && downloadProgress.progress! == 1) {
                    actualPokemonLoadedImages[index] = true;
                    pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
                    print("IMAGE $index CHARGÉE");
                    return Image(image: CachedNetworkImageProvider(url));
                  } else {
                    return Image.asset("assets/images/waiting.gif");
                  }
                },
                imageBuilder: (context, imageProvider) {
                  if (!(actualPokemonLoadedImages.values.any((element) => element == true))) {
                    actualPokemonLoadedImages[index] = true;
                    pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
                  }
                  return Image(
                    image: imageProvider,
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class PokemonBadChoiceWidget extends StatelessWidget {
  bool? isVisible = false;
  PokemonBadChoiceWidget({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible ?? false,
      child: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: const Center(child: Icon(Icons.close)),
      ),
    );
  }
}

// ignore: must_be_immutable
class PokemonGoodChoiceWidget extends StatelessWidget {
  bool? isVisible = false;
  PokemonGoodChoiceWidget({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible ?? false,
      child: Container(
        decoration: const BoxDecoration(color: Colors.green),
        child: const Center(child: Icon(Icons.check)),
      ),
    );
  }
}



// Image.network(
//                 pokemonChoices[index]!.imageUrl,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress != null && loadingProgress.expectedTotalBytes != null) {
//                     double percentage = (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100;

//                     if (percentage < 100) {
//                       return Image.asset("assets/images/waiting.gif");
//                     } else {
//                       print("IMAGE N°$index chargée");
//                       Map<int, bool> actualPokemonLoadedImages = pokemonLoadedProvider.getPokemonImagesLoaded;
//                       actualPokemonLoadedImages[index] = true;
//                       pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
//                       return child;
//                     }
//                   } else {
//                     print("ELSE - IMAGE N°$index chargée");
//                     return child;
//                   }
//                 },
//                 frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//                   print("FRAMEBUILDER - IMAGE N°$index CHARGÉE");
//                   return child;
//                 },
//               )