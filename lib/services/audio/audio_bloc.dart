import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart' as player;

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final FlutterSoundRecorder flutterSoundRecorder = FlutterSoundRecorder();
  final player.AudioPlayer audioPlayer = player.AudioPlayer();

  File? audioFile;
  late String tempDir;
  bool isPlaying = false;
  bool isRecording = false;
  bool isLooping = false;
  double volume = 0.5;

  AudioBloc({required int recordTrack}) : super(AudioInitial()) {
    int track = recordTrack;
    on<LoadAudio>((event, emit) async {
      final PermissionStatus statusMic = await Permission.microphone.request();

      if (statusMic.isGranted) {
        final directory = await getTemporaryDirectory();
        tempDir = directory.path;

        emit(AudioLoaded(
          file: audioFile,
          isPlaying: isPlaying,
          isRecording: isRecording,
          isLooping: isLooping,
          volume: volume,
        ));
      } else {
        emit(AudioLoadedPermissionRequired());
      }
    });

    on<PressAudioButton>((event, emit) async {
      if (audioFile == null) {
        if (!isRecording) {
          await flutterSoundRecorder.openRecorder();
          await flutterSoundRecorder.startRecorder(
            toFile: '$tempDir/audio$track.wav',
            codec: Codec.pcm16WAV,
            numChannels: 1,
            sampleRate: 44100,
          );
          isRecording = true;
          emit(AudioLoaded(
            file: audioFile,
            isPlaying: isPlaying,
            isRecording: isRecording,
            isLooping: isLooping,
            volume: volume,
          ));
        } else {
          await flutterSoundRecorder.stopRecorder();

          audioFile = File('$tempDir/audio$track.wav');
          audioPlayer.setSourceDeviceFile('$tempDir/audio$track.wav');
          isRecording = false;

          await flutterSoundRecorder.closeRecorder();

          emit(AudioLoaded(
            file: audioFile,
            isPlaying: isPlaying,
            isRecording: isRecording,
            isLooping: isLooping,
            volume: volume,
          ));
        }
      } else {
        if (!isPlaying) {
          if (audioPlayer.state.name != 'playing') {
            await audioPlayer.setVolume(volume);
            await audioPlayer.resume();

            isPlaying = true;

            audioPlayer.onPlayerStateChanged.listen((playerState) {
              if (playerState == player.PlayerState.completed) {
                add(AudioIsCompleted());
              }
            });

            emit(AudioLoaded(
              file: audioFile,
              isPlaying: isPlaying,
              isRecording: isRecording,
              isLooping: isLooping,
              volume: volume,
            ));
          }
        } else {
          await audioPlayer.setSourceDeviceFile('$tempDir/audio$track.wav');
          await audioPlayer.seek(const Duration(seconds: 0));
          await audioPlayer.pause();
          isPlaying = false;
          emit(AudioLoaded(
            file: audioFile,
            isPlaying: isPlaying,
            isRecording: isRecording,
            isLooping: isLooping,
            volume: volume,
          ));
        }
      }
    });

    on<AudioIsCompleted>(
      (event, emit) async {
        await audioPlayer.setSourceDeviceFile('$tempDir/audio$track.wav');
        await audioPlayer.seek(const Duration(seconds: 0));
        if (!isLooping) {
          await audioPlayer.pause();
          isPlaying = false;
        } else {
          await audioPlayer.resume();
        }
        emit(AudioLoaded(
          file: audioFile,
          isPlaying: isPlaying,
          isRecording: isRecording,
          isLooping: isLooping,
          volume: volume,
        ));
      },
    );

    on<PressDeleteButton>((event, emit) async {
      if (audioFile != null) {
        await audioPlayer.stop();
        audioFile = null;
        isPlaying = false;
        isRecording = false;
        emit(AudioLoaded(
          file: audioFile,
          isPlaying: isPlaying,
          isRecording: isRecording,
          isLooping: isLooping,
          volume: volume,
        ));
      }
    });

    on<PressLoopButton>((event, emit) {
      isLooping = !isLooping;
      emit(AudioLoaded(
        file: audioFile,
        isPlaying: isPlaying,
        isRecording: isRecording,
        isLooping: isLooping,
        volume: volume,
      ));
    });

    on<SlideVolumeButton>((event, emit) async {
      volume = event.volume;
      await audioPlayer.setVolume(volume);
      emit(AudioLoaded(
        file: audioFile,
        isPlaying: isPlaying,
        isRecording: isRecording,
        isLooping: isLooping,
        volume: volume,
      ));
    });
  }

  @override
  Future<void> close() async {
    await audioPlayer.dispose();
    await flutterSoundRecorder.closeRecorder();
    return super.close();
  }
}
