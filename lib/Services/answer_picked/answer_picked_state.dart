part of 'answer_picked_bloc.dart';

sealed class AnswerPickedState extends Equatable {
  final PickAnswerModel answerPicked;
  const AnswerPickedState(this.answerPicked);

  @override
  List<Object> get props => [];
}

final class AnswerPickedInitial extends AnswerPickedState {
  const AnswerPickedInitial(super.answerPicked);
}
