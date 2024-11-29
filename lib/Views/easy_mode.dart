import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokeshouts/Services/answer_picked/answer_picked_bloc.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';
import 'package:pokeshouts/Services/round_timer/round_timer_bloc.dart';
import 'package:pokeshouts/Views/Components/playable_sound_pokeball.dart';
import 'package:pokeshouts/Views/Components/poke_scaffold.dart';
import 'package:pokeshouts/Views/Components/pokemon_choice_grid.dart';
import 'package:pokeshouts/Views/Components/timer_indicator.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';
import 'package:pokeshouts/Views/Helpers/design_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EasyModePage extends StatefulWidget {
  const EasyModePage({Key? key}) : super(key: key);

  @override
  State<EasyModePage> createState() => _EasyModePageState();
}

class _EasyModePageState extends State<EasyModePage> {
  GlobalKey<PokeScaffoldState> easyScaffoldKey = GlobalKey();

  bool roundFinished = false;

  AudioPlayer audioPlugin = AudioPlayer();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

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
      body: isLoading
          ? const WaitingIndicator()
          : Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 5,
                  child: TimerIndicator(
                    onTimerFinished: () {
                      easyScaffoldKey.currentState!.showDialog();
                    },
                  ),
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
                      PlayableSoundPokeball(
                        audioPlayer: audioPlugin,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const PokemonChoiceGrid(),
                    ],
                  ),
                ),
              ],
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
