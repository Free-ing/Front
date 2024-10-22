import 'package:flutter/material.dart';

class SurveyLayout extends StatelessWidget {
  final Widget title;
  final Widget body;
  final VoidCallback? onIconPressed;
  const SurveyLayout({super.key, required this.title, required this.body, this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.06,
          screenHeight * 0.08,
          screenWidth * 0.06,
          0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: onIconPressed ?? (){Navigator.of(context).pop();},
                  icon: Icon(Icons.arrow_back_ios_rounded),
                ),
                title,
                SizedBox(width: 35)
              ],
            ),
            body,
          ],
        ),
      ),
    );
  }
}
