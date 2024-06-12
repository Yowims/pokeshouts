import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:provider/provider.dart';

class PokemonChoiceGrid extends StatefulWidget {
  final Map<int, Pokemon> pokemonChoices;
  final Function(int) onChoiceMade;

  const PokemonChoiceGrid({super.key, required this.pokemonChoices, required this.onChoiceMade});

  @override
  State<PokemonChoiceGrid> createState() => _PokemonChoiceGridState();
}

class _PokemonChoiceGridState extends State<PokemonChoiceGrid> {
  late PokemonLoadedProvider pokemonLoadedProvider;
  late Map<int, bool> actualPokemonLoadedImages;

  @override
  void initState() {
    super.initState();
    pokemonLoadedProvider = context.read<PokemonLoadedProvider>();

    actualPokemonLoadedImages = pokemonLoadedProvider.getPokemonImagesLoaded;
    pokemonLoadedProvider.setPokemonImagesLoaded = {0: false, 1: false, 2: false, 3: false};
    for (var element in actualPokemonLoadedImages.entries) {
      if (element.value == false) {
        DefaultCacheManager().getFileFromCache(widget.pokemonChoices[element.key]!.index.toString()).then((fileInfo) {
          if (fileInfo != null) {
            print("IMAGE ${element.key} CHARGÉE DEPUIS LE CACHE");
            actualPokemonLoadedImages[element.key] = true;
            pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onChoiceMade(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              child: CachedNetworkImage(
                cacheManager: DefaultCacheManager(),
                imageUrl: widget.pokemonChoices[index]!.imageUrl,
                fadeOutDuration: const Duration(milliseconds: 100),
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  if (downloadProgress.progress != null && downloadProgress.progress! == 1) {
                    actualPokemonLoadedImages[index] = true;
                    pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
                    print("IMAGE $index CHARGÉE");
                    DefaultCacheManager().downloadFile(widget.pokemonChoices[index]!.imageUrl, key: widget.pokemonChoices[index]!.index.toString());
                    return Image(
                      image: CachedNetworkImageProvider(url, cacheManager: DefaultCacheManager()),
                    );
                  } else {
                    return Image.asset("assets/images/waiting.gif");
                  }
                },
                // imageBuilder: (context, imageProvider) {
                //   if (!(actualPokemonLoadedImages.values.any((element) => element == true))) {
                //     actualPokemonLoadedImages[index] = true;
                //     pokemonLoadedProvider.setPokemonImagesLoaded = actualPokemonLoadedImages;
                //   }
                //   return Image(
                //     image: imageProvider,
                //   );
                // },
              ),
            ),
          ),
        );
      },
    );
  }
}

class PokemonBadChoiceWidget extends StatelessWidget {
  final bool? isVisible;
  const PokemonBadChoiceWidget({super.key, this.isVisible = false});

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

class PokemonGoodChoiceWidget extends StatelessWidget {
  final bool? isVisible;
  const PokemonGoodChoiceWidget({super.key, this.isVisible = false});

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