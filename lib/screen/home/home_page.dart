import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';
import 'package:freeing/screen/home/hobby_record_bottom_sheet.dart';
import 'package:freeing/screen/home/sleep_record_bottom_sheet.dart';
import 'package:intl/intl.dart';

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

    // formattedDate와 todayDayName 초기화
    formattedDate = DateFormat('yyyy년 MM월 dd일').format(now);
    todayDayName = DateFormat('EEE', 'ko').format(now);

    // dates 리스트 초기화
    dates = List.generate(7, (index) {
      return now.subtract(Duration(days: dayOfWeek - 1 - index));
    });
    final today = DateTime.now();
    selectedIndex = dates.indexWhere((date) =>
    date.year == today.year && date.month == today.month && date.day == today.day);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset('assets/imgs/background/background_image_home.png',
              fit: BoxFit.cover),
        ),
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
                top: screenWidth * 0.33),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(7, (index){
                      final date = dates[index];
                        return GestureDetector(onTap: (){setState(() {
                          selectedIndex = index;
                        });}, child: CircleWidget(dayName: dayNames[index], date: dates[index], isSelected: selectedIndex == index));
                      }),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    // ExpansionTileBox(
                    //     text: '운동', width: 300, lists: ['정적 스트레칭', '걷기']),
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
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
        ),
      ],
    );
  }
}
