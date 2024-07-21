import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/audio/audio_bloc.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoaded) {
          return SliderTheme(
            data: SliderThemeData(
              thumbColor: state.file == null
                  ? !state.isRecording
                      ? const Color(0xffadfde2)
                      : const Color(0xffffa8bf)
                  : !state.isPlaying
                      ? const Color(0xffadfde2)
                      : const Color(0xffa8e5ff),
              inactiveTrackColor: Colors.grey,
              secondaryActiveTrackColor: Colors.transparent,
              activeTrackColor: Colors.grey,
              trackHeight: 4,
              valueIndicatorColor: Colors.transparent,
              trackShape: const RectangularSliderTrackShape(),
              overlayColor: Colors.transparent,
              tickMarkShape: null,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
              divisions: 20,
              value: state.volume,
              onChanged: (double newVolume) {
                context
                    .read<AudioBloc>()
                    .add(SlideVolumeButton(volume: newVolume));
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
