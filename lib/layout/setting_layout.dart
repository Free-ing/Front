import 'package:flutter/material.dart';

class SettingLayout extends StatefulWidget {
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
  State<SettingLayout> createState() => _SettingLayoutState();
}

class _SettingLayoutState extends State<SettingLayout> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print(widget.isLeftAndRightPadding);
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: widget.isBottom ? null : 0,
          bottom: widget.isBottom ? 0 : null,
          width: screenWidth,
          child: Image.asset(widget.imgAddress, fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: widget.color,
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
              widget.title,
              style: textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.04,
              right: widget.isLeftAndRightPadding ? screenWidth * 0.05 : 0,
              left: widget.isLeftAndRightPadding ? screenWidth * 0.05 : 0,
            ),
            child: widget.child,
          ),

        )
      ],
    );
  }
}
