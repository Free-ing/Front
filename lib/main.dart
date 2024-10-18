import 'package:flutter/material.dart';
import 'package:freeing/screen/home_page.dart';
import 'package:freeing/screen/member/login.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'scdream',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            // Appbar Title
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            // BottomeSheet Title, setting userName
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            // 모달창 title. 수면 루틴 Title, 완료 버튼, 날짜,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            // 루틴 TapBar, 모달창 버튼, 설문조사 선택지, ai 루틴 이름,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            // 감정일기 조회 제목
            fontSize: 18.0,
          ),
          bodyLarge: TextStyle(
            // 설문조사 질문,
            fontSize: 22.0,
          ),
          bodyMedium: TextStyle(
            // 본문
            fontSize: 16.0,
          ),
          bodySmall: TextStyle(
            // 작은 글씨
            fontSize: 14.0,
          ),
          labelMedium: TextStyle(
            // 제일 작은 글씨
            fontSize: 12.0,
          ),
        ),
      ),
      //home: Login(),
      home: HomePage(),
    ),
  );
}
