import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/home_expansion_tile.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/default_layout.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';
import 'package:freeing/screen/home/hobby_record_bottom_sheet.dart';
import 'package:freeing/screen/home/sleep_record_bottom_sheet.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';

import 'hobby_record_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy년 MM월 dd일').format(now);

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/imgs/background/background_image_home.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: Image.asset(
            'assets/imgs/home/logo.png',
            width: 200,
            height: 46,
            fit: BoxFit.contain,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.06,
              right: screenWidth * 0.06,
              top: screenWidth * 0.33,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(
                      width: 79.60,
                      height: 30,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side:
                              const BorderSide(width: 1.5, color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          'today',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.1,
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          offset: Offset(2, 4),
                          blurRadius: 4,
                          spreadRadius: 0)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('월'),
                      Text('화'),
                      Text('수'),
                      Text('목'),
                      Text('금'),
                      Text('토'),
                      Text('일'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ExpansionTileBox(
                        text: '운동', width: 300, lists: ['정적 스트레칭', '걷기']),
                    PlayButton(
                        onPressed: () {
                          showExerciseBottomSheet(context, '정적 스트레칭');
                        },
                        iconColor: PINK_PLAY_BUTTON),
                    PlayButton(
                        onPressed: () {
                          showMeditationBottomSheet(context, '명상하기');
                        },
                        iconColor: GREEN_PLAY_BUTTON),
                    LogButton(
                        onPressed: () {
                          showSleepBottomSheet(context, '어젯밤, 잘 잤나요?');
                        },),
                    LogButton(
                      onPressed: () {
                        showDiaryBottomSheet(context, '오늘 하루 어땠나요?');
                      },),
                    LogButton(
                      onPressed: () {
                        showHobbyBottomSheet(context, '오늘 했던 취미는 어땠나요? ');
                      },)
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
        ),
      ],
    );
  }
}
