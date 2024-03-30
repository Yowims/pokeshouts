import 'package:flutter/material.dart';

typedef TimerFinisdhedCallback = void Function();

class RoundTimerProvider extends ChangeNotifier {
  TimerFinisdhedCallback? onTimerFinished;
  int _timer = 0;
  int get getTimer => _timer;
  set setTimer(int newTime) {
    _timer = newTime;
    if (_timer == 0) {
      onTimerFinished?.call();
    }
  }
}
