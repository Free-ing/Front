import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/dialog_manager.dart';

class StretchingBottomSheetLayout extends StatefulWidget {
  final String title;
  final int totalPose;
  final Set<int> singleRunPoses;
  final List<Widget> stretchingContents;
  final void Function(AnimationController controller) onButtonPressed;

  const StretchingBottomSheetLayout(
      {super.key,
      required this.title,
      required this.totalPose,
      required this.singleRunPoses,
      required this.stretchingContents,
      required this.onButtonPressed});

  @override
  State<StretchingBottomSheetLayout> createState() =>
      _StretchingBottomSheetLayoutState();
}

class _StretchingBottomSheetLayoutState
    extends State<StretchingBottomSheetLayout> {
  int currentPoseIndex = 1;
  int repeatCount = 0; // 반복 횟수
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

  @override
  void dispose() {
    _timer.cancel(); // 타이머 취소
    _audioPlayer.dispose(); // 오디오 플레이어 정리
    _pageController.dispose(); // 페이지 컨트롤러 정리
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        await _playEndSound();
        await _nextPose();
      }
    });
  }

  Future<void> _playEndSound() async {
    if (_isMuted == false) {
      await _audioPlayer.play(AssetSource('audio/end_stretching.mp3'));
    }
  }

  //Todo: 타이머 설정
  void _setTimerForCurrentPose() {
    // currentPoseIndex에 따라 타이머 시간 설정
    if (widget.singleRunPoses.contains(currentPoseIndex)) {
      _remainingTime = 60;
    } else {
      _remainingTime = 30;
    }
  }

  //Todo: 다음 페이지
  Future<void> _nextPose() async {
    setState(
      () {
        if (widget.singleRunPoses.contains(currentPoseIndex) ||
            repeatCount >= 1) {
          repeatCount = 0;
          if (currentPoseIndex < widget.totalPose) {
            currentPoseIndex++;
          }
        } else {
          repeatCount++;
        }
        _setTimerForCurrentPose();

        if (currentPoseIndex <= widget.totalPose-1) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          print('마지막 동작!');
          currentPoseIndex = widget.totalPose-1;
          _timer.cancel(); // 마지막 동작일 때 타이머 종료
          DialogManager.showAlertDialog(
            context: context,
            title:'${widget.title} 종료',
            content: '${widget.title}이 종료 되었습니다.',
           // onConfirm: (){widget.onButtonPressed;}
          );
        }
      },
    );
  }

  //Todo: 이전 페이지
  void _previousPose() {
    setState(
      () {
        if (repeatCount == 1 &&
            !widget.singleRunPoses.contains(currentPoseIndex)) {
          // singleRunPoses에 포함되지 않고 첫 번째 반복 중인 경우
          repeatCount = 0; // 두 번째 반복으로 설정
        } else if (currentPoseIndex > 1) {
          // singleRunPoses에 포함된 경우 또는 두 번째 반복인 경우
          repeatCount = 1;
          currentPoseIndex--;
        }
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );

        _setTimerForCurrentPose();
      },
    );
  }

  //Todo: 소리 토글
  void _toggleSound() {
    setState(() {
      _isMuted = !_isMuted;
      print(_isMuted);
    });
  }

  //Todo: 재생 토글
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

  //Todo: 소리 아이콘
  IconData _getVolumeIcon() {
    return _isMuted ? Icons.volume_off : Icons.volume_up_rounded;
  }

  //Todo: 재생 아이콘
  IconData _getPlayPauseIcon() {
    return _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseAnimatedBottomSheetContent(
      title: widget.title,
      // 완료 버튼 눌렸을때 실행되는 함수 호출,
      onButtonPressed: widget.onButtonPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _stretchingStage(textTheme),
          SizedBox(height: screenHeight * 0.01),
          _viewRemainSeconds(textTheme),
          SizedBox(height: screenHeight * 0.005),
          _viewStretchingContents(screenHeight),
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
        IconButton(
          onPressed: _previousPose,
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        Text('${currentPoseIndex}/${widget.totalPose - 1}',
            style: textTheme.bodyLarge),
        IconButton(
          onPressed: _nextPose,
          icon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  //Todo: 타이머
  Widget _viewRemainSeconds(textTheme){
    return Text(
      '$_remainingTime초',
      style: textTheme.bodyLarge?.copyWith(
        color: _remainingTime > 3 ? Colors.black : Colors.red,
      ),
    );
  }

  //Todo: 스트레칭 내용
  Widget _viewStretchingContents(screenHeight){
    return Container(
      height: screenHeight * 0.45,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: widget.stretchingContents,
      ),
    );
  }

  //Todo: 소리, 재생 버튼
  Widget _volumeAndPlayButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: _toggleSound,
          icon: Icon(_getVolumeIcon(), size: 40),
        ),
        IconButton(
          onPressed: _togglePausePlay,
          icon: Icon(_getPlayPauseIcon(), size: 40),
        )
      ],
    );
  }
}
