import 'package:flutter/material.dart';

class SurveyLayout extends StatelessWidget {
  final Widget title;
  final Widget body;
  const SurveyLayout({super.key, required this.title, required this.body});

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
                  iconSize: 45.0,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.chevron_left),
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
