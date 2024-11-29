part of 'change_scale_bloc.dart';

sealed class ChangeScaleState extends Equatable {
  final double scale;
  const ChangeScaleState(this.scale);

  @override
  List<Object> get props => [
        scale,
      ];
}

final class ChangeScaleStateInitial extends ChangeScaleState {
  const ChangeScaleStateInitial(super.scale);
}
