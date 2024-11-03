import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
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
      padding: EdgeInsets.zero,
      icon: DecoratedIcon(
        icon: Icon(
          Icons.play_arrow_sharp,
          color: iconColor,
          size: 25,
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
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Image.asset(
          'assets/imgs/home/record_icon.png',
          //width: ,
          //height: MediaQuery.of(context).size.height * 0.03,
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
    DateTime selectedDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          //height: screenHeight * 0.4,
          color: Colors.white,
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
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
                              // 24시간 형식을 controller.text에 저장
                              widget.controller.text = _formatDateTime(selectedDateTime);
                              // AM/PM 형식으로 화면에 표시할 selectedTime 업데이트
                              selectedTime = _formatTimeToAMPM(selectedDateTime);
                              // selectedTime = _formatDateTime(selectedDateTime);
                              // widget.controller.text = selectedTime;
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
                  SizedBox(
                    height: screenHeight * 0.25,
                    child: Localizations.override(
                      context: context,
                      locale: const Locale('en'),
                      child: CustomTimePicker(
                        selectedTime: DateTime.now(),
                        onTimeChanged: (newDateTime) {
                          selectedDateTime = newDateTime;
                          // selectedDuration = newDuration;
                          // print("Selected duration: $newDuration");
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 15:35 형식으로 변환하는 함수 (서버에게 보내는 용도)
  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(dateTime.hour);
    String minutes = twoDigits(dateTime.minute);
    return "$hours:$minutes";
  }

  // AM/PM 형식으로 변환하는 함수
  String _formatTimeToAMPM(DateTime dateTime) {
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    hour = hour == 0 ? 12 : hour; // 0시를 12로 변환
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }



  @override
  Widget build(BuildContext context) {
    final defaultWidth = MediaQuery.of(context).size.width * 0.378;
    final defaultHeight = MediaQuery.of(context).size.height * 0.045;
    final defaultSizedBox = MediaQuery.of(context).size.width * 0.015;

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(
                  width: defaultSizedBox,
                ),
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
  final Widget? targetPage;
  final bool isModal;
  final String modalTitle;
  final String modalContent;
  final VoidCallback? modalOnConfirm;
  final String confirmButtonText;
  //final VoidCallback onTap;

  const SettingTextButton({
    Key? key,
    //required this.icon,
    required this.address,
    required this.text,
    this.targetPage,
    this.isModal = false,
    this.modalTitle = '',
    this.modalContent = '',
    this.modalOnConfirm,
    this.confirmButtonText = '확인',
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
        onTap: () {
          if (isModal) {
            DialogManager.showConfirmDialog(
              context: context,
              title: modalTitle,
              content: modalContent,
              onConfirm: modalOnConfirm!,
              confirmButtonText: confirmButtonText,
            );
          } else if (targetPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage!),
            );
          }
        },
        child: Row(
          children: [
            //Icon(icon, color: Colors.black),
            Image.asset(address),
            SizedBox(width: screenWidth * 0.03),
            Text(text,
                style: textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class UnderlineTextButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final VoidCallback textPressed;

  const UnderlineTextButton({
    required this.text,
    this.fontSize = 14,
    required this.textPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextButton(
        onPressed: textPressed,
        child: Text(text,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.underline,
            )));
  }
}
