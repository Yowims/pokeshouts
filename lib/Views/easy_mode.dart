import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Services/answer_picked/answer_picked_bloc.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';
import 'package:pokeshouts/Services/round_timer/round_timer_bloc.dart';
import 'package:pokeshouts/Views/Components/playable_sound_pokeball.dart';
import 'package:pokeshouts/Views/Components/poke_scaffold.dart';
import 'package:pokeshouts/Views/Components/pokemon_choice_grid.dart';
import 'package:pokeshouts/Views/Components/timer_indicator.dart';
import 'package:pokeshouts/Views/Helpers/design_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EasyModePage extends StatelessWidget {
  EasyModePage({Key? key}) : super(key: key);

  final GlobalKey<PokeScaffoldState> easyScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    context.read<PokemonLoadedBloc>().add(OnPokemonLoadedRequestEvent());
    context.read<RoundTimerBloc>().add(const StartTimerEvent(60));
    PokeScaffold easyScaffold = PokeScaffold(
      key: easyScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.easy_mode, style: DesignHelper.titleStyle()),
      ),
      dialog: AlertDialog(
        title: const Text("Temps écoulé !"),
        content: Center(
          child: BlocBuilder<AnswerPickedBloc, AnswerPickedState>(
            builder: (context, state) {
              return Text("Le temps imparti pour cette manche est écoulé.\nVous avez marqué ${state.answerPicked.score} points.\nFélicitations !");
            },
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
      ),
      body: BlocListener<RoundTimerBloc, RoundTimerState>(
        listener: (context, state) {
          if (state is TimerComplete) {
            easyScaffoldKey.currentState!.showDialog();
          }
        },
        child: Stack(
          children: [
            const Positioned(
              top: 5,
              right: 5,
              child: TimerIndicator(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<AnswerPickedBloc, AnswerPickedState>(
                    builder: (context, state) {
                      return Text("Score: ${state.answerPicked.score} pts");
                    },
                  ),
                  const PlayableSoundPokeball(),
                  const SizedBox(
                    height: 20,
                  ),
                  const PokemonChoiceGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context)!.go_to_menu),
              content: Text(AppLocalizations.of(context)!.lose_progress),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  },
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ],
            );
          },
        );
      },
      child: easyScaffold,
    );
  }
}
