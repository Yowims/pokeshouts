part of 'answer_picked_bloc.dart';

sealed class AnswerPickedEvent extends Equatable {
  const AnswerPickedEvent();

  @override
  List<Object> get props => [];
}

class OnRightAnswerPickedEvent extends AnswerPickedEvent {
  final int score;
  const OnRightAnswerPickedEvent({required this.score});

  @override
  List<Object> get props => [score];
}

class OnWrongAnswerPickedEvent extends AnswerPickedEvent {
  final int score;
  const OnWrongAnswerPickedEvent({required this.score});

  @override
  List<Object> get props => [score];
}

class OnLeaveQuizEvent extends AnswerPickedEvent {
  const OnLeaveQuizEvent();
}

class OnResetAnswerPickedEvent extends AnswerPickedEvent {
  const OnResetAnswerPickedEvent();
}
