import 'package:flutter/material.dart';
import 'package:freeing/layout/select_week_layout.dart';

class SleepReportScreen extends StatelessWidget {
  const SleepReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectWeekLayout(
      title: '수면',
      onPressed: () {
        print('수면 버튼');
      },
    );
  }
}
