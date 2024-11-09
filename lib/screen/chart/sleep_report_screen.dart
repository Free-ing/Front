import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';

class SleepReportScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SleepReportScreen(
      {super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: '주간 수면 리포트',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.028),
            Image.asset('assets/imgs/etc/report_mascot.png'),
          ],
        ),
      ),
      color: LIGHT_IVORY,
    );
  }
}
