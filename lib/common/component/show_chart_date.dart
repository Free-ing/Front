import 'package:flutter/material.dart';

class ShowChartDate extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged; // 날짜 변경을 위한 콜백

  const ShowChartDate({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // 이전 날짜로 이동
            onDateChanged(DateTime(selectedDate.year, selectedDate.month - 1));
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16),
        ),
        Text(
          "${selectedDate.year}년 ${selectedDate.month}월", // 선택된 날짜 표시
          style: textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () {
            // 다음 날짜로 이동
            onDateChanged(DateTime(selectedDate.year, selectedDate.month + 1));
          },
          icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ),
      ],
    );
  }
}
