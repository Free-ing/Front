import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 커스텀 위젯으로 CupertinoTimerPicker 정의
class CustomTimePicker extends StatefulWidget {
  final Function(Duration) onTimeChanged;

  CustomTimePicker({required this.onTimeChanged});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  Duration selectedDuration = Duration(hours: 1);

  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm, // 시간:분 선택 모드
      initialTimerDuration: selectedDuration,
      onTimerDurationChanged: (newDuration){
        Duration newDurationWithoutSeconds = Duration(
          hours: newDuration.inHours,
          minutes: newDuration.inMinutes.remainder(60),
        );
        setState(() {
          selectedDuration = newDuration;
        });
        widget.onTimeChanged(newDuration);
      },
    );
  }
}

// 모달이 아닌, 아래서 올라오는 Cupertino 타이머 팝업
void showTimePicker(BuildContext context) {
  Duration selectedDuration = Duration(hours: 1);
  final screenHeight = MediaQuery.of(context).size.height;
  final textTheme = Theme.of(context).textTheme;

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
                        child: Text(
                          '취소',
                          style: textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemGrey, fontSize: 18,)
                        ),
                      ),
                      // 확인 버튼
                      TextButton(
                        onPressed: () {
                          // 선택된 시간을 저장하고 팝업 닫기
                          print("Selected duration: $selectedDuration");
                          Navigator.pop(context); // 팝업 닫기
                        },
                        child: Text(
                          '확인',
                          style: textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemGrey, fontSize: 18,)
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTimePicker(
                  onTimeChanged: (newDuration) {
                    // 선택된 시간 처리
                    print("Selected duration: $newDuration");
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