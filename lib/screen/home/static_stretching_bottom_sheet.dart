import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';


//Todo: 정적 스트레칭
void showStaticStretchingBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('?')],
        ),
      );
    },
  );
}