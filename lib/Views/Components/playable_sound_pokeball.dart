import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Services/change_scale/change_scale_bloc.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';
import 'package:pokeshouts/Services/shout_manager/shout_manager_bloc.dart';

class PlayableSoundPokeball extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const PlayableSoundPokeball({super.key, required this.audioPlayer});

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
          onTap: () async {
            _changeScaleDown(context);
            context.read<ShoutManagerBloc>().add(OnPlayShoutEvent(state.result.pokemonShout));
            if (context.mounted) {
              _changeScaleUp(context);
            }
          },
          child: BlocBuilder<ChangeScaleBloc, ChangeScaleState>(
            builder: (context, state) {
              return AnimatedScale(
                scale: state.scale,
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
