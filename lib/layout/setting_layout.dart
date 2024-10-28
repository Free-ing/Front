import 'package:flutter/material.dart';

class SettingLayout extends StatelessWidget {
  final Color color;
  final String title;
  final String imgAddress;
  final bool isBottom;
  final Widget child;
  final bool isLeftAndRightPadding;
  //final AppBar appBar;

  const SettingLayout({
    this.color = Colors.transparent,
    required this.title,
    this.imgAddress = 'assets/imgs/background/background_image_title.png',
    this.isBottom = false,
    required this.child,
    this.isLeftAndRightPadding = true,
    //required this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: isBottom ? null : 0,
          bottom: isBottom ? 0 : null,
          width: screenWidth,
          child: Image.asset(imgAddress, fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: color,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
              iconSize: 30.0,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            title: Text(
              title,
              style: textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.04,
              right: isLeftAndRightPadding ? screenWidth * 0.05 : 0,
              left: isLeftAndRightPadding ? screenWidth * 0.05 : 0,
            ),
            child: child,
          ),
        )
      ],
    );
  }
}
