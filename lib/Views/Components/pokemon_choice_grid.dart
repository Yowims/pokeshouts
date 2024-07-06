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
