import 'package:flutter/material.dart';
import 'package:freeing/layout/select_week_layout.dart';
import 'package:freeing/screen/chart/exercise_report_screen.dart';

class SelectExerciseReportScreen extends StatelessWidget {
  const SelectExerciseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectWeekLayout(
      title: '운동',
      routePage: ExerciseReportScreen(),
    );
  }
}
