import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';

//Todo: 정적 스트레칭
void showStaticStretchingBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return _StaticStretchingBottomSheetContent(
        title: title,
      );
    },
  );
}

class _StaticStretchingBottomSheetContent extends StatefulWidget {
  final String title;

  const _StaticStretchingBottomSheetContent({
    super.key,
    required this.title,
  });

  @override
  State<_StaticStretchingBottomSheetContent> createState() =>
      _StaticStretchingBottomSheetContentState();
}

class _StaticStretchingBottomSheetContentState
    extends State<_StaticStretchingBottomSheetContent> {
  int currentQuestionIndex = 0;
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isPaused = false;
  int _remainingTime = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _playEndSound();
        _nextPose();
      }
    });
  }

  void _playEndSound() async {
    if (!_isMuted) {
      await _audioPlayer.play('assets/audio/end_stretching.mp3' as Source);
    }
  }

  void _nextPose() {
    setState(() {
      _remainingTime = 30;
      currentQuestionIndex++;
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _previousPose() {
    setState(() {
      currentQuestionIndex--;
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _toggleSound() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _togglePausePlay() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer.cancel();
      } else {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseAnimatedBottomSheetContent(
      title: widget.title,
      // 완료 버튼 눌렸을때 실행되는 함수 호출
      onButtonPressed: (AnimationController) async {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _stretchingStage(textTheme),
          SizedBox(height: screenHeight * 0.01),
          _stretchingContent1(textTheme, screenWidth, screenHeight),
          SizedBox(height: screenHeight * 0.01),
          _volumeAndPlayButton()
        ],
      ),
    );
  }

  //Todo: 스트레칭 단계
  Widget _stretchingStage(textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_rounded)),
        Text('1/4', style: textTheme.bodyLarge),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  //Todo: 1. 목 스트레칭(30초) - 왼쪽
  ///앉거나 서서 목을 천천히 한쪽으로 기울여 귀가 어깨에 가까워지도록 합니다.
  Widget _stretchingContent1(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('코브라 자세', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_neck.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '앉거나 서서 목을 천천히 한 쪽으로 기울여\n귀가 어깨에 가까워지도록 합니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 2. 목 스트레칭(30초) - 오른쪽
  ///앉거나 서서 목을 천천히 오른쪽으로 기울여 귀가 어깨에 가까워지도록 합니다.
  Widget _stretchingContent2(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('코브라 자세', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(1.0, -1, 0),
          child: Image.asset(
            'assets/imgs/exercise/static_neck.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '앉거나 서서 목을 천천히 한 쪽으로 기울여\n귀가 어깨에 가까워지도록 합니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _volumeAndPlayButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.volume_up_rounded, size: 40),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.play_arrow_rounded, size: 40),
        )
      ],
    );
  }
}
