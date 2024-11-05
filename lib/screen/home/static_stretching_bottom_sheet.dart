import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/const/colors.dart';

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
    required this.title,
  });

  @override
  State<_StaticStretchingBottomSheetContent> createState() =>
      _StaticStretchingBottomSheetContentState();
}

class _StaticStretchingBottomSheetContentState
    extends State<_StaticStretchingBottomSheetContent> {
  int currentPoseIndex = 1;
  int repeatCount = 0; // 반복 횟수
  int totalPose = 10;
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isPaused = false;
  int _remainingTime = 30;
  late Timer _timer;

  final Set<int> singleRunPoses = {4, 9, 10};

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
    if (currentPoseIndex == 4 ||
        currentPoseIndex == 9 ||
        currentPoseIndex == 10) {
      _remainingTime = 60;
    } else {
      _remainingTime = 30;
    }
  }

  //Todo: 다음 페이지
  Future<void> _nextPose() async {
    setState(
      () {
        if (singleRunPoses.contains(currentPoseIndex) || repeatCount >= 1) {
          repeatCount = 0;
          if (currentPoseIndex < totalPose) {
            currentPoseIndex++;
          }
        } else {
          repeatCount++;
        }

        _setTimerForCurrentPose();

        if (currentPoseIndex <= totalPose) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          _timer.cancel(); // 마지막 동작일 때 타이머 종료
        }
      },
    );
  }

  //Todo: 이전 페이지
  void _previousPose() {
    setState(
          () {
        if (repeatCount == 1 && !singleRunPoses.contains(currentPoseIndex)) {
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
          Text(
            '$_remainingTime초',
            style: textTheme.bodyLarge?.copyWith(
              color: _remainingTime > 3 ? Colors.black : Colors.red,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Container(
            height: screenHeight * 0.45,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                _staticStretchingNeckLeft(textTheme, screenWidth, screenHeight),
                _staticStretchingNeckRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingShoulderLeft(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingShoulderRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingSideLeft(textTheme, screenWidth, screenHeight),
                _staticStretchingSideRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingHipJoint(textTheme, screenWidth, screenHeight),
                _staticStretchingHamstringLeft(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingHamstringRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingCalfLeft(textTheme, screenWidth, screenHeight),
                _staticStretchingCalfRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingSpineLeft(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingSpineRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingThighLeft(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingThighRight(
                    textTheme, screenWidth, screenHeight),
                _staticStretchingCobra(textTheme, screenWidth, screenHeight),
                _staticStretchingBaby(textTheme, screenWidth, screenHeight),
              ],
            ),
          ),
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
        Text('${currentPoseIndex}/${totalPose}',
            style: textTheme.bodyLarge),
        IconButton(
          onPressed: _nextPose,
          icon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  //Todo: 1-1. 목 스트레칭(30초) - 왼쪽(30초)
  Widget _staticStretchingNeckLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('목 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
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

  //Todo: 1-2. 목 스트레칭(30초) - 오른쪽(30초)
  Widget _staticStretchingNeckRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('목 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
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

  //Todo: 2-1. 어깨 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingShoulderLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('어깨 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_shoulder.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 팔을 가슴 앞으로 뻗어\n반대쪽 팔로 잡아 고정합니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 2-2. 어깨 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingShoulderRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('어깨 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_shoulder.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 팔을 가슴 앞으로 뻗어\n반대쪽 팔로 잡아 고정합니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 3-1. 옆구리 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingSideLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('옆구리 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_side.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 팔을 머리 위로 올려\n몸을 반대 방향으로 기울입니다',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 3-2. 옆구리 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingSideRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('옆구리 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_side.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 팔을 머리 위로 올려\n몸을 반대 방향으로 기울입니다',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 4. 고관절 스트레칭(60초)
  Widget _staticStretchingHipJoint(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('고관절 스트레칭 - 나비자세', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_hip_joint.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '나비 자세로 앉아 발바닥을 붙이고\n무릎을 바닥 쪽으로 천천히 눌러줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 5-1. 햄스트링 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingHamstringLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('햄스트링 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_hamstring.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '바르게 누워 한 쪽 다리를 들어올리고\n종아리 뒷편을 잡아줍니다.\n'
          '종아리와 허리가 당기는 느낌이 들도록 위로 올려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 5-2. 햄스트링 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingHamstringRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('햄스트링 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_hamstring.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '바르게 누워 한 쪽 다리를 들어올리고\n종아리 뒷편을 잡아줍니다.\n'
          '종아리와 허리가 당기는 느낌이 들도록 위로 올려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 6-1. 종아리 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingCalfLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('종아리 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_calf.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '벽을 이용해 한쪽 다리를 뒤로 뻗고\n뒤꿈치를 바닥에 대며 종아리를 늘려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 6-1. 종아리 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingCalfRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('종아리 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_calf.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '벽을 이용해 한쪽 다리를 뒤로 뻗고\n뒤꿈치를 바닥에 대며 종아리를 늘려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 7-1. 척추 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingSpineLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('척추 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_spine.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '등을 대고 누워\n한쪽 무릎을 반대쪽으로 넘기며\n척추를 비틀어줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 7-2. 척추 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingSpineRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('척추 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_spine.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '등을 대고 누워\n한쪽 무릎을 반대쪽으로 넘기며\n척추를 비틀어줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 8-1. 허벅지 앞 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingThighLeft(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('허벅지 앞 스트레칭 - 왼쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_thigh.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 다리를 뒤로 굽혀 발목을 잡고\n허벅지 앞쪽을 늘려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 8-2. 허벅지 앞 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingThighRight(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('허벅지 앞 스트레칭 - 오른쪽', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            'assets/imgs/exercise/static_thigh.png',
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '한쪽 다리를 뒤로 굽혀 발목을 잡고\n허벅지 앞쪽을 늘려줍니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 9. 코브라 자세(60초)
  Widget _staticStretchingCobra(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('코브라 자세', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_cobra.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '엎드린 자세에서 손으로 상체를 들어 올려\n척추를 아치형으로 만듭니다.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //Todo: 10.아기 자세(60초)
  Widget _staticStretchingBaby(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Text('아기 자세', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          'assets/imgs/exercise/static_baby.png',
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          '- 무릎을 꿇고 엉덩이를 뒤로 밀어\n이마를 바닥에 대는 자세로 마무리합니다.',
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
