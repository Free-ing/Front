// import 'package:flutter/material.dart';
// import 'package:freeing/common/component/loading.dart';
// import 'package:freeing/screen/member/login.dart';
// import 'package:video_player/video_player.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     // VideoPlayerController 초기화
//     _controller = VideoPlayerController.asset('assets/imgs/login/splash.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//
//     // 영상이 끝나면 로그인 화면으로 이동
//     _controller.addListener(() {
//       if (_controller.value.position == _controller.value.duration) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => const Login()));
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _controller.value.isInitialized
//             ? Stack(
//           children: [
//             Positioned.fill(
//               child: FittedBox(
//                 fit: BoxFit.cover, // 화면을 꽉 채우도록 설정
//                 child: SizedBox(
//                   width: _controller.value.size.width,
//                   height: _controller.value.size.height,
//                   child: VideoPlayer(_controller),
//                 ),
//               ),
//             ),
//           ],
//         )
//             : const Loading(),
//
//         // child: _controller.value.isInitialized
//         //     ? FittedBox(
//         //   fit: BoxFit.cover, // Ensures the video covers the screen
//         //   child: SizedBox(
//         //     width: _controller.value.size.width,
//         //     height: _controller.value.size.height,
//         //     child: VideoPlayer(_controller),
//         //   ),
//         // )
//         //     : const CustomCircularProgressIndicator(),
//
//         // child: _controller.value.isInitialized
//         //     ? AspectRatio(
//         //         aspectRatio: _controller.value.aspectRatio,
//         //         child: VideoPlayer(_controller),
//         //       )
//         //     : const CustomCircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/loading.dart';
import 'package:freeing/screen/member/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> images = [
    'assets/imgs/etc/splash_1.png',
    'assets/imgs/etc/splash_2.png',
    'assets/imgs/etc/splash_3.png',
    'assets/imgs/etc/splash_4.png',
    'assets/imgs/etc/splash_5.png',
    'assets/imgs/etc/splash_6.png',
    'assets/imgs/etc/splash_7.png',
    'assets/imgs/etc/splash_8.png',
  ];

  int currentImageIndex = 0;
  Timer? _timer;
  final int imageDisplayDuration = 700; // 1 second per image

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage를 didChangeDependencies에서 호출
    for (String imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
    precacheImage(const AssetImage("assets/imgs/login/login_bottom.png"), context);
    precacheImage(const AssetImage("assets/imgs/login/login_top.png"), context);

  }

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: imageDisplayDuration),
          (timer) {
        if (currentImageIndex < images.length - 1) {
          setState(() {
            currentImageIndex++;
          });
        } else {
          // Navigate to Login screen when the last image finishes
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            //MaterialPageRoute(builder: (context) => const Login()),
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const Login(),
              transitionDuration: Duration.zero, // 애니메이션 제거
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              images[currentImageIndex],
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
