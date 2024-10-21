import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.width,
    required this.height,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
            ),
          )
        ),
        onPressed: onPressed,
        child: Text(text, style: textTheme.titleLarge,),
      ),
    );
  }
}


/// 초록 버튼
/// width 240 - 루틴 추가 화면 => screenWidth*0.6
class GreenButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const GreenButton({
    this.text  = '완료',
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      width: width,
      height: 40, // 기본 초록 버튼 높이
      color: PRIMARY_COLOR,
      onPressed: onPressed,
    );
  }
}

class GrayButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const GrayButton({
    required this.text,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      width: width,
      height: 40, // 기본 회색 버튼 높이
      color: LIGHT_GREY,
      onPressed: onPressed,
    );
  }
}

class PairedButtons extends StatelessWidget {
  final String greenText;
  final String grayText;
  final VoidCallback onGreenPressed;
  final VoidCallback onGrayPressed;

  const PairedButtons({
    this.greenText = '다음',
    this.grayText = '뒤로 가기',
    required this.onGreenPressed,
    required this.onGrayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GrayButton(text: grayText, width: 120, onPressed: onGrayPressed),
        SizedBox(width: 20,),
        GreenButton(text: greenText, width: 120, onPressed: onGreenPressed),
      ],
    );
  }
}

// class BigGreenButton extends StatelessWidget {
//   final VoidCallback onBigGreenPressed;
//
//   const BigGreenButton({
//     super.key,
//     required this.onBigGreenPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GreenButton(text: '확인', width: 260, onPressed: onBigGreenPressed);
//   }
// }
//
// class MediumGreenButton extends StatelessWidget {
//   final VoidCallback onMediumGreenPressed;
//
//   const MediumGreenButton({
//     super.key,
//     required this.onMediumGreenPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GreenButton(text: '확인', width: 240, onPressed: onMediumGreenPressed);
//   }
// }

