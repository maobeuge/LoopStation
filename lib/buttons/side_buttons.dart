import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopstation/services/audio/audio_bloc.dart';

class SideButtons extends StatelessWidget {
  const SideButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoaded) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipOval(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const CircleBorder()),
                      backgroundColor: state.file != null
                          ? MaterialStateProperty.all<Color>(Colors.red)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      context.read<AudioBloc>().add(PressDeleteButton());
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ),
                ClipOval(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const CircleBorder()),
                      backgroundColor: state.isLooping
                          ? MaterialStateProperty.all<Color>(Colors.blue)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      context.read<AudioBloc>().add(PressLoopButton());
                    },
                    child: const Icon(
                      Icons.loop,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
