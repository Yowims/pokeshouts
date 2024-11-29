import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'shout_manager_event.dart';
part 'shout_manager_state.dart';

class ShoutManagerBloc extends Bloc<ShoutManagerEvent, ShoutManagerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  ShoutManagerBloc() : super(const ShoutManagerInitial("")) {
    on<OnPlayShoutEvent>((event, emit) async {
      if (event.shout != "") {
        if (audioPlayer.playing) {
          await audioPlayer.stop();
        }
        await audioPlayer.setUrl(event.shout);
        await audioPlayer.play();
        await audioPlayer.stop();
      }
    });
    on<OnStopShoutEvent>((event, emit) async => await audioPlayer.stop());
  }
}
