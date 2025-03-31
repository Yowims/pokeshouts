part of 'answer_picked_bloc.dart';

sealed class AnswerPickedState extends Equatable {
  const AnswerPickedState();

  @override
  List<Object?> get props => [];
}

final class AnswerPickedInitial extends AnswerPickedState {}

final class AnswerGoodPickState extends AnswerPickedState {}

final class AnswerBadPickState extends AnswerPickedState {}
