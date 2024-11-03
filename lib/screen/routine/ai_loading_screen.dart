import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class AiLoadingScreen extends StatelessWidget {
  final String category;
  const AiLoadingScreen({super.key, required this.category});

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
            Text('후링이가 \n추천해드릴 $category을(를) 찾고있어요', style: textTheme.bodyLarge, textAlign: TextAlign.center,),
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
