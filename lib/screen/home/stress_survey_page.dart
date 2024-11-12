import 'package:flutter/material.dart';
import 'package:freeing/layout/screen_layout.dart';

class StressSurveyPage extends StatelessWidget {
  const StressSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return const ScreenLayout(
        title: '스트레스 검사',
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

            ],
          ),
        ));
  }
}
