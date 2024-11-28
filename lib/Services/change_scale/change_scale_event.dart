part of 'change_scale_bloc.dart';

sealed class ChangeScaleEvent extends Equatable {
  const ChangeScaleEvent();

  @override
  List<Object> get props => [];
}

class ChangeScaleTriggerEvent extends ChangeScaleEvent {}

class ChangeScaleDefaultEvent extends ChangeScaleEvent {}
