import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class StressSurveyLoading extends StatelessWidget {
  const StressSurveyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight*0.1),
            Text('후링이 생각중..', style: textTheme.bodyLarge, textAlign: TextAlign.center,),
            Image.asset(
              'assets/imgs/etc/searching_mascot.png',
              width: screenWidth*0.8,
            ),
            CircularProgressIndicator(color: DARK_GREY),
            SizedBox(height: screenHeight*0.1),
          ],
        ),
      ),
    );
  }
}
