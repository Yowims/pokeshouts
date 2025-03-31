import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Services/answer_picked/answer_picked_bloc.dart';
import 'package:pokeshouts/Services/pokemon_loaded/pokemon_loaded_bloc.dart';
import 'package:pokeshouts/Views/Components/waiting_indicator.dart';

class PokemonChoiceGrid extends StatelessWidget {
  const PokemonChoiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnswerPickedBloc, AnswerPickedState>(
      builder: (context, state) {
        return Stack(
          children: [
            const PokemonChoices(),
            PokemonGoodChoiceWidget(
              isVisible: state is AnswerGoodPickState,
            ),
            PokemonBadChoiceWidget(
              isVisible: state is AnswerBadPickState,
            ),
          ],
        );
      },
    );
  }
}

class PokemonChoices extends StatelessWidget {
  const PokemonChoices({super.key});

  void onChoiceMade(BuildContext context, int goodAnswerIndex, int selectedIndex) {
    int actualScore = context.read<AnswerPickedBloc>().score;
    if (goodAnswerIndex == selectedIndex) {
      // Si le joueur tape sur la bonne case, on met un écran vert devant les choix et on passe au suivant
      context.read<AnswerPickedBloc>().add(OnRightAnswerPickedEvent(score: actualScore));
    } else {
      // Sinon on met un écran rouge devant les choix
      context.read<AnswerPickedBloc>().add(OnWrongAnswerPickedEvent(score: actualScore));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonLoadedBloc, PokemonLoadedState>(
      builder: (context, state) {
        if (state.result.pokemonChoices.isEmpty) {
          return const WaitingIndicator();
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onChoiceMade(context, state.result.goodAnswerIndex, index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child: FadeInImage(
                      image: AssetImage(state.result.pokemonChoices[index].imageUrl),
                      placeholder: const AssetImage('assets/images/waiting.gif'),
                    ),
                  ),
                ),
              );
            },
          );
        }
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

class PokemonChoiceWidget extends StatelessWidget {
  final bool? isRight;
  const PokemonChoiceWidget({super.key, this.isRight});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isRight != null,
      child: Container(
        decoration: BoxDecoration(color: isRight! ? Colors.green : Colors.red),
        child: const Center(child: Icon(Icons.check)),
      ),
    );
  }
}
