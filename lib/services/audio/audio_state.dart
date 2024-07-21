part of 'audio_bloc.dart';

abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoaded extends AudioState {
  final File? file;
  final bool isPlaying;
  final bool isRecording;
  final bool isLooping;
  final double volume;

  const AudioLoaded({
    required this.file,
    required this.isPlaying,
    required this.isRecording,
    required this.isLooping,
    required this.volume,
  });

  @override
  List<Object> get props => [
        file ?? File(''),
        isPlaying,
        isRecording,
        isLooping,
        volume,
      ];
}

class AudioLoadedPermissionRequired extends AudioState {}

class AudioRecording extends AudioState {}

class AudioPlaying extends AudioState {}
