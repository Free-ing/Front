import 'package:flutter/material.dart';

class SettingLayout extends StatelessWidget {
  final Color color;
  final String title;
  final String imgAddress;
  final bool isBottom;
  final Widget child;
  //final AppBar appBar;

  const SettingLayout({
    this.color = Colors.transparent,
    required this.title,
    this.imgAddress = 'assets/imgs/background/background_image_title.png',
    this.isBottom = false,
    required this.child,
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

            // title: Padding(
            //   padding: EdgeInsets.only(top: screenHeight * 0.03),
            //   child: Expanded(
            //     child: Row(
            //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Align(
            //           alignment: Alignment.centerLeft,
            //           child: IconButton(
            //             onPressed: () {
            //               Navigator.of(context).pop();
            //             },
            //             icon: Icon(Icons.arrow_back_ios_rounded),
            //             iconSize: 30.0,
            //             padding: EdgeInsets.zero,
            //             constraints: BoxConstraints(),
            //           ),
            //         ),
            //         Align(
            //             alignment: Alignment.center,
            //             child: Text(
            //               title,
            //               style: textTheme.headlineLarge,
            //               textAlign: TextAlign.center,
            //             )),
            //       ],
            //     ),
            //   ),
            // ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.04,
              right: screenWidth * 0.05,
              left: screenWidth * 0.05,
            ),
            child: child,
          ),
        )
      ],
    );
  }
}
