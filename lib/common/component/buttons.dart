import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_time_picker.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GrayButton(
            text: grayText, width: screenWidth * 0.3, onPressed: onGrayPressed),
        SizedBox(
          width: 20,
        ),
        GreenButton(
            text: greenText,
            width: screenWidth * 0.3,
            onPressed: onGreenPressed),
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
    // return IconButton(
    //   icon: DecoratedIcon(
    //     icon: Icon(
    //       Icons.edit,
    //       color: Colors.black,
    //       size: 40,
    //     ),
    //     decoration: IconDecoration(
    //       border: IconBorder(color: Colors.black, width: 0.5),
    //     ),
    //   ),
    //   onPressed: onPressed,
    // );
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/imgs/home/record_icon.png',
          width: MediaQuery.of(context).size.width * 0.06,
          height: MediaQuery.of(context).size.height * 0.03,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class TimePickerButton extends StatefulWidget {
  final TextEditingController controller;
  final double? height;
  final double? width;

  TimePickerButton({
    Key? key,
    required this.controller,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<TimePickerButton> createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  String selectedTime = '시간 선택';

  void _showTimePicker() {
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    Duration selectedDuration = Duration(hours: 1);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          //height: screenHeight * 0,
          color: Colors.white,
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    height: screenHeight * 0.05,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 취소 버튼
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 팝업 닫기
                          },
                          child: Text('취소',
                              style: textTheme.bodyMedium?.copyWith(
                                color: CupertinoColors.systemGrey,
                                fontSize: 18,
                              )),
                        ),
                        // 확인 버튼
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedTime = _formatDuration(selectedDuration);
                              widget.controller.text = selectedTime;
                            });
                            //widget.onTimeChanged(selectedDuration);
                            // 선택된 시간을 저장하고 팝업 닫기
                            //print("Selected duration: $selectedDuration");
                            Navigator.pop(context); // 팝업 닫기
                          },
                          child: Text('확인',
                              style: textTheme.bodyMedium?.copyWith(
                                color: CupertinoColors.systemGrey,
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                  ),
                  CustomTimePicker(
                    selectedTime: Duration(hours: 1),
                    onTimeChanged: (duration) {
                      selectedDuration = duration;
                      // selectedDuration = newDuration;
                      // print("Selected duration: $newDuration");
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    final defaultWidth = MediaQuery.of(context).size.width * 0.36;
    final defaultHeight = MediaQuery.of(context).size.height * 0.045;
    final defaultSizedBox = MediaQuery.of(context).size.width * 0.02;

    return Center(
      child: SizedBox(
        height: widget.height ?? defaultHeight,
        width: widget.width ?? defaultWidth,
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
          onPressed: _showTimePicker,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime,
                  style: selectedTime == '시간 선택'
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey)
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                ),
                // SizedBox(
                //   width: defaultSizedBox,
                // ),
                Icon(Icons.access_time_rounded,
                    color:
                        selectedTime == '시간 선택' ? Colors.grey : Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTextButton extends StatelessWidget {
  //final IconData icon;
  final String address;
  final String text;
  final Widget targetPage;
  //final VoidCallback onTap;

  const SettingTextButton({
    Key? key,
    //required this.icon,
    required this.address,
    required this.text,
    required this.targetPage,
    //required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: GestureDetector(
        onTap:  () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        child: Row(
          children: [
            //Icon(icon, color: Colors.black),
            Image.asset(address),
            SizedBox(width: screenWidth * 0.03),
            Text(text, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
