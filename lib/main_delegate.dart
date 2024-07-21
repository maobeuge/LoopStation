import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopstation/buttons/send_buttons.dart';
import 'package:loopstation/buttons/side_buttons.dart';
import 'package:loopstation/component/loop_widget.dart';
import 'package:loopstation/services/audio/audio_bloc.dart';

import 'buttons/record_buttons.dart';

void mainDelegate() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff1f1f1f),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Text(
                  "LoopStation - V1.0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return LoopWidget(size: size, index: index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
