import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopstation/services/audio/audio_bloc.dart';

class RecordButtons extends StatelessWidget {
  const RecordButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoaded) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 8,
                right: 16,
                bottom: 8,
              ),
              child: ClipOval(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        CircleBorder(
                          side: BorderSide(
                            width: 6,
                            color: state.file == null
                                ? !state.isRecording
                                    ? const Color(0xffadfde2)
                                    : const Color(0xffffa8bf)
                                : !state.isPlaying
                                    ? const Color(0xffadfde2)
                                    : const Color(0xffa8e5ff),
                          ),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff2f2f2f)),
                    ),
                    onPressed: () {
                      context.read<AudioBloc>().add(PressAudioButton());
                    },
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Icon(
                        state.file == null
                            ? !state.isRecording
                                ? Icons.fiber_manual_record
                                : Icons.stop_rounded
                            : !state.isPlaying
                                ? Icons.play_arrow_rounded
                                : Icons.stop_rounded,
                        color: state.file == null
                            ? !state.isRecording
                                ? const Color(0xffadfde2)
                                : const Color(0xffffa8bf)
                            : !state.isPlaying
                                ? const Color(0xffadfde2)
                                : const Color(0xffa8e5ff),
                        size: constraint.biggest.height / 2,
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow,
            ),
            child: const Text(
              'Please allow registering permissions',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
