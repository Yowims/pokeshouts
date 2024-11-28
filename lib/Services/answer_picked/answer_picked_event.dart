part of 'answer_picked_bloc.dart';

sealed class AnswerPickedEvent extends Equatable {
  const AnswerPickedEvent();

  @override
  List<Object> get props => [];
}

class OnRightAnswerPickedEvent extends AnswerPickedEvent {}

class OnWrongAnswerPickedEvent extends AnswerPickedEvent {}

class OnResetAnswerPickedEvent extends AnswerPickedEvent {}
