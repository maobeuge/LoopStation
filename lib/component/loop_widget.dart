import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopstation/buttons/record_buttons.dart';
import 'package:loopstation/buttons/side_buttons.dart';
import 'package:loopstation/buttons/volume_slider.dart';
import 'package:loopstation/services/audio/audio_bloc.dart';

class LoopWidget extends StatelessWidget {
  const LoopWidget({
    super.key,
    required this.size,
    required this.index,
  });

  final Size size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .6,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff2f2f2f),
        ),
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xff1f1f1f),
      ),
      child: BlocProvider(
        create: (context) => AudioBloc(recordTrack: index)..add(LoadAudio()),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VolumeSlider(),
            RecordButtons(),
            SideButtons(),
          ],
        ),
      ),
    );
  }
}
