import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

//Todo: 명상
Future<bool> showMeditationBottomSheet(
  BuildContext context,
  String title,
) async {
  final isSuccess = await showCustomModalBottomSheet(
        context: context,
        builder: (
          BuildContext context,
          TextTheme textTheme,
        ) {
          return _MeditationBottomSheetContent(
            title: title,
            textTheme: textTheme,
          );
        },
      ) ??
      false;
  return isSuccess;
}

class _MeditationBottomSheetContent extends StatefulWidget {
  final String title;
  final TextTheme textTheme;

  const _MeditationBottomSheetContent({
    super.key,
    required this.title,
    required this.textTheme,
  });

  @override
  State<_MeditationBottomSheetContent> createState() =>
      _MeditationBottomSheetContentState();
}

class _MeditationBottomSheetContentState
    extends State<_MeditationBottomSheetContent> {
  String imgUrl = 'assets/imgs/etc/meditaiton_mascot.png';
  String audioUrl = 'https://freeingimage.s3.ap-northeast-2.amazonaws.com/meditation_audio.mp3';

  late AudioPlayer player;
  bool isPlaying = false;
  double volume = 1;
  bool isVolumeDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  void _initialize() async {
    player = AudioPlayer();
    await player.setUrl(audioUrl);
    await player.setVolume(volume);
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  //Todo: 서버 요청 (루틴 완료(기록))
  Future<void> _submitMeditationRoutine() async {
    try {
      print('명상하기 루틴 기록 시도오오');
      Navigator.pop(context, true);
    } catch (e) {
      print("루틴 기록하는데 에러 발생");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedStream, duration) => PositionData(
              position, bufferedStream, duration ?? Duration.zero));

  //Todo: 오디오 재생
  void _playAudio() async {
    setState(() {
      isPlaying = true;
    });

    await player.play();
  }

  //Todo: 오디오 일시 정지
  void _pauseAudio() async {
    setState(() {
      isPlaying = false;
    });

    await player.pause();
  }

  IconData _getPlayPauseIcon() {
    return (isPlaying) ? Icons.pause_rounded : Icons.play_arrow_rounded;
  }

  //Todo: 오디오 음량 조절
  void _activateVolume() async {
    await player.setVolume(volume);
    setState(() {
      isVolumeDisabled = false;
    });
  }

  void _disabledVolume() async {
    await player.setVolume(0);
    setState(() {
      if (volume > 0) {
        isVolumeDisabled = true;
      }
    });
  }

  IconData _getVolumeIcon() {
    return (player.volume == 0) ? Icons.volume_off : Icons.volume_up_rounded;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseAnimatedBottomSheetContent(
      title: widget.title,
      onButtonPressed: (AnimationController) async {
        await _submitMeditationRoutine();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/etc/meditaiton_mascot.png',
            width: screenWidth * 0.8,
          ),
          SizedBox(height: screenHeight * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position =
                    positionData?.position.inMilliseconds.toDouble() ?? 0.0;
                final duration =
                    positionData?.duration.inMilliseconds.toDouble() ?? 0.0;

                // 슬라이더의 값이 범위를 초과하지 않도록 제한
                double sliderValue = position.clamp(0.0, duration);

                return Column(
                  children: [
                    Slider(
                      activeColor: ORANGE,
                      min: 0.0,
                      max: duration,
                      value: sliderValue,
                      onChanged: (value) {
                        player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    // 현재 재생 위치와 총 재생 시간을 나타내는 텍스트
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(
                              positionData?.position ?? Duration.zero),
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          _formatDuration(
                              positionData?.duration ?? Duration.zero),
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  switch (isVolumeDisabled) {
                    case true:
                      return _activateVolume();
                    default:
                      return _disabledVolume();
                  }
                },
                icon: Icon(
                  _getVolumeIcon(),
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: isPlaying ? _pauseAudio : _playAudio,
                icon: Icon(
                  _getPlayPauseIcon(),
                  size: 40,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
