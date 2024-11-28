import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeshouts/Services/round_timer/round_timer_bloc.dart';

class TimerIndicator extends StatelessWidget {
  final Function() onTimerFinished;

  const TimerIndicator({super.key, required this.onTimerFinished});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoundTimerBloc, RoundTimerState>(
      builder: (context, state) {
        double seconds = state.newValue;
        Timer.periodic(const Duration(seconds: 1), (_) {
          double newSecondsValue = seconds - 1;
          if (newSecondsValue > 0) {
            context.read<RoundTimerBloc>().add(RoundTimerProgressEvent(newSecondsValue));
          }
        });
        return CircularProgressIndicator(value: seconds);
      },
    );
  }
}
