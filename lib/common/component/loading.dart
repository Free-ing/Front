import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final List<String> images = ['assets/imgs/etc/loading_off.png', 'assets/imgs/etc/loading_on.png'];
  int currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const maxSize = 300.0;

        // Check if there's enough space for a large image
        bool isLarge = constraints.maxWidth > maxSize && constraints.maxHeight > maxSize;

        return Container(
          color: Colors.white,
          child: Center(
            child: isLarge
                ? Image.asset(
              images[currentImageIndex],
              width: maxSize, // Limit width to maxSize
              height: maxSize, // Limit height to maxSize
              fit: BoxFit.contain,
            )
                : const SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                color: PRIMARY_COLOR,
                strokeWidth: 4.0,
              ),
            ),
          ),
        );
      },
    );
    // return Container(
    //   color: Colors.white,
    //   child: Center(
    //     child: Image.asset(
    //       images[currentImageIndex],
    //       // TODO: 홈 - 수면 로드할떄 여기땜에 오류나는 것 같음
    //       width: double.infinity,
    //       height: double.infinity,
    //       fit: BoxFit.contain,
    //     ),
    //   ),
    // );
  }
}
