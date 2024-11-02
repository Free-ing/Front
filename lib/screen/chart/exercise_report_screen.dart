import 'package:flutter/material.dart';
import 'package:freeing/layout/select_week_layout.dart';

class ExerciseReportScreen extends StatelessWidget {
  const ExerciseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectWeekLayout(
      title: '운동',
      onPressed: () {
        print('운동 버튼');
      },
    );
  }
}
