import 'package:flutter/material.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/layout/select_week_layout.dart';
import 'package:freeing/model/exercise/exercise_report_list.dart';
import 'package:freeing/screen/chart/exercise_report_screen.dart';

class SelectExerciseReportScreen extends StatefulWidget {
  const SelectExerciseReportScreen({super.key});

  @override
  State<SelectExerciseReportScreen> createState() => _SelectExerciseReportScreenState();
}

class _SelectExerciseReportScreenState extends State<SelectExerciseReportScreen> {

  @override
  Widget build(BuildContext context) {
    return SelectWeekLayout(
      title: '운동',
      routePage: (startDate, endDate) => ExerciseReportScreen(
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }
}
