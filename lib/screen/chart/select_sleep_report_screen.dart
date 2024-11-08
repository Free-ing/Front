import 'package:flutter/material.dart';
import 'package:freeing/layout/select_week_layout.dart';
import 'package:freeing/screen/chart/sleep_report_screen.dart';

class SelectSleepReportScreen extends StatelessWidget {
  const SelectSleepReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectWeekLayout(
      title: '수면',
      routePage: SleepReportScreen(),
    );
  }
}
