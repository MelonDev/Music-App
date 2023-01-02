import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_app/mock/mock_data.dart';
import 'package:music_app/services/audio_handler.dart';
import 'package:audio_session/audio_session.dart';

part 'controller_state.dart';

class ControllerCubit extends Cubit<ControllerState> {
  ControllerCubit() : super(ControllerInitialState());

  /*old_setup() async {
    print("setup");
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    AudioPlayer player = AudioPlayer();

    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      await player.setAudioSource(_playlist);

      emit(player);

    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }

  }*/

  mock() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    AudioPlayer player = AudioPlayer();
    ControllerIdleState state = ControllerIdleState(player: player);
    await setPlaylist(playlist: mockPlaylist1, previousState: state);
  }

  setup() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    AudioPlayer player = AudioPlayer();

    emit(ControllerIdleState(player: player));
  }

  setPlaylist(
      {required List<AudioSource> playlist,
      required ControllerMediaState previousState}) async {
    try {
      previousState.playlist = ConcatenatingAudioSource(children: playlist);
      await previousState.player.setAudioSource(
          previousState.playlist!);
      emit(previousState);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  newPlaylist(
      {required List<AudioSource> playlist,
      required ControllerMediaState previousState,bool play = false}) async {
    try {
      ControllerPlayingState newState =
          ControllerPlayingState(player: previousState.player);
      newState.playlist = ConcatenatingAudioSource(children: playlist);
      await newState.player.setAudioSource(
          newState.playlist!);
      newState.player.play();
      emit(newState);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  play({required ControllerMediaState previousState,int? index}) async {
    ControllerPlayingState newState =
        ControllerPlayingState(player: previousState.player)
          ..currentId = previousState.currentId
          ..playlist = previousState.playlist
          ..isShuffle = previousState.isShuffle
          ..loopMode = previousState.loopMode;

    if(index != null){
      newState.player.seek(Duration.zero, index: index);
    }

    newState.player.play();

    emit(newState);
  }

  pause({required ControllerMediaState previousState}) async {
    ControllerPauseState newState =
        ControllerPauseState(player: previousState.player)
          ..currentId = previousState.currentId
          ..playlist = previousState.playlist
          ..isShuffle = previousState.isShuffle
          ..loopMode = previousState.loopMode;
    newState.player.pause();

    emit(newState);
  }

  stop({required ControllerMediaState previousState}) async {
    previousState.player.stop();
    ControllerIdleState newState =
    ControllerIdleState(player: previousState.player);
    emit(newState);
  }

  shuffle(bool value, {required ControllerMediaState previousState}) async {
    previousState.isShuffle = value;
    if (value) {
      await previousState.player.shuffle();
    }
    await previousState.player.setShuffleModeEnabled(value);
    emit(previousState);
  }

  loop(LoopMode value, {required ControllerMediaState previousState}) async {
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];

    previousState.loopMode = value;
    await previousState.player.setLoopMode(cycleModes[
    (cycleModes.indexOf(value) + 1) %
        cycleModes.length]);
    emit(previousState);
  }

  next({required ControllerMediaState previousState}) async {
    previousState.player.seekToNext();
    emit(previousState);
  }

  previous({required ControllerMediaState previousState}) async {
    previousState.player.seekToPrevious();
    emit(previousState);
  }

  move({required ControllerMediaState previousState,required int oldIndex,required int  newIndex}){
    if (oldIndex < newIndex) newIndex--;
    previousState.playlist?.move(oldIndex, newIndex);
    emit(previousState);
  }

  remove({required ControllerMediaState previousState,required int index}){
    previousState.playlist?.removeAt(index);
    emit(previousState);
  }


}
