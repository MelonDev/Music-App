part of 'controller_cubit.dart';

@immutable
abstract class ControllerState {}

class ControllerInitialState extends ControllerState {}

class ControllerMediaState extends ControllerState {
  AudioPlayer player;
  int currentId;
  ConcatenatingAudioSource? playlist;
  bool isShuffle;
  LoopMode loopMode;

  ControllerMediaState(
      {required this.player,
      this.currentId = 0,
      this.playlist,
      this.isShuffle = false,
      this.loopMode = LoopMode.off});
}

class ControllerPlayingState extends ControllerMediaState {
  ControllerPlayingState(
      {required super.player,
      super.currentId,
      super.playlist,
      super.isShuffle,
      super.loopMode});
}

class ControllerPauseState extends ControllerMediaState {
  ControllerPauseState(
      {required super.player,
      super.currentId,
      super.playlist,
      super.isShuffle,
      super.loopMode});
}

class ControllerIdleState extends ControllerMediaState {
  ControllerIdleState({required super.player});
}
