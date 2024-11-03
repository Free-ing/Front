import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class ExerciseReportScreen extends StatelessWidget {
  const ExerciseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IVORY,
      appBar: AppBar(
        backgroundColor: IVORY,
      ),
      body: Center(
        child: Image.asset('assets/imgs/etc/mascot.png'),
      )
    );
  }
}
