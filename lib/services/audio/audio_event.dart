part of 'audio_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class LoadAudio extends AudioEvent {}

class PressAudioButton extends AudioEvent {}

class AudioIsCompleted extends AudioEvent {}

class PressDeleteButton extends AudioEvent {}

class PressLoopButton extends AudioEvent {}

class SlideVolumeButton extends AudioEvent {
  final double volume;

  const SlideVolumeButton({required this.volume});

  @override
  List<Object> get props => [volume];
}
