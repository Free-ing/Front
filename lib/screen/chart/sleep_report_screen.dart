import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';

class SleepReportScreen extends StatelessWidget {
  const SleepReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: '주간 수면 리포트',
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/imgs/etc/report_mascot.png'),
            ],
          ),
        ),
      ),
      color: LIGHT_IVORY,
    );
  }
}
