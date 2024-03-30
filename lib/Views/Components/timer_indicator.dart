import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokeshouts/Providers/round_timer_provider.dart';
import 'package:provider/provider.dart';

class TimerIndicator extends StatefulWidget {
  final int seconds;
  final Function() onTimerFinished;

  const TimerIndicator({super.key, required this.seconds, required this.onTimerFinished});

  @override
  TimerIndicatorState createState() => TimerIndicatorState();
}

class TimerIndicatorState extends State<TimerIndicator> {
  late int remainingSeconds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoundTimerProvider roundTimerProvider = context.watch<RoundTimerProvider>();

    remainingSeconds = roundTimerProvider.getTimer != 0 ? roundTimerProvider.getTimer : widget.seconds;

    roundTimerProvider.onTimerFinished ??= widget.onTimerFinished;

    Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted && remainingSeconds > 0) {
        setState(() {
          remainingSeconds -= 1;
          roundTimerProvider.setTimer = remainingSeconds;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(value: remainingSeconds / widget.seconds);
  }
}
