import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';

//Todo: 명상
void showMeditationBottomSheet(
  BuildContext context,
  String title,
) {

  showCustomModalBottomSheet(
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
  );
}

class _MeditationBottomSheetContent extends StatefulWidget {
  final String title;
  final TextTheme textTheme;


  const _MeditationBottomSheetContent(
      {super.key,
      required this.title,
      required this.textTheme,
});

  @override
  State<_MeditationBottomSheetContent> createState() =>
      _MeditationBottomSheetContentState();
}

class _MeditationBottomSheetContentState
    extends State<_MeditationBottomSheetContent> {

  //Todo: 서버 요청 (루틴 완료(기록))
  Future<void> _submitMeditationRoutine() async {}

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
        children: [Image.asset('assets/imgs/etc/meditaiton_mascot.png', width: screenWidth * 0.8,)],
      ),
    );
  }
}
