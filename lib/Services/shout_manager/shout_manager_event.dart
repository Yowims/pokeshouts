part of 'shout_manager_bloc.dart';

sealed class ShoutManagerEvent extends Equatable {
  final String shout;
  const ShoutManagerEvent(this.shout);

  @override
  List<Object> get props => [
        shout,
      ];
}

class OnPlayShoutEvent extends ShoutManagerEvent {
  const OnPlayShoutEvent(super.shout);
}

class OnStopShoutEvent extends ShoutManagerEvent {
  const OnStopShoutEvent(super.shout);
}
