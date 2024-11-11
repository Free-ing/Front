// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:freeing/common/component/home_time_picker.dart';
// import 'package:freeing/screen/home/home_page.dart';
// import 'package:freeing/screen/member/login.dart';
// import 'package:freeing/screen/routine/routine_page.dart';
// import 'package:freeing/screen/setting/setting_page.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       locale: Locale('ko', 'KR'),
//       debugShowCheckedModeBanner: false,
//
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: [
//         Locale('en', 'US'),
//         Locale('ko', 'KR'),
//       ],
//
//       theme: ThemeData(
//         fontFamily: 'scdream',
//         textTheme: TextTheme(
//           headlineLarge: TextStyle(
//             // Appbar Title
//             fontSize: 22.0,
//             fontWeight: FontWeight.w600,
//           ),
//           headlineSmall: TextStyle(
//             // BottomeSheet Title, setting userName
//             color: Colors.white,
//             fontSize: 22.0,
//             fontWeight: FontWeight.w500,
//           ),
//           titleLarge: TextStyle(
//             // 모달창 title. 수면 루틴 Title, 완료 버튼, 날짜,
//             fontSize: 18.0,
//             fontWeight: FontWeight.w500,
//           ),
//           titleMedium: TextStyle(
//             // 루틴 TapBar, 모달창 버튼, 설문조사 선택지, ai 루틴 이름,
//             fontSize: 16.0,
//             fontWeight: FontWeight.w500,
//           ),
//           titleSmall: TextStyle(
//             // 감정일기 조회 제목
//             fontSize: 18.0,
//           ),
//           bodyLarge: TextStyle(
//             // 설문조사 질문,
//             fontSize: 22.0,
//             height: 1.5
//           ),
//           bodyMedium: TextStyle(
//             // 본문
//             fontSize: 16.0,
//           ),
//           bodySmall: TextStyle(
//             // 작은 글씨
//             fontSize: 14.0,
//             height: 1.5,
//           ),
//           labelMedium: TextStyle(
//             // 제일 작은 글씨
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//       home: Login(),
//       //home: RoutinePage(index: 0,),
//     ),
//   );
// }



import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freeing/screen/chart/exercise_report_screen.dart';
import 'package:freeing/screen/chart/monthly_routine_tracker_screen.dart';
import 'package:freeing/screen/home/home_page.dart';
import 'package:freeing/screen/member/login.dart';
import 'package:freeing/screen/member/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'common/component/custom_circular_progress_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // 광고 초기화~~
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화 for SharedPreferences
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ko', 'KR'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        fontFamily: 'scdream',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontSize: 18.0,
          ),
          bodyLarge: TextStyle(
            fontSize: 22.0,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
          ),
          bodySmall: TextStyle(
            fontSize: 14.0,
            height: 1.5,
          ),
          labelMedium: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ),
      home: SplashScreen(),
      // FutureBuilder(
      //   future: _initializeApp(), // 초기화 함수 호출
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CustomCircularProgressIndicator()); // 로딩 스피너 표시
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('오류가 발생했습니다.')); // 오류 메시지
      //     } else {
      //       return SplashScreen(); // 초기화 후 로그인 화면으로 이동
      //     }
      //   },
      // ),
    );
  }

  // // 비동기 초기화 함수 예시
  // Future<void> _initializeApp() async {
  //   // 여기에서 필요한 초기화 작업 수행
  //   //await Future.delayed(Duration(seconds: 2)); // 예시로 지연 시간을 추가
  // }
}
