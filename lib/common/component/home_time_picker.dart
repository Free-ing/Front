import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 커스텀 위젯으로 CupertinoTimerPicker 정의
class CustomTimePicker extends StatefulWidget {
  final Function(Duration) onTimeChanged;
  final Duration selectedTime;

  CustomTimePicker({required this.onTimeChanged, required this.selectedTime});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  Duration selectedDuration = Duration(hours: 1);

  @override
  void initState(){
    super.initState();
    selectedDuration = widget.selectedTime;
  }

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
          selectedDuration = newDurationWithoutSeconds;
        });
        widget.onTimeChanged(newDurationWithoutSeconds);
      },
    );
  }
}

