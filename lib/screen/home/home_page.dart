import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/home_api_service.dart';
import 'package:freeing/model/home/exercise_daily_routine.dart';
import 'package:freeing/model/home/sleep_daily_routine.dart';
import 'package:freeing/model/home/spirit_daily_routine.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';
import 'package:freeing/screen/home/dynamic_stretching_bottom_sheet.dart';
import 'package:freeing/screen/home/hobby_record_bottom_sheet.dart';
import 'package:freeing/screen/home/meditation_bottom_sheet.dart';
import 'package:freeing/screen/home/sleep_record_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../common/component/expansion_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeApiService = HomeApiService();
  int selectedIndex = -1;
  DateTime now = DateTime.now();
  late String formattedDate;
  late String formattedDateForServer;
  late String todayDayName;
  late List<DateTime> dates;
  final today = DateTime.now();
  late DateTime currentWeekStartDate;
  late DateTime selectedDate;
  List<SleepDailyRoutine> _sleepDailyRoutine = [];
  List<ExerciseRoutineDetail> _exerciseDailyRoutine = [];
  List<SpiritRoutineDetail> _spiritDailyRoutine = [];
  bool isLoading = true;

  final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
  int dayOfWeek = 0;

  // TODO: 운동, 수면, 마음 채우기 루틴 각각 불러오는 서버 요청 하기
  // TODO: 상단 상태바도 각각 다 불러오기
  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        fetchSleepDailyRoutine(),
        fetchExerciseDailyRoutine(),
        fetchSpiritDailyRoutine(),
      ]);
    } catch (e) {
      print(e);
    } finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  // 수면 루틴 불러오기
  Future<void> fetchSleepDailyRoutine() async {
    try {
      final response = await homeApiService.getSleepRoutine(
          dayOfWeek, formattedDateForServer);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData is List) {
          setState(() {
            _sleepDailyRoutine = jsonData
                .map((data) => SleepDailyRoutine.fromJson(data))
                .toList();
          });
        } else {
          print('수면 루틴 불러오기 - Unexpected JSON format');
          setState(() {
            _sleepDailyRoutine = [];
          });
        }
      } else if (response.statusCode == 204) {
        print('수면 루틴에 아무것도 없음');
        setState(() {
          _sleepDailyRoutine = [];
        });
      } else {
        throw Exception('Failed to fetch 수면 list ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching 수면 routines: $e');
      setState(() {
        _sleepDailyRoutine = [];
      });
    }
  }
  bool isSleepRoutineActiveOnDay(SleepDailyRoutine routine, int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return routine.monday ?? false;
      case 2:
        return routine.tuesday ?? false;
      case 3:
        return routine.wednesday ?? false;
      case 4:
        return routine.thursday ?? false;
      case 5:
        return routine.friday ?? false;
      case 6:
        return routine.saturday ?? false;
      case 7:
        return routine.sunday ?? false;
      default:
        return false;
    }
  }
  List<SleepDailyRoutine> getFilteredSleepRoutines() {
    return _sleepDailyRoutine
        .where((routine) =>
            isSleepRoutineActiveOnDay(routine, dayOfWeek) &&
            (routine.status ?? false))
        .toList();
    // final filteredList =  _sleepDailyRoutine
    //     .where((routine) => isRoutineActiveOnDay(routine, dayOfWeek) && (routine.status ?? false))
    //     .map((routine) => routine.sleepRoutineName ?? "")
    //     .toList();
    //
    // return filteredList.isNotEmpty ? filteredList : [];
  }

  // 운동 루틴 불러오기
  Future<void> fetchExerciseDailyRoutine() async {
    try {
      final response =
          await homeApiService.getExerciseRoutine(formattedDateForServer);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('jsonData: $jsonData');
        if (jsonData is Map<String, dynamic> && jsonData['result'] is List) {
          setState(() {
            _exerciseDailyRoutine = (jsonData['result'] as List)
                .map((data) => ExerciseRoutineDetail.fromJson(data))
                .toList();
            print('exercise 루틴 $_exerciseDailyRoutine');
            print('setState까지 성공함');
          });
        } else {
          print('운동 루틴 불러오기 - Unexpected JSON format');
          setState(() {
            _exerciseDailyRoutine = [];
          });
        }
      } else if (response.statusCode == 204) {
        print('운동 루틴에 아무것도 없음');
        setState(() {
          _exerciseDailyRoutine = [];
        });
      } else {
        throw Exception('Failed to fetch 운동 list ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching 운동 routines: $e');
      setState(() {
        _exerciseDailyRoutine = [];
      });
    }
  }
  bool isExerciseRoutineActiveOnDay(ExerciseRoutineDetail routine, int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return routine.monday ?? false;
      case 2:
        return routine.tuesday ?? false;
      case 3:
        return routine.wednesday ?? false;
      case 4:
        return routine.thursday ?? false;
      case 5:
        return routine.friday ?? false;
      case 6:
        return routine.saturday ?? false;
      case 7:
        return routine.sunday ?? false;
      default:
        return false;
    }
  }
  List<ExerciseRoutineDetail> getAllFilteredExerciseRoutines(int dayOfWeek) {
    List<ExerciseRoutineDetail> allActiveRoutines = [];

    for (var routine in _exerciseDailyRoutine) {
      if (isExerciseRoutineActiveOnDay(routine, dayOfWeek) && (routine.status ?? false)) {
        allActiveRoutines.add(routine);
      }
    }

    return allActiveRoutines;
  }

  // 마음 채우기 루틴 불러오기
  Future<void> fetchSpiritDailyRoutine() async {
    try {
      final response =
          await homeApiService.getSpiritRoutine(formattedDateForServer);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('jsonData: $jsonData');
        if (jsonData is Map<String, dynamic> && jsonData['result'] is List) {
          setState(() {
            _spiritDailyRoutine = (jsonData['result'] as List)
                .map((data) => SpiritRoutineDetail.fromJson(data))
                .toList();
            print('spiritDailyROUtine 값!!!! $_spiritDailyRoutine');
          });
        } else {
          print('마음 채우기 불러오기 - Unexpected JSON format');
          setState(() {
            _spiritDailyRoutine = [];
          });
        }
      } else if (response.statusCode == 204) {
        print('마음 채우기 루틴에 아무것도 없음');
        setState(() {
          _spiritDailyRoutine = [];
        });
      } else {
        throw Exception('Failed to fetch 마음 채우기 list ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching 마음 채우기 routines: $e');
      setState(() {
        _spiritDailyRoutine = [];
      });
    }
  }
  bool isSpiritRoutineActiveOnDay(SpiritRoutineDetail routine, int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return routine.monday ?? false;
      case 2:
        return routine.tuesday ?? false;
      case 3:
        return routine.wednesday ?? false;
      case 4:
        return routine.thursday ?? false;
      case 5:
        return routine.friday ?? false;
      case 6:
        return routine.saturday ?? false;
      case 7:
        return routine.sunday ?? false;
      default:
        return false;
    }
  }
  List<SpiritRoutineDetail> getAllFilteredSpiritRoutines(int dayOfWeek) {
    List<SpiritRoutineDetail> allActiveRoutines = [];

    for (var routine in _spiritDailyRoutine) {
      if (isSpiritRoutineActiveOnDay(routine, dayOfWeek) && (routine.status ?? false)) {
        allActiveRoutines.add(routine);
      }
    }
    return allActiveRoutines;
  }

  // TODO: 상단 상태바도 각각 다 불러오기

  @override
  void initState() {
    super.initState();
    dayOfWeek = now.weekday;

    // 현재 주의 시작 날짜 설정
    currentWeekStartDate = getStartOfWeek(now);
    _generateDates();

    // 선택된 날짜를 오늘로 초기화
    selectedDate = today;

    // selectedIndex 초기화 : 오늘의 인덱스 찾음
    selectedIndex = today.weekday - 1;
    if (selectedIndex < 0 || selectedIndex > 6) {
      selectedIndex = 0;
    }

    // formattedDate와 todayDayName 초기화
    formattedDate = DateFormat('yyyy년 MM월 dd일').format(now);
    formattedDateForServer = DateFormat('yyyy-MM-dd').format(now);
    todayDayName = DateFormat('EEE', 'ko').format(now);

    // dates 리스트 초기화
    dates = List.generate(7, (index) {
      return now.subtract(Duration(days: dayOfWeek - 1 - index));
    });

    loadInitialData();
  }

  void _generateDates() {
    dates = List<DateTime>.generate(
      7,
      (index) => currentWeekStartDate.add(Duration(days: index)),
    );
  }

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
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
                    Text(formattedDate,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                    SizedBox(
                      width: 79.60,
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            currentWeekStartDate = getStartOfWeek(today);
                            _generateDates();

                            selectedIndex = today.weekday - 1;
                            if (selectedIndex < 0 || selectedIndex > 6) {
                              selectedIndex = 0;
                            }
                            selectedDate = today;
                            formattedDate = DateFormat('yyyy년 MM월 dd일')
                                .format(selectedDate);
                            todayDayName =
                                DateFormat('EEE', 'ko').format(selectedDate);
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
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          offset: const Offset(2, 4),
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
                              currentWeekStartDate = currentWeekStartDate
                                  .subtract(Duration(days: 7));
                              _generateDates();
                              selectedIndex = today.weekday - 1;
                              if (selectedIndex < 0 || selectedIndex > 6) {
                                selectedIndex = 0;
                              }
                              selectedDate = currentWeekStartDate
                                  .add(Duration(days: selectedIndex));
                              formattedDate = DateFormat('yyyy년 MM월 dd일')
                                  .format(selectedDate);
                              todayDayName =
                                  DateFormat('EEE', 'ko').format(selectedDate);
                            });
                          },
                          child: const Padding(
                            padding:
                                EdgeInsets.only(left: 8.0, top: 25.0),
                            child: Icon(Icons.arrow_back_ios, size: 15),
                          ),
                        ),
                        // Week Days
                        ...List<Widget>.generate(7, (index) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedIndex = index;
                                selectedDate = dates[index];
                                formattedDate = DateFormat('yyyy년 MM월 dd일')
                                    .format(selectedDate);
                                formattedDateForServer =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                                todayDayName = DateFormat('EEE', 'ko')
                                    .format(selectedDate);
                                dayOfWeek = selectedDate.weekday;
                                loadInitialData();
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
                              currentWeekStartDate =
                                  currentWeekStartDate.add(Duration(days: 7));
                              _generateDates();
                              selectedIndex = today.weekday - 1;
                              if (selectedIndex < 0 || selectedIndex > 6) {
                                selectedIndex = 0;
                              }
                              selectedDate = currentWeekStartDate
                                  .add(Duration(days: selectedIndex));
                              formattedDate = DateFormat('yyyy년 MM월 dd일')
                                  .format(selectedDate);
                              todayDayName =
                                  DateFormat('EEE', 'ko').format(selectedDate);
                            });
                          },
                          child: const Padding(
                            padding:
                                EdgeInsets.only(right: 8.0, top: 25.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ),
                        ),
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    PlayButton(
                        onPressed: () {
                          showDynamicStretchingBottomSheet(context, '동적 스트레칭');
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
                            text: '운동',
                            exerciseDailyRoutines:
                                getAllFilteredExerciseRoutines(dayOfWeek), completeDay: formattedDateForServer,),
                        verticalSpace,
                        HomeExpansionTileBox(
                            text: '수면',
                            sleepDailyRoutines: getFilteredSleepRoutines(), completeDay: formattedDateForServer,),
                        verticalSpace,
                        HomeExpansionTileBox(
                          text: '마음 채우기',
                          spiritDailyRoutines:
                              getAllFilteredSpiritRoutines(dayOfWeek), completeDay: formattedDateForServer,
                        ),
                        verticalSpace,
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                              color: LIGHT_IVORY,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 8.0),
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
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: HOME_YELLOW_TEXT,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        const TextSpan(text: '를 했나요?')
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
          bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0),
        ),
      ],
    );
  }
}
