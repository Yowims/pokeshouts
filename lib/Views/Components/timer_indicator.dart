import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Services/round_timer/round_timer_bloc.dart';

class TimerIndicator extends StatelessWidget {
  final int initialSeconds;
  final Function() onTimerFinished;

  const TimerIndicator({super.key, required this.onTimerFinished, this.initialSeconds = 60});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoundTimerBloc, RoundTimerState>(
      builder: (context, state) {
        if (state is TimerRunning) {
          return CircularProgressIndicator(value: state.progress);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
