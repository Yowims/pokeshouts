import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Services/change_scale/change_scale_bloc.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';
import 'package:pokeshouts/Services/shout_manager/shout_manager_bloc.dart';

class PlayableSoundPokeball extends StatelessWidget {
  const PlayableSoundPokeball({super.key});

  void _changeScaleDown(BuildContext context) {
    context.read<ChangeScaleBloc>().add(ChangeScaleTriggerEvent());
  }

  void _changeScaleUp(BuildContext context) {
    context.read<ChangeScaleBloc>().add(ChangeScaleDefaultEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonLoadedBloc, PokemonLoadedState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (_) => _changeScaleDown(context), // Scale down on press
          onTapUp: (_) {
            // Trigger sound and scale up after tap
            context.read<ShoutManagerBloc>().add(OnPlayShoutEvent(state.result.pokemonShout));
            _changeScaleUp(context);
          },
          onTapCancel: () => _changeScaleUp(context), // Reset if the tap is cancelled
          child: BlocBuilder<ChangeScaleBloc, ChangeScaleState>(
            builder: (context, scaleState) {
              return AnimatedScale(
                scale: scaleState.scale,
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  "assets/images/pokeball.png",
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
