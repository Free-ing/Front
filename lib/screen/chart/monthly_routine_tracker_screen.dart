import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/component/custom_circular_progress_indicator.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/tracker_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/exercise/exercise_tracker.dart';
import 'package:freeing/model/hobby/hobby_tracker.dart';
import 'package:freeing/model/sleep/sleep_tracker.dart';
import 'package:freeing/model/spirit/spirit_tracker.dart';
import 'package:intl/intl.dart';

class MonthlyRoutineTrackerScreen extends StatefulWidget {
  const MonthlyRoutineTrackerScreen({super.key});

  @override
  State<MonthlyRoutineTrackerScreen> createState() =>
      _MonthlyRoutineTrackerScreenState();
}

class _MonthlyRoutineTrackerScreenState
    extends State<MonthlyRoutineTrackerScreen> {
  bool _isLoading = true;

  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final apiService = TrackerApiService();

  List<ExerciseTracker> exerciseTracker = [];
  SleepTracker sleepTracker = SleepTracker(routineRecords: [], timeRecords: []);
  List<SpiritTracker> spiritTracker = [];
  List<HobbyTracker> hobbyTracker = [];

  List<String> exerciseDates = [];
  List<String> spiritDates = [];
  List<String> hobbyDates = [];

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
    _initializeTracker();
  }

  //Todo: 초기화
  Future<void> _initializeTracker() async {
    try {
      await _getExerciseTracker(selectedDate);
      _fetchSleepTracker(startDate, endDate).then((data) {
        setState(() {
          sleepTracker = data;
        });
      });
      await _getSpiritTracker(selectedDate);
      await _getHobbyTracker(selectedDate);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Todo: 운동 트래커 조회 하고 수행 날짜 리스트 만들기
  Future<void> _getExerciseTracker(selectedDate) async {
    try {
      await _fetchExerciseTracker(selectedDate).then((data) {
        setState(() {
          exerciseTracker = data;
          exerciseDates = _getUniqueRoutineDates(exerciseTracker);
        });
        print(exerciseTracker);
      });
    } catch (e) {
      print('Error Fetching Exercise Data: $e');
    }
  }

  //Todo: 마음 채우기 트래커 조회 하고 수행 날짜 리스트 만들기
  Future<void> _getSpiritTracker(selectedDate) async {
    try {
      await _fetchSpiritTracker(selectedDate).then((data) {
        setState(() {
          spiritTracker = data;
          spiritDates = _getUniqueRoutineDates(spiritTracker);
        });
      });
    } catch (e) {
      print('Error Fetching Exercise Data: $e');
    }
  }

  //Todo: 취미 트래커 조회 하고 수행 날짜 리스트 만들기
  Future<void> _getHobbyTracker(selectedDate) async {
    try {
      await _fetchHobbyTracker(selectedDate).then((data) {
        setState(() {
          hobbyTracker = data;
          hobbyDates = _getUniqueRoutineDates(hobbyTracker);
        });
      });
    } catch (e) {
      print('Error Fetching Exercise Data: $e');
    }
  }

  //Todo: 서버 요청 (운동 트래커 조회)
  Future<List<ExerciseTracker>> _fetchExerciseTracker(selectedDate) async {
    final response = await apiService.getExerciseTracker(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print('이거는 운동 트래커~.~.~.~ ${jsonData['result']}');
      if (jsonData != null && jsonData['result'] != null) {
        return (jsonData['result'] as List)
            .map((item) => ExerciseTracker.fromJson(item))
            .toList();
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      throw Exception('운동 루틴 트래커 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (수면 트래커 조회)
  Future<SleepTracker> _fetchSleepTracker(startDate, endDate) async {
    final response = await apiService.getSleepTracker(startDate, endDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print('이거는 수면 트래커@.@.@.@ ${jsonData['result']}');

      if (jsonData != null && jsonData['result'] != null) {
        // return (jsonData['result'] as List)
        //     .map((item) => SleepTracker.fromJson(item))
        //     .toList();
        return SleepTracker.fromJson(jsonData['result']);
      } else if (jsonData == null || jsonData['result'] == null) {
        print('이거는 수면 트래커@.@.@.@ ${jsonData['result']} 없지롱!');
        return SleepTracker(routineRecords: [], timeRecords: []);
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else if (response.statusCode == 204) {
      print('없어!! 수면에 대한 기록이');
      return SleepTracker(routineRecords: [], timeRecords: []);
    } else {
      throw Exception('수면 루틴 트래커 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (마음 채우기 트래커 조회)
  Future<List<SpiritTracker>> _fetchSpiritTracker(selectedDate) async {
    final response = await apiService.getSpiritTracker(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print('이거는 마음 채우기 트래커 &.&.&.& ${jsonData['result']}');
      if (jsonData != null && jsonData['result'] != null) {
        return (jsonData['result'] as List)
            .map((item) => SpiritTracker.fromJson(item))
            .toList();
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      throw Exception('마음 채우기 루틴 트래커 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (취미 트래커 조회)
  Future<List<HobbyTracker>> _fetchHobbyTracker(selectedDate) async {
    final response = await apiService.getHobbyTracker(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print('이거는 취미 기록 트래커 ^.^.^.^ ${jsonData['result']}');
      if (jsonData != null && jsonData['result'] != null) {
        return (jsonData['result'] as List)
            .map((item) => HobbyTracker.fromJson(item))
            .toList();
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      throw Exception('취미 기록 트래커 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 날짜 추출
  List<String> _getUniqueRoutineDates(List<dynamic> trackers) {
    Set<String> uniqueDates = {};

    for (var tracker in trackers) {
      for (var record in tracker.records) {
        uniqueDates.add(record.routineDate);
      }
    }
    print('확인~~~~~~~~~~~~~~~~! $uniqueDates');
    return uniqueDates.toList();
  }

  //Todo: 월 시작 날짜 구하기
  DateTime getMonthStartDate(DateTime selectedDate) {
    return DateTime(selectedDate.year, selectedDate.month, 1);
  }

  //Todo: 월 마지막 날짜 구하기
  DateTime getMonthEndDate(DateTime selectedDate) {
    return DateTime(selectedDate.year, selectedDate.month + 1, 1)
        .subtract(const Duration(days: 1));
  }

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
      startDate = getMonthStartDate(selectedDate);
      endDate = getMonthEndDate(selectedDate);
      _isLoading = true;
    });

    print('바뀐 startDate!!!: $startDate');
    print('바뀐 endDate!!!: $endDate');

    //Todo: 날짜 변경될 때마다 서버 요청 보내기
    try {
      final exercise = await _fetchExerciseTracker(selectedDate);
      final sleep = await _fetchSleepTracker(startDate, endDate);
      final spirit = await _fetchSpiritTracker(selectedDate);
      final hobby = await _fetchHobbyTracker(selectedDate);

      setState(() {
        //Todo: 받아온 정보 저장하기
        exerciseTracker = exercise;
        sleepTracker = sleep;
        spiritTracker = spirit;
        hobbyTracker = hobby;

        exerciseDates = _getUniqueRoutineDates(exercise);
        spiritDates = _getUniqueRoutineDates(spirit);
        hobbyDates = _getUniqueRoutineDates(hobby);
      });
    } catch (e) {
      print('Error Fetching tracker data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int firstDayOfMonth = getFirstDayOfMonth();
    int daysInMonth = getDaysInMonth();
    int rows = ((daysInMonth + firstDayOfMonth - 1) / 7).ceil();

    if (_isLoading) {
      return const CustomCircularProgressIndicator();
    }
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
                      color: EXERCISE_COLOR,
                      routineList: exerciseTracker),
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
                    routineList: sleepTracker.routineRecords,
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
                    routineList: spiritTracker,
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
                    routineList: hobbyTracker,
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
            _buildRoutineColorCircle(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              daysInMonth: daysInMonth,
              firstDayOfMonth: firstDayOfMonth,
              rows: rows,
            ),

            /// 전체 루틴 달력 - Percentage
            _buildAllRoutinePercentage(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              daysInMonth: daysInMonth,
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

  //Todo: 전체 루틴 달력 - 달력 부분
  Widget _buildRoutineColorCircle({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
    required int firstDayOfMonth,
    required int rows,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
      child: GridView.builder(
        key: ValueKey(selectedDate),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: screenWidth * 0.032,
          mainAxisSpacing: screenHeight * 0.012,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 42,
        itemBuilder: (context, index) {
          int dayNumber = index - firstDayOfMonth + 2;
          DateTime currentDate =
              DateTime(selectedDate.year, selectedDate.month, dayNumber);
          if (dayNumber < 1 || dayNumber > daysInMonth) {
            return const SizedBox.shrink();
          }

          return CustomPaint(
            size: Size(screenWidth * 0.08, screenWidth * 0.08),
            painter: ColorfulCirclePainter(
                date: currentDate,
                isSelected: false,
                isAfterToday: false,
                exerciseDates: exerciseDates,
                sleepDates: sleepTracker.timeRecords,
                spiritDates: spiritDates,
                hobbyDates: hobbyDates),
          );
        },
      ),
    );
  }

  //Todo: 전체 루틴 달력 - Percentage
  Widget _buildAllRoutinePercentage({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
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
            daysInMonth: daysInMonth,
            length: exerciseDates.length,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: SLEEP_COLOR,
            daysInMonth: daysInMonth,
            length: sleepTracker.timeRecords.length,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: SPIRIT_COLOR,
            daysInMonth: daysInMonth,
            length: spiritDates.length,
          ),
          _buildPercentageOfRoutine(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTheme: textTheme,
            color: HOBBY_COLOR,
            daysInMonth: daysInMonth,
            length: hobbyDates.length,
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
    required int daysInMonth,
    required int length,
  }) {
    int percent = (length / daysInMonth * 100 ).ceil();
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
    required List<dynamic> routineList,
  }) {
    return Visibility(
      visible: routineList.length == 0 ? false : true,
      child: Column(
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
            routineList: routineList,
          )
        ],
      ),
    );
  }

  //Todo: 트래커 보여줘
  Widget _buildTrackerListView({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int daysInMonth,
    required int firstDayOfMonth,
    required int rows,
    required Color color,
    required List<dynamic> routineList,
  }) {
    return SizedBox(
      height: (rows > 5)
          ? screenHeight * 0.243
          : (rows > 4)
              ? screenHeight * 0.213
              : screenHeight * 0.193,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: routineList.length,
        itemBuilder: (context, index) {
          final routine = routineList[index];
          final routineDates =
              routine.records.map((record) => record.routineDate).toList();

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
                            routine.imageUrl != ''
                                ? Image.network(
                                    routine.imageUrl,
                                    width: screenWidth * 0.1,
                                    fit: BoxFit.contain,
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        SizedBox(
                          width: screenWidth * 0.26,
                          height: screenWidth * 0.1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              routine.routineName,
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
                          // 현재 dayNumber를 DateTime으로 변환해 기록된 날짜들과 비교
                          final currentDate = DateTime(
                              selectedDate.year, selectedDate.month, dayNumber);
                          final formattedDate =
                              "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${dayNumber.toString().padLeft(2, '0')}";
                          // formattedDate가 routineDates에 포함되면 색깔 표시
                          final containerColor =
                              routineDates.contains(formattedDate)
                                  ? color
                                  : Colors.white;

                          return Container(
                            margin: EdgeInsets.zero,
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              color: containerColor,
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
