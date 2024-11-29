part of 'shout_manager_bloc.dart';

sealed class ShoutManagerState extends Equatable {
  final String shout;
  const ShoutManagerState(this.shout);

  @override
  List<Object> get props => [];
}

final class ShoutManagerInitial extends ShoutManagerState {
  const ShoutManagerInitial(super.shout);
}
