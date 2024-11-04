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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_back_ios_rounded)),
              Text('1/4'),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios_rounded)),
            ],
          ),
          SizedBox(height: screenHeight*0.02),
          Text('코브라 자세', style: textTheme.bodyLarge),
          SizedBox(height: screenHeight*0.02),
          Image.asset(
            'assets/imgs/etc/meditaiton_mascot.png',
            width: screenWidth * 0.8,
          ),
          SizedBox(height: screenHeight*0.02),
          Text(
            '허리를 곧게 펴고,\n숨을 내쉽니다.\n이동하세여',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight*0.02),
          Row(
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
          )
        ],
      ),
    );
  }
}
