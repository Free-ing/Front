import 'package:flutter/material.dart';

class SettingLayout extends StatelessWidget {
  final Widget child;
  final AppBar appBar;

  const SettingLayout({required this.child, required this.appBar, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Positioned(
            top: 0,
            width: screenWidth,
            child: Image.asset(
                'assets/imgs/background/background_image_title.png')),
        Scaffold(
          appBar: appBar,
          body: child,
        )
      ],
    );
  }
}
