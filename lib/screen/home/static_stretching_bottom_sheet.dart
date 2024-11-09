import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/stretching_content_origin.dart';
import 'package:freeing/common/component/stretching_content_reverse.dart';
import 'package:freeing/layout/stretching_bottom_sheet_layout.dart';

//Todo: 정적 스트레칭
Future<bool> showStaticStretchingBottomSheet(
    BuildContext context, String title) async {
  final isSuccess = await showCustomModalBottomSheet(
        context: context,
        builder: (BuildContext context, TextTheme textTheme) {
          return _StaticStretchingBottomSheetContent(
            title: title,
          );
        },
      ) ??
      false;
  return isSuccess;
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
  Widget build(BuildContext context) {
    return StretchingBottomSheetLayout(
      title: widget.title,
      totalPose: 11,
      singleRunPoses: {4, 9, 10},
      stretchingContents: [
        _staticStretchingNeckLeft(),
        _staticStretchingNeckRight(),
        _staticStretchingShoulderLeft(),
        _staticStretchingShoulderRight(),
        _staticStretchingSideLeft(),
        _staticStretchingSideRight(),
        _staticStretchingHipJoint(),
        _staticStretchingHamstringLeft(),
        _staticStretchingHamstringRight(),
        _staticStretchingCalfLeft(),
        _staticStretchingCalfRight(),
        _staticStretchingSpineLeft(),
        _staticStretchingSpineRight(),
        _staticStretchingThighLeft(),
        _staticStretchingThighRight(),
        _staticStretchingCobra(),
        _staticStretchingBaby(),
      ],
      onButtonPressed: (AnimationController) async {
        Navigator.pop(context, true);
      },
    );
  }

  //Todo: 1-1. 목 스트레칭 - 왼쪽 (30초)
  Widget _staticStretchingNeckLeft() {
    return StretchingContentReverse(
      name: '목 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_neck.png',
      description: '앉거나 서서 목을 천천히 한 쪽으로 기울여\n귀가 어깨에 가까워지도록 합니다.',
    );
  }

  //Todo: 1-2. 목 스트레칭(30초) - 오른쪽(30초)
  Widget _staticStretchingNeckRight() {
    return StretchingContentReverse(
      name: '목 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_neck.png',
      description: '앉거나 서서 목을 천천히 한 쪽으로 기울여\n귀가 어깨에 가까워지도록 합니다.',
    );
  }

  //Todo: 2-1. 어깨 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingShoulderLeft() {
    return StretchingContentOrigin(
      name: '어깨 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_shoulder.png',
      description: '한쪽 팔을 가슴 앞으로 뻗어\n반대쪽 팔로 잡아 고정합니다.',
    );
  }

  //Todo: 2-2. 어깨 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingShoulderRight() {
    return StretchingContentReverse(
      name: '어깨 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_shoulder.png',
      description: '한쪽 팔을 가슴 앞으로 뻗어\n반대쪽 팔로 잡아 고정합니다.',
    );
  }

  //Todo: 3-1. 옆구리 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingSideLeft() {
    return StretchingContentOrigin(
      name: '옆구리 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_side.png',
      description: '한쪽 팔을 머리 위로 올려\n몸을 반대 방향으로 기울입니다',
    );
  }

  //Todo: 3-2. 옆구리 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingSideRight() {
    return StretchingContentReverse(
      name: '옆구리 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_side.png',
      description: '한쪽 팔을 머리 위로 올려\n몸을 반대 방향으로 기울입니다',
    );
  }

  //Todo: 4. 고관절 스트레칭(60초)
  Widget _staticStretchingHipJoint() {
    return StretchingContentOrigin(
      name: '고관절 스트레칭 - 나비자세',
      imageUrl: 'assets/imgs/exercise/static_hip_joint.png',
      description: '나비 자세로 앉아 발바닥을 붙이고\n무릎을 바닥 쪽으로 천천히 눌러줍니다.',
    );
  }

  //Todo: 5-1. 햄스트링 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingHamstringLeft() {
    return StretchingContentOrigin(
      name: '햄스트링 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_hamstring.png',
      description: '바르게 누워 한 쪽 다리를 들어올리고\n종아리 뒷편을 잡아줍니다.\n'
          '종아리와 허리가 당기는 느낌이 들도록 위로 올려줍니다.',
    );
  }

  //Todo: 5-2. 햄스트링 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingHamstringRight() {
    return StretchingContentReverse(
      name: '햄스트링 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_hamstring.png',
      description: '바르게 누워 한 쪽 다리를 들어올리고\n종아리 뒷편을 잡아줍니다.\n'
          '종아리와 허리가 당기는 느낌이 들도록 위로 올려줍니다.',
    );
  }

  //Todo: 6-1. 종아리 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingCalfLeft() {
    return StretchingContentOrigin(
      name: '종아리 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_calf.png',
      description: '벽을 이용해 한쪽 다리를 뒤로 뻗고\n뒤꿈치를 바닥에 대며 종아리를 늘려줍니다.',
    );
  }

  //Todo: 6-1. 종아리 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingCalfRight() {
    return StretchingContentReverse(
      name: '종아리 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_calf.png',
      description: '벽을 이용해 한쪽 다리를 뒤로 뻗고\n뒤꿈치를 바닥에 대며 종아리를 늘려줍니다.',
    );
  }

  //Todo: 7-1. 척추 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingSpineLeft() {
    return StretchingContentOrigin(
      name: '척추 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_spine.png',
      description: '등을 대고 누워\n한쪽 무릎을 반대쪽으로 넘기며\n척추를 비틀어줍니다.',
    );
  }

  //Todo: 7-2. 척추 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingSpineRight() {
    return StretchingContentReverse(
      name: '척추 스트레칭 - 오른쪽',
      imageUrl: 'assets/imgs/exercise/static_spine.png',
      description: '등을 대고 누워\n한쪽 무릎을 반대쪽으로 넘기며\n척추를 비틀어줍니다.',
    );
  }

  //Todo: 8-1. 허벅지 앞 스트레칭 - 왼쪽(30초)
  Widget _staticStretchingThighLeft() {
    return StretchingContentOrigin(
      name: '허벅지 앞 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_thigh.png',
      description: '한쪽 다리를 뒤로 굽혀 발목을 잡고\n허벅지 앞쪽을 늘려줍니다.',
    );
  }

  //Todo: 8-2. 허벅지 앞 스트레칭 - 오른쪽(30초)
  Widget _staticStretchingThighRight() {
    return StretchingContentReverse(
      name: '허벅지 앞 스트레칭 - 왼쪽',
      imageUrl: 'assets/imgs/exercise/static_thigh.png',
      description: '한쪽 다리를 뒤로 굽혀 발목을 잡고\n허벅지 앞쪽을 늘려줍니다.',
    );
  }

  //Todo: 9. 코브라 자세(60초)
  Widget _staticStretchingCobra() {
    return StretchingContentOrigin(
      name: '코브라 자세',
      imageUrl: 'assets/imgs/exercise/static_cobra.png',
      description: '엎드린 자세에서 손으로 상체를 들어 올려\n척추를 아치형으로 만듭니다.',
    );
  }

  //Todo: 10.아기 자세(60초)
  Widget _staticStretchingBaby() {
    return StretchingContentOrigin(
      name: '아기 자세',
      imageUrl: 'assets/imgs/exercise/static_baby.png',
      description: '무릎을 꿇고 엉덩이를 뒤로 밀어\n이마를 바닥에 대는 자세로 마무리합니다.',
    );
  }

  // //Todo: 소리, 재생 버튼
  // Widget _volumeAndPlayButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       IconButton(
  //         onPressed: _toggleSound,
  //         icon: Icon(_getVolumeIcon(), size: 40),
  //       ),
  //       IconButton(
  //         onPressed: _togglePausePlay,
  //         icon: Icon(_getPlayPauseIcon(), size: 40),
  //       )
  //     ],
  //   );
  // }
}
