import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';
import 'package:freeing/screen/home/hobby_record_bottom_sheet.dart';
import 'package:freeing/screen/home/meditation_bottom_sheet.dart';
import 'package:freeing/screen/home/sleep_record_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../common/component/bottom_sheet.dart';
import '../../common/component/expansion_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;
  DateTime now = DateTime.now().toUtc().add(Duration(hours: 9));
  late String formattedDate;
  late String todayDayName;
  late List<DateTime> dates;
  final today = DateTime.now();
  late DateTime currentWeekStartDate;
  // String formattedDate = DateFormat('yyyy년 MM월 dd일').format(now);
  //
  // String todayDayName = DateFormat('EEE', 'ko').format(now);
  // final dayOfWeek = now.weekday;
  // final dates = List.generate(7, (index) {
  //   return now.subtract(Duration(days: dayOfWeek - 1 - index));
  // });

  final dayNames = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    final dayOfWeek = now.weekday;

    currentWeekStartDate = now.subtract(Duration(days: now.weekday - 1));
    _generateDates();

    // formattedDate와 todayDayName 초기화
    formattedDate = DateFormat('yyyy년 MM월 dd일').format(now);
    todayDayName = DateFormat('EEE', 'ko').format(now);

    // dates 리스트 초기화
    dates = List.generate(7, (index) {
      return now.subtract(Duration(days: dayOfWeek - 1 - index));
    });
    selectedIndex = dates.indexWhere((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  void _generateDates() {
    dates = List<DateTime>.generate(
      7,
          (index) => currentWeekStartDate.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SizedBox verticalSpace = SizedBox(
      height: screenHeight * 0.02,
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Image.asset(
                'assets/imgs/background/background_image_home.png',
                fit: BoxFit.cover)),
        Positioned(
            top: 50,
            left: 20,
            child: Image.asset('assets/imgs/home/logo.png',
                width: 200, height: 46, fit: BoxFit.contain)),
        Scaffold(
          backgroundColor: Colors.transparent,
          //backgroundColor: Colors.black,
          body: Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                top: screenWidth * 0.3),
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
                        onPressed: () {
                          setState(() {
                            selectedIndex = dates.indexWhere((date) =>
                                date.year == today.year &&
                                date.month == today.month &&
                                date.day == today.day);
                          });
                        },
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
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.106,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentWeekStartDate = currentWeekStartDate.subtract(Duration(days: 7));
                            _generateDates();
                            selectedIndex = -1; // Reset selection if needed
                          });
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      // Week Days
                      ...List<Widget>.generate(7, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: CircleWidget(
                            dayName: dayNames[index],
                            date: dates[index],
                            isSelected: selectedIndex == index,
                          ),
                        );
                      }),
                      // Next Week Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentWeekStartDate = currentWeekStartDate.add(Duration(days: 7));
                            _generateDates();
                            selectedIndex = -1; // Reset selection if needed
                          });
                        },
                        child: Icon(Icons.arrow_forward_ios),
                      ),

                    ]
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
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
                      },
                    ),
                    LogButton(
                      onPressed: () {
                        showDiaryBottomSheet(
                            context, '오늘 하루 어땠나요?', DateTime.now());
                      },
                    ),
                    LogButton(
                      onPressed: () {
                        showHobbyBottomSheet(context, '오늘 했던 취미는 어땠나요? ');
                      },
                    )
                  ],
                ),
                Container(
                  height: screenHeight * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HomeExpansionTileBox(
                            text: '운동', lists: ['정적 스트레칭', '걷기']),
                        verticalSpace,
                        HomeExpansionTileBox(
                            text: '수면', lists: ['수면 기록하기', '따듯한 물 마시기']),
                        verticalSpace,
                        HomeExpansionTileBox(
                            text: '마음 채우기', lists: ['감정일기 작성', '명상하기']),
                        verticalSpace,
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                              color: LIGHT_IVORY,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: '오늘은 어떤 ',
                                      style: textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '취미',
                                            style: textTheme.bodyMedium?.copyWith(
                                                color: HOME_YELLOW_TEXT,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                          text: '를 했나요?'
                                        )
                                      ]),
                                ),
                                LogButton(
                                  onPressed: () {
                                    showHobbyBottomSheet(
                                        context, '오늘 했던 취미는 어땠나요? ');
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        verticalSpace
                      ],
                    ),
                  ),
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
