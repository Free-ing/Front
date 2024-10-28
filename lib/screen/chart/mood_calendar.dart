import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/screen/chart/mood_scrap.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  DateTime selectedMonth = DateTime.now();
  late int selectedDate = DateTime.now().day as int;
  int year = 2024;
  int month = 10;
  int getFirstDayOfMonth() => DateTime(year, month, 1).weekday;
  int getDaysInMonth() => DateTime(year, month + 1, 0).day;

  // 예시 감정 데이터: 날짜를 키로, 감정 종류를 값으로 저장
  Map<int, String> exampleEmotions = {
    1: "HAPPY",
    3: "CALM",
    5: "ANXIETY",
    6: "ANXIETY",
    8: "ANGRY",
    12: "SAD",
    13: "HAPPY",
    15: "CALM",
    18: "HAPPY",
    21: "ANGRY",
    25: "SAD",
    28: "CALM",
  };

  //Todo: 날짜 update
  Future<void> updateSelectedMonth(DateTime date) async {
    setState(() {
      selectedMonth = date;
      year = selectedMonth.year;
      month = selectedMonth.month;
    });
    //
    // final hobbyAlbums =
    // await _fetchHobbyAlbum(selectedDate.year, selectedDate.month);
    //
    // setState(() {
    //   _hobbyAlbums = hobbyAlbums;
    // });
  }

  //Todo: 감정 별 이미지 경로
  String getEmotionImagePath(String emotion) {
    switch (emotion) {
      case 'HAPPY':
        return 'assets/imgs/mind/emotion_happy.png';
      case 'CALM':
        return 'assets/imgs/mind/emotion_calm.png';
      case 'ANXIETY':
        return 'assets/imgs/mind/emotion_anxiety.png';
      case 'ANGRY':
        return 'assets/imgs/mind/emotion_angry.png';
      case 'SAD':
        return 'assets/imgs/mind/emotion_sad.png';
      default:
        return 'assets/imgs/mind/emotion_none.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int firstDayOfMonth = getFirstDayOfMonth();
    int daysInMonth = getDaysInMonth();

    int rows = ((daysInMonth + firstDayOfMonth - 1) / 7).ceil(); // 달력 row 개수 계산

    return ChartLayout(
        title: '무드 캘린더',
        chartWidget: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            _selectMonthAndScrapPageButton(
                textTheme, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.01),
            // 날짜, 감정 표시
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: screenWidth,
                height: (rows > 5)
                    ? screenHeight * 0.41
                    : (rows > 4)
                        ? screenHeight * 0.34
                        : screenHeight * 0.28,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.014),
                decoration: BoxDecoration(
                  color: LIGHT_IVORY,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: screenHeight * 0.006),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 42,
                    itemBuilder: (context, index) {
                      int dayNumber = index - firstDayOfMonth + 2;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return SizedBox.shrink(); // 날짜 범위 밖일 경우 빈 셀 반환
                      }

                      String emotion = exampleEmotions[dayNumber] ?? "NONE";
                      String imagePath = getEmotionImagePath(emotion);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = dayNumber;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(imagePath, width: screenWidth * 0.115),
                            Text(
                              '$dayNumber',
                              style: textTheme.labelMedium,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),

            if (selectedDate != null)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "기록 조회 화면 - $selectedDate일 기록: ${exampleEmotions[selectedDate] ?? "None"}"))
          ],
        ),
        onDateSelected: updateSelectedMonth);
  }

  Widget _selectMonthAndScrapPageButton(
    TextTheme textTheme,
    double screenWidth,
    double screenHeight,
  ) {
    return SizedBox(
      height: screenHeight * 0.04,
      child: Stack(
        children: [
          Center(
            child: ShowChartDate(
              selectedDate: selectedMonth,
              onDateChanged: updateSelectedMonth,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: screenHeight * 0.03,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoodScrap()));
                },
                child: Text(
                  '스크랩',
                  style: textTheme.bodyMedium,
                ),
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(screenWidth * 0.18, screenHeight * 0.03),
                  backgroundColor: Colors.white,
                  foregroundColor: LIGHT_GREY,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
