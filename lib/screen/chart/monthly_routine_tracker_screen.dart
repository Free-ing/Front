import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/tracker_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/exercise/exercise_tracker.dart';

class MonthlyRoutineTrackerScreen extends StatefulWidget {
  const MonthlyRoutineTrackerScreen({super.key});

  @override
  State<MonthlyRoutineTrackerScreen> createState() =>
      _MonthlyRoutineTrackerScreenState();
}

class _MonthlyRoutineTrackerScreenState
    extends State<MonthlyRoutineTrackerScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final apiService = TrackerApiService();

  List<ExerciseTracker>? exerciseTracker;

  int getFirstDayOfMonth() =>
      DateTime(selectedDate.year, selectedDate.month, 1).weekday;
  int getDaysInMonth() =>
      DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

  @override
  void initState() {
    super.initState();
    startDate = getMonthStartDate(selectedDate);
    endDate = getMonthEndDate(selectedDate);
    //Todo: 서버 요청 보내서 저장하기
    /// 운동
    _fetchExerciseTracker(selectedDate).then((data) {
      setState(() {
        exerciseTracker = data;
      });
    });
  }

  //Todo: 서버 요청 (운동 트래커 조회)
  Future<List<ExerciseTracker>> _fetchExerciseTracker(selectedDate) async {
    final response = await apiService.getExerciseTracker(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print('이거는 운동 데이터~.~.~.~ ${jsonData['result']}');
      if (jsonData != null && jsonData['result'] != null) {
        return (jsonData['result'] as List)
            .map((item) => ExerciseTracker.fromJson(item))
            .toList();
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print(jsonData['error']);
      throw Exception('운동 루틴 트래커 조회 실패 ${response.statusCode}');
    }
  }
  //Todo: 서버 요청 (수면 트래커 조회)
  //Todo: 서버 요청 (마음 채우기 트래커 조회)
  //Todo: 서버 요청 (취미 트래커 조회)

  //Todo: 월 시작 날짜 구하기
  DateTime getMonthStartDate(DateTime selectedDate) {
    return DateTime(selectedDate.year, selectedDate.month, 1);
  }

  //Todo: 월 마지막 날짜 구하기
  DateTime getMonthEndDate(DateTime selectedDate) {
    return DateTime(selectedDate.year, selectedDate.month + 1, 1)
        .subtract(Duration(days: 1));
  }

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
      startDate = getMonthStartDate(selectedDate);
      endDate = getMonthEndDate(selectedDate);
    });

    print('바뀐 startDate!!!: $startDate');
    print('바뀐 endDate!!!: $endDate');

    //Todo: 날짜 변경될 때마다 서버 요청 보내기
    final exercise = await _fetchExerciseTracker(selectedDate);

    setState(() {
      //Todo: 받아온 정보 저장하기
      exerciseTracker = exercise;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int firstDayOfMonth = getFirstDayOfMonth();
    int daysInMonth = getDaysInMonth();
    int rows = ((daysInMonth + firstDayOfMonth - 1) / 7).ceil();

    return ChartLayout(
      title: '루틴 트래커',
      chartWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),

          /// 년, 월 고르기
          ShowChartDate(
            selectedDate: selectedDate,
            onDateChanged: updateSelectedDate,
          ),
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 전체 루틴 트래커
                  _buildAllRoutineTracker(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    daysInMonth: daysInMonth,
                    firstDayOfMonth: firstDayOfMonth,
                    rows: rows,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _trackerOfCategory(
                      textTheme: textTheme,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      daysInMonth: daysInMonth,
                      firstDayOfMonth: firstDayOfMonth,
                      rows: rows,
                      category: '운동',
                      color: EXERCISE_COLOR),
                  SizedBox(height: screenHeight * 0.02),
                  _trackerOfCategory(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    daysInMonth: daysInMonth,
                    firstDayOfMonth: firstDayOfMonth,
                    rows: rows,
                    category: '수면',
                    color: SLEEP_COLOR,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _trackerOfCategory(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    daysInMonth: daysInMonth,
                    firstDayOfMonth: firstDayOfMonth,
                    rows: rows,
                    category: '마음 채우기',
                    color: SPIRIT_COLOR,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _trackerOfCategory(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    daysInMonth: daysInMonth,
                    firstDayOfMonth: firstDayOfMonth,
                    rows: rows,
                    category: '취미',
                    color: HOBBY_COLOR,
                  ),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          )
        ],
      ),
      onDateSelected: updateSelectedDate,
    );
  }

  //Todo: 전체 루틴 달력
  Widget _buildAllRoutineTracker({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
    required int firstDayOfMonth,
    required int rows,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: screenWidth,
        height: (rows > 5)
            ? screenHeight * 0.41 + screenHeight * 0.027
            : (rows > 4)
                ? screenHeight * 0.34 + screenHeight * 0.042
                : screenHeight * 0.29 + screenHeight * 0.042,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: LIGHT_IVORY,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ///전체 루틴 달력 - 요일
            _buildDayOfTheWeek(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: screenWidth * 0.032,
                  mainAxisSpacing: screenHeight * 0.012,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 42,
                itemBuilder: (context, index) {
                  int dayNumber = index - firstDayOfMonth + 2;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }
                  DateTime currentDate = DateTime(
                      selectedDate.year, selectedDate.month, dayNumber);

                  return CustomPaint(
                    size: Size(screenWidth * 0.08, screenWidth * 0.08),
                    painter: ColorfulCirclePainter(
                        date: currentDate,
                        isSelected: false,
                        isAfterToday: false,
                        exerciseDates: [],
                        sleepDates: [],
                        spiritDates: [],
                        hobbyDates: []),
                  );
                },
              ),
            ),

            /// 전체 루틴 달력 - Percentage
            _buildAllRoutinePercentage(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              exercisePercentage: 48,
              sleepPercentage: 85,
              spiritPercentage: 62,
              hobbyPercentage: 57,
            )
          ],
        ),
      ),
    );
  }

  //Todo: 전체 루틴 달력 - 요일
  Widget _buildDayOfTheWeek({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Positioned(
      top: 0,
      left: screenWidth * 0.03,
      right: screenWidth * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var day in ['월', '화', '수', '목', '금', '토', '일'])
            Center(
              child: Text(
                day,
                style: textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  //Todo: 전체 루틴 달력 - Percentage
  Widget _buildAllRoutinePercentage({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int exercisePercentage,
    required int sleepPercentage,
    required int spiritPercentage,
    required int hobbyPercentage,
  }) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: EXERCISE_COLOR,
            percent: exercisePercentage,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: SLEEP_COLOR,
            percent: sleepPercentage,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: SPIRIT_COLOR,
            percent: spiritPercentage,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: HOBBY_COLOR,
            percent: hobbyPercentage,
          ),
        ],
      ),
    );
  }

  //Todo: 루틴 별 Percentage
  Widget _buildPercentageOfRoutine({
    required double screenWidth,
    required double screenHeight,
    required TextTheme textTheme,
    required Color color,
    required int percent,
  }) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.06,
          height: screenWidth * 0.06,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Text('$percent %'),
      ],
    );
  }

  //Todo: 카테고리 별 트래커
  Widget _trackerOfCategory({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
    required int firstDayOfMonth,
    required int rows,
    required String category,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            category,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _buildTrackerListView(
          textTheme: textTheme,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          daysInMonth: daysInMonth,
          firstDayOfMonth: firstDayOfMonth,
          rows: rows,
          color: color,
        )
      ],
    );
  }

  Widget _buildTrackerListView({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
    required int firstDayOfMonth,
    required int rows,
    required Color color,
  }) {
    return SizedBox(
      height: (rows > 5)
          ? screenHeight * 0.243
          : (rows > 4)
              ? screenHeight * 0.213
              : screenHeight * 0.193,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(6),
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              width: screenWidth * 0.42,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                color: LIGHT_GREY,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(width: 1),
                                color: Colors.white,
                              ),
                            ),
                            Image.network(
                              'https://freeingimage.s3.ap-northeast-2.amazonaws.com/static_stretching.png',
                              width: screenWidth * 0.1,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        SizedBox(
                          width: screenWidth * 0.26,
                          height: screenWidth * 0.1,
                          child: Center(
                            child: Text(
                              '10분 스트레칭 정적 스트레칭',
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: screenWidth * 0.37,
                      height: (rows > 5)
                          ? screenHeight * 0.15
                          : (rows > 4)
                              ? screenHeight * 0.122
                              : screenHeight * 0.1,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 42,
                        itemBuilder: (context, index) {
                          int dayNumber = index - firstDayOfMonth + 2;

                          if (dayNumber < 1 || dayNumber > daysInMonth) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            margin: EdgeInsets.zero,
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: screenWidth * 0.01);
        },
      ),
    );
  }
}
