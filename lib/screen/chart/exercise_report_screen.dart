import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';

class ExerciseReportScreen extends StatelessWidget {
  const ExerciseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: '주간 운동 리포트',
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleAndTimeCard(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: '총 운동 시간',
                hour: '00',
                minute: '56',
              ),
              SizedBox(height: screenHeight * 0.028),
              _titleAndTimeCard(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: '일 평균 운동 시간',
                hour: '00',
                minute: '56',
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                '*시작 시각, 종료 시각이 설정된 루틴에 대해서만 측정됩니다.',
                style: textTheme.bodySmall,
              ),
              SizedBox(height: screenHeight * 0.028),
              Text('주간 운동 시간 그래프', style: textTheme.titleSmall),
              Card(
                margin: EdgeInsets.zero,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 1.0),
                ),
                color: LIGHT_GREY,
                child: Container(
                  height: 200,
                )
              )
            ],
          ),
        ),
      ),
      color: LIGHT_IVORY,
    );
  }

  Widget _titleAndTimeCard({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required String title,
    required String hour,
    required String minute,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: screenHeight * 0.053,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.titleMedium),
            Text('$hour H $minute M',
                style: textTheme.titleMedium?.copyWith(color: TEXT_PURPLE)),
          ],
        ),
      ),
    );
  }
}
