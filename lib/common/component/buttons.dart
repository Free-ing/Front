import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'bottom_sheet.dart';

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
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: textTheme.titleLarge,
        ),
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
    this.text = '완료',
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
        SizedBox(
          width: 20,
        ),
        GreenButton(text: greenText, width: 120, onPressed: onGreenPressed),
      ],
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color iconColor;

  const PlayButton({
    required this.onPressed,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DecoratedIcon(
        icon: Icon(
          Icons.play_arrow_rounded,
          color: iconColor,
          size: 40,
        ),
        decoration: IconDecoration(
          border: IconBorder(color: Colors.black, width: 3),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class LogButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DecoratedIcon(
        icon: Icon(
          Icons.edit_note_rounded,
          color: Colors.black,
          size: 40,
        ),
        decoration: IconDecoration(
          border: IconBorder(color: Colors.black, width: 0.5),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class TimePickerButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Function() onPressed;

  TimePickerButton({
    Key? key,
    this.height,
    this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultWidth = MediaQuery.of(context).size.width * 0.36;
    final defaultHeight = MediaQuery.of(context).size.height * 0.04;
    final defaultSizedBox = MediaQuery.of(context).size.width * 0.02;

    return Center(
      child: SizedBox(
        height: height ?? defaultHeight,
        width: width ?? defaultWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  width: 1,
                ),
              )),
          onPressed: onPressed,
          child: Center(
            child: Row(
              children: [
                Text(
                  '시간 선택',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: defaultSizedBox,
                ),
                const Icon(Icons.access_time_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}