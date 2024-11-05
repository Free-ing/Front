import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/stretching_content_origin.dart';
import 'package:freeing/common/component/stretching_content_reverse.dart';
import 'package:freeing/layout/stretching_bottom_sheet_layout.dart';

//Todo: 동적 스트레칭
void showDynamicStretchingBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return _DynamicStretchingBottomSheetContent(
        title: title,
      );
    },
  );
}

class _DynamicStretchingBottomSheetContent extends StatefulWidget {
  final String title;

  const _DynamicStretchingBottomSheetContent({
    super.key,
    required this.title,
  });

  @override
  State<_DynamicStretchingBottomSheetContent> createState() =>
      _DynamicStretchingBottomSheetContentState();
}

class _DynamicStretchingBottomSheetContentState
    extends State<_DynamicStretchingBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return StretchingBottomSheetLayout(
      title: widget.title,
      totalPose: 7,
      singleRunPoses: {3, 4, 5, 6},
      stretchingContents: [
        _dynamicStretchingNeckLeft(),
        _dynamicStretchinNeckRight(),
        _dynamicStretchingShoulderFront(),
        _dynamicStretchingShoulderBack(),
        _dynamicStretchingArm(),
        _dynamicStretchingKnee(),
        _dynamicStretchingHamstring(),
        _dynamicStretchingSideLunge(),
      ],
      onButtonPressed: (AnimationController) async {
        Navigator.pop(context);
      },
    );
  }

  //Todo: 1-1. 목회전 - 왼쪽 (30초)
  Widget _dynamicStretchingNeckLeft() {
    return StretchingContentOrigin(
      name: '목회전-왼쪽',
      imageUrl: 'assets/imgs/exercise/dynamic_neck.png',
      description:
          '고개를 천천히 시계 방향으로 회전시킵니다.\n목 근육을 이완시키며 준비합니다.',
    );
  }

  //Todo: 1-2. 목회전 - 오른쪽 (30초)
  Widget _dynamicStretchinNeckRight() {
    return StretchingContentReverse(
      name: '목회전-오른쪽',
      imageUrl: 'assets/imgs/exercise/dynamic_neck.png',
      description:
          '고개를 천천히 시계 반대 방향으로 회전시킵니다.\n목 근육을 이완시키며 준비합니다.',
    );
  }

  //Todo: 2-1. 어깨 돌리기 - 앞 (30초)
  Widget _dynamicStretchingShoulderFront() {
    return StretchingContentOrigin(
      name: '어깨 돌리기 - 앞',
      imageUrl: 'assets/imgs/exercise/dynamic_shoulder.png',
      description: '어깨를 크게 앞으로 돌리며 가동성을 높입니다.',
    );
  }

  //Todo: 2-2. 어깨 돌리기 - 뒤 (30초)
  Widget _dynamicStretchingShoulderBack() {
    return StretchingContentReverse(
      name: '어깨 돌리기 - 뒤',
      imageUrl: 'assets/imgs/exercise/dynamic_shoulder.png',
      description: '어깨를 크게 뒤로 돌리며 가동성을 높입니다. ',
    );
  }

  //Todo: 3. 팔 돌리기 (60초)
  Widget _dynamicStretchingArm() {
    return StretchingContentOrigin(
      name: '팔 돌리기',
      imageUrl: 'assets/imgs/exercise/dynamic_arm.png',
      description: '양팔을 좌우로 벌리고, 원을 그리며 팔을 돌립니다.\n작은 원부터 시작해 점차 큰 원으로 늘려주세요.',
    );
  }

  //Todo: 4. 무릎 높이 들기 (60초)
  Widget _dynamicStretchingKnee() {
    return StretchingContentOrigin(
      name: '무릎 높이 들기',
      imageUrl: 'assets/imgs/exercise/dynamic_knee.png',
      description:
          '제자리에서 무릎을 높이 들어올리며\n빠르게 걷는 동작을 반복합니다.\n동작을 부드럽게 유지하면서 속도를 조절하세요.',
    );
  }

  //Todo: 5. 햄스트링 스트레칭 (60초)
  Widget _dynamicStretchingHamstring() {
    return StretchingContentOrigin(
      name: '햄스트링 킥',
      imageUrl: 'assets/imgs/exercise/dynamic_hamstring.png',
      description:
          '한쪽 다리를 앞으로 쭉 펴서\n발끝을 차듯이 올리며 허벅지 뒷쪽을 스트레칭합니다.\n양쪽 다리를 번갈아 가며 반복하세요.',
    );
  }

  //Todo: 6. 사이드 런지 (60초)
  Widget _dynamicStretchingSideLunge() {
    return StretchingContentOrigin(
      name: '사이드 런지',
      imageUrl: 'assets/imgs/exercise/dynamic_side_lunge.png',
      description:
          '다리를 넓게 벌리고,\n한쪽 무릎을 구부리며 옆으로 몸을 이동합니다.\n양쪽을 번갈아 가며 런지를 반복합니다.',
    );
  }
}
