part of 'answer_picked_bloc.dart';

sealed class AnswerPickedEvent extends Equatable {
  final int score;
  const AnswerPickedEvent(this.score);

  @override
  List<Object> get props => [
        score,
      ];
}

class OnRightAnswerPickedEvent extends AnswerPickedEvent {
  const OnRightAnswerPickedEvent(super.score);
}

class OnWrongAnswerPickedEvent extends AnswerPickedEvent {
  const OnWrongAnswerPickedEvent(super.score);
}

class OnResetAnswerPickedEvent extends AnswerPickedEvent {
  const OnResetAnswerPickedEvent(super.score);
}
