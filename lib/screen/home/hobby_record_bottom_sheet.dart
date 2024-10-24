import 'package:flutter/material.dart';

import '../../common/component/bottom_sheet.dart';

//Todo: 감정 일기
void showHobbyBottomSheet(BuildContext context, String title) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            children: [
              Text('?'),
            ],
          ),
        ),
      );
    },
  );
}