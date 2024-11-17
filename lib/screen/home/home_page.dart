import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/circle_widget.dart';
import 'package:freeing/common/component/loading.dart';
import 'package:freeing/common/component/question_mark.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/home_api_service.dart';
import 'package:freeing/model/home/exercise_daily_routine.dart';
import 'package:freeing/model/home/sleep_daily_routine.dart';
import 'package:freeing/model/home/spirit_daily_routine.dart';
import 'package:freeing/model/home/stress_level_response.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/home/hobby_record_bottom_sheet.dart';
import 'package:freeing/screen/home/stress_survey_page.dart';
import 'package:intl/intl.dart';

import '../../common/component/expansion_tile.dart';
import '../../common/service/sleep_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeApiService = HomeApiService();
  final sleepApiService = SleepAPIService();
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
  StressLevelResponse? _stressLevelResponse;
  List<String> exerciseDates = [];
  List<String> sleepDates = [];
  List<String> spiritDates = [];
  List<String> hobbyDates = [];

  bool isLoading = true;
  bool? sleepRecordCompleted;

  final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
  int dayOfWeek = 0;

  // 운동, 수면, 마음 채우기 루틴 각각 불러오기 & 상단 상태바 불러오기 && 스트레스 지수
  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });
    DateTime startDate = getStartOfWeek(selectedDate);
    DateTime endDate = getEndOfWeek(selectedDate);

    try {
      await Future.wait([
        fetchSleepDailyRoutine(),
        fetchExerciseDailyRoutine(),
        fetchSpiritDailyRoutine(),
        fetchRoutineRecords(
          DateFormat('yyyy-MM-dd').format(startDate),
          DateFormat('yyyy-MM-dd').format(endDate),
        ),
        fetchStressLevel()
      ]);

      final response =
          await homeApiService.getSleepTimeRecord(formattedDateForServer);
      //print('수면 기록 출려겨어어어ㅓㄱ $response');
      if (response.statusCode == 200) {
        final sleepRecord = json.decode(response.body); // JSON 형식으로 변환
        //print('수면 기록 출력!!!! $sleepRecord');

        // completed 값을 할당
        sleepRecordCompleted = sleepRecord['completed'];

        if (sleepRecord['status'] == true) {
          _addSleepRecordRoutine();
        } else {
          print("Error: 'status' key is missing or false in the response");
        }
      } else {
        print(
            "Error: Failed to load sleep record. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      sleepRecordCompleted = false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 스트레스 지수 불러오기
  Future<void> fetchStressLevel() async {
    try {
      final response = await homeApiService.getStressLevel();
      print(response);
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print(jsonData);
        setState(() {
          // _stressLevelResponse = jsonData
          //     .map((data) => StressLevelResponse.fromJson(data))
          //     .toList();
          _stressLevelResponse = StressLevelResponse.fromJson(jsonData);
        });
      } else if (response.statusCode == 404) {
        print('스트레스 지수에 아무것도 없음');
        setState(() {
          _stressLevelResponse = null;
        });
      } else {
        throw Exception('Failed to fetch 스트레스 list ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching stress level: $error');
    }
  }

  void _addSleepRecordRoutine() {
    setState(() {
      _sleepDailyRoutine.add(SleepDailyRoutine(
          //sleepRoutineId: sleepRoutineId,
          //userId: userId,
          sleepRoutineName: '수면 기록하기',
          monday: true,
          tuesday: true,
          wednesday: true,
          thursday: true,
          friday: true,
          saturday: true,
          sunday: true,
          status: true,
          createDate: DateTime(2024, 11, 14, 12, 54)
          //url: url,
          //completed: completed,
          //startTime: startTime,
          //endTime: endTime
          ));
    });
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

  // TODO: completeDate 이런거 적용시켜야함
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

  // List<SleepDailyRoutine> getFilteredSleepRoutines() {
  //   final now = DateTime.now(); // 항상 최신 시간을 사용
  //   return _sleepDailyRoutine.where((routine) {
  //     if (routine.sleepRoutineName == "수면 기록하기") {
  //       // "수면 기록하기"는 status만 확인
  //       return routine.status;
  //     }
  //
  //     final routineOnDate = routine.onDate ?? routine.createDate; // onDate가 없으면 createDate 사용
  //     DateTime? routineOffDate = routine.offDate; // offDate
  //
  //     // "오늘 이전에 생성된 루틴은 표시하지 않음"
  //     if (routine.createDate.isAfter(now)) {
  //       return false;
  //     }
  //
  //     // offDate가 onDate보다 빠르면 offDate 무시
  //     if (routineOffDate != null && routineOffDate.isBefore(routineOnDate)) {
  //       routineOffDate = null; // 잘못된 offDate를 null로 설정
  //     }
  //
  //     // 루틴 활성화 상태 처리
  //     if (routine.status) {
  //       // onDate <= 현재 <= offDate (또는 offDate가 없음)
  //       if ((routineOnDate.isBefore(now) || routineOnDate.isAtSameMomentAs(now)) &&
  //           (routineOffDate == null || routineOffDate.isAfter(now) || routineOffDate.isAtSameMomentAs(now))) {
  //         return true;
  //       }
  //     }
  //
  //     // 루틴 비활성화 상태 처리
  //     if (!routine.status) {
  //       // 상태가 false인 경우: 오늘 날짜에 비활성화되었는지 확인
  //       if (routineOffDate != null &&
  //           (routineOffDate.isAtSameMomentAs(now) || routineOffDate.isAfter(now))) {
  //         return true; // 오늘 날짜에 비활성화된 루틴 포함
  //       }
  //
  //       if (routine.completed == true) {
  //         return true; // 완료된 루틴 포함
  //       }
  //
  //       if (routineOnDate != null && routineOffDate != null) {
  //         // onDate <= 현재 <= offDate
  //         if ((now.isAtSameMomentAs(routineOnDate) || now.isAfter(routineOnDate)) &&
  //             (now.isBefore(routineOffDate) || now.isAtSameMomentAs(routineOffDate))) {
  //           return true;
  //         }
  //       }
  //     }
  //
  //     return false; // 조건에 맞지 않으면 제외
  //   }).toList();
  // }

  // 운동 루틴 불러오기
  Future<void> fetchExerciseDailyRoutine() async {
    try {
      final response =
          await homeApiService.getExerciseRoutine(formattedDateForServer);
      //print('운동 루틴 불러오기ㅣ이이 서버어ㅓ어ㅓ $response');
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        //print('운도오오옹 jsonData: $jsonData');
        if (jsonData is Map<String, dynamic> && jsonData['result'] is List) {
          setState(() {
            _exerciseDailyRoutine = (jsonData['result'] as List)
                .map((data) => ExerciseRoutineDetail.fromJson(data))
                .toList();
            //print('exercise 루틴 $_exerciseDailyRoutine');
            //print('setState까지 성공함');
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

  bool isExerciseRoutineActiveOnDay(
      ExerciseRoutineDetail routine, int dayOfWeek) {
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
      if (isExerciseRoutineActiveOnDay(routine, dayOfWeek) &&
          (routine.status ?? false)) {
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
        //print('jsonData: $jsonData');
        if (jsonData is Map<String, dynamic> && jsonData['result'] is List) {
          setState(() {
            _spiritDailyRoutine = (jsonData['result'] as List)
                .map((data) => SpiritRoutineDetail.fromJson(data))
                .toList();
            //print('spiritDailyROUtine 값!!!! $_spiritDailyRoutine');
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
      if (isSpiritRoutineActiveOnDay(routine, dayOfWeek) &&
          (routine.status ?? false)) {
        allActiveRoutines.add(routine);
      }
    }
    return allActiveRoutines;
  }

  // 상단 상태바 불러오기
  Future<void> fetchRoutineRecords(String startDate, String endDate) async {
    // 운동 상태바 가져오기
    final exerciseResponse =
        await homeApiService.getExerciseRecord(startDate, endDate);
    if (exerciseResponse.statusCode == 200) {
      final result = json.decode(exerciseResponse.body);
      //print('운동 상태바 출려어ㅓ어억 $result');
      exerciseDates = result['result']
          .map<String>((e) => e['completeDate'].toString())
          .toList();
    } else {
      //print('운동 상태바 출력 상태코드 뭘까 ${exerciseResponse.statusCode}');
    }

    // 수면 상태바 가져오기
    final sleepResponse =
        await homeApiService.getSleepRecord(startDate, endDate);
    if (sleepResponse.statusCode == 200) {
      final result = json.decode(sleepResponse.body);
      //print('수면 상태바 출려어ㅓ어억 $result');
      sleepDates = result.map<String>((e) => e['date'].toString()).toList();
    } else {
      //print('수면 상태바 출력 상태코드 뭘까 ${sleepResponse.statusCode}');
    }

    // 마음 채우기 상태바 가져오기
    final spiritResponse =
        await homeApiService.getSpiritRecord(startDate, endDate);
    if (spiritResponse.statusCode == 200) {
      final result = json.decode(spiritResponse.body);
      //print('마음 채우기 상태바 출려어ㅓ어억 $result');
      //print('마음 채우기 시작날: $startDate / 마지막 날: $endDate');
      spiritDates = result['result']
          .map<String>((e) => e['completeDate'].toString())
          .toList();
    } else {
      //print('마음 채우기 상태바 출력 상태코드 뭘까 ${spiritResponse.statusCode}');
    }

    // 취미 상태바 가져오기
    final hobbyResponse =
        await homeApiService.getHobbyRecord(startDate, endDate);
    if (hobbyResponse.statusCode == 200) {
      final result = json.decode(hobbyResponse.body);
      //print('취미 출려어ㅓ어억 $result');
      hobbyDates = result['result']
          .map<String>((e) => e['completeDate'].toString())
          .toList();
    } else {
      //print('취미 상태바 출력 상태코드 뭘까 ${hobbyResponse.statusCode}');
    }
  }

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

  DateTime getEndOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  @override
  Widget build(BuildContext context) {
    if (sleepRecordCompleted == null || isLoading) {
      return const Center(child: Loading());
    }
    if (_stressLevelResponse == null) {
      return StressSurveyPage();
    }
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
                      // 선택한 날짜 보여주기
                      Text(formattedDate,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20)),
                      // today 버튼
                      SizedBox(
                        width: 79.60,
                        height: 30,
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              selectedDate = today;
                              formattedDate = DateFormat('yyyy년 MM월 dd일')
                                  .format(selectedDate);
                              formattedDateForServer =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              currentWeekStartDate = getStartOfWeek(today);
                              _generateDates();

                              selectedIndex = today.weekday - 1;
                              if (selectedIndex < 0 || selectedIndex > 6) {
                                selectedIndex = 0;
                              }
                              todayDayName =
                                  DateFormat('EEE', 'ko').format(selectedDate);
                              dayOfWeek = selectedDate.weekday;
                              loadInitialData();
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(
                                width: 1.5, color: Colors.black),
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
                  SizedBox(
                    // TODO: height 사이즈 수정하기!!!
                    height: screenHeight * 0.69,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.106,
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15.0, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('이번주 스트레스 지수',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 17)),
                                          const QuestionMark(
                                              title: '스트레스 검사',
                                              content:
                                                  'Freeing에서는 국립정신건강센터와 대한신경정신의학회가 개발한 \'한국인 스트레스 척도\'를 사용해 최근 2주간의 스트레스 상태를 평가합니다.\n\n11개의 문항에 대해 스트레스 증상을 0점에서 3점까지 응답하며, 총점을 계산해 스트레스 수준을 확인하며 총점은 33점입니다.\n\n0~10점: 낮은 수준의 스트레스\n11~20점: 중등도 이상의 스트레스\n21~33점: 매우 높은 중증 수준의 스트레스\n\n결과를 통해 자신의 스트레스 상태를 파악하고 필요시 관리 방법이나 전문가 상담을 받아보세요!')
                                          //'만점은 33점입니다.\n\n0점 - 10점: 낮은 수준의 스트레스\n11점 - 20점: 중등도 이상의 스트레스\n21점 - 33점: 매우 높은 중증 수준의 스트레스')
                                        ],
                                      ),
                                      Container(
                                        width: screenWidth * 0.3,
                                        height: screenHeight * 0.02889,
                                        margin: const EdgeInsets.only(
                                            left: 10.0, top: 0),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 4,
                                                backgroundColor: PRIMARY_COLOR,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  side: const BorderSide(
                                                    width: 1,
                                                  ),
                                                )),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StressSurveyPage()));
                                            },
                                            child: Text('측정 하기',
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500))),
                                      ),
                                      // if (_stressLevelResponse != null)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 35.0, top: 2),
                                        child: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                _stressLevelResponse!
                                                    .createdDate),
                                            style: textTheme.labelSmall),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_stressLevelResponse != null)
                                      Image.asset((_stressLevelResponse!
                                                  .recentStressLevel ==
                                              '높음'
                                          ? 'assets/imgs/home/stress_high_ex.png'
                                          : _stressLevelResponse!
                                                      .recentStressLevel ==
                                                  '중간'
                                              ? 'assets/imgs/home/stress_medium_ex.png'
                                              : 'assets/imgs/home/stress_low_ex.png'), width: screenWidth * 0.306,),
                                    const SizedBox(height: 3),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _stressLevelResponse != null
                                                ? _stressLevelResponse!
                                                    .recentTotalScore
                                                    .toString()
                                                : ' ',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                          if (_stressLevelResponse != null)
                                            const TextSpan(
                                              text: '점',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          const WidgetSpan(
                                            child: SizedBox(width: 4),
                                          ),
                                          if (_stressLevelResponse != null &&
                                              _stressLevelResponse!
                                                      .scoreDifference !=
                                                  null)
                                            WidgetSpan(
                                              child: Icon(
                                                _stressLevelResponse!
                                                            .scoreDifference! >
                                                        0
                                                    ? Icons.arrow_drop_up_sharp
                                                    : _stressLevelResponse!
                                                                .scoreDifference! <
                                                            0
                                                        ? Icons
                                                            .arrow_drop_down_sharp
                                                        : Icons.remove,
                                                color: _stressLevelResponse!
                                                            .scoreDifference! >
                                                        0
                                                    ? const Color(
                                                        0xFFFF6253) // 양수일 때 색상
                                                    : _stressLevelResponse!
                                                                .scoreDifference! <
                                                            0
                                                        ? const Color(
                                                            0xFF529CEF) // 음수일 때 색상
                                                        : _stressLevelResponse!
                                                                    .scoreDifference ==
                                                                null
                                                            ? Colors.transparent
                                                            : TEXT_GREY,
                                                size: 25,
                                              ),
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              baseline: TextBaseline.alphabetic,
                                            ),
                                          // if (_stressLevelResponse != null &&
                                          //     _stressLevelResponse!
                                          //             .scoreDifference !=
                                          //         null)
                                          //   WidgetSpan(
                                          //     child: Icon(
                                          //       _stressLevelResponse!
                                          //                   .scoreDifference! >
                                          //               0
                                          //           ? Icons.arrow_drop_up_sharp
                                          //           : _stressLevelResponse!
                                          //                       .scoreDifference! <
                                          //                   0
                                          //               ? Icons
                                          //                   .arrow_drop_down_sharp
                                          //               : Icons.remove,
                                          //       color: _stressLevelResponse!
                                          //                   .scoreDifference! >
                                          //               0
                                          //           ? const Color(
                                          //               0xFFFF6253) // 양수일 때 색상
                                          //           : _stressLevelResponse!
                                          //                       .scoreDifference! <
                                          //                   0
                                          //               ? const Color(
                                          //                   0xFF529CEF) // 음수일 때 색상
                                          //               : TEXT_GREY, // 0일 때 색상
                                          //       size: 25,
                                          //     ),
                                          //     alignment:
                                          //         PlaceholderAlignment.middle,
                                          //     baseline: TextBaseline.alphabetic,
                                          //   ),
                                          TextSpan(
                                            text: _stressLevelResponse !=
                                                        null &&
                                                    _stressLevelResponse!
                                                            .scoreDifference !=
                                                        null
                                                ? (_stressLevelResponse!
                                                            .scoreDifference !=
                                                        null
                                                    ? _stressLevelResponse!
                                                        .scoreDifference!
                                                        .abs()
                                                        .toString()
                                                    : '') // Output '' if scoreDifference is null
                                                : '',
                                            style: TextStyle(
                                                color: _stressLevelResponse !=
                                                            null &&
                                                        _stressLevelResponse!
                                                                .scoreDifference !=
                                                            null
                                                    ? (_stressLevelResponse!
                                                                .scoreDifference! >
                                                            0
                                                        ? const Color(
                                                            0xFFFF6253) // 0보다 클 때 색상
                                                        : _stressLevelResponse!
                                                                    .scoreDifference! <
                                                                0
                                                            ? const Color(
                                                                0xFF529CEF) // 0보다 작을 때 색상
                                                            : _stressLevelResponse!
                                                                        .scoreDifference ==
                                                                    null
                                                                ? Colors
                                                                    .transparent
                                                                : TEXT_GREY) // 0일 때 색상
                                                    : Colors.black,
                                                //color: Color(0xFF529CEF),
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.106,
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentWeekStartDate =
                                            currentWeekStartDate.subtract(
                                                const Duration(days: 7));
                                        _generateDates();
                                        selectedIndex = today.weekday - 1;
                                        if (selectedIndex < 0 ||
                                            selectedIndex > 6) {
                                          selectedIndex = 0;
                                        }
                                        selectedDate = currentWeekStartDate
                                            .add(Duration(days: selectedIndex));
                                        formattedDate =
                                            DateFormat('yyyy년 MM월 dd일')
                                                .format(selectedDate);
                                        todayDayName = DateFormat('EEE', 'ko')
                                            .format(selectedDate);
                                        loadInitialData();
                                      });
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 8.0, top: 25.0),
                                      child:
                                          Icon(Icons.arrow_back_ios, size: 15),
                                    ),
                                  ),
                                  ...List<Widget>.generate(7, (index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          selectedIndex = index;
                                          selectedDate = dates[index];
                                          formattedDate =
                                              DateFormat('yyyy년 MM월 dd일')
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
                                        exerciseDates: exerciseDates,
                                        sleepDates: sleepDates,
                                        spiritDates: spiritDates,
                                        hobbyDates: hobbyDates,
                                      ),
                                    );
                                  }),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentWeekStartDate =
                                            currentWeekStartDate
                                                .add(Duration(days: 7));
                                        _generateDates();
                                        selectedIndex = today.weekday - 1;
                                        if (selectedIndex < 0 ||
                                            selectedIndex > 6) {
                                          selectedIndex = 0;
                                        }
                                        selectedDate = currentWeekStartDate
                                            .add(Duration(days: selectedIndex));
                                        formattedDate =
                                            DateFormat('yyyy년 MM월 dd일')
                                                .format(selectedDate);
                                        todayDayName = DateFormat('EEE', 'ko')
                                            .format(selectedDate);
                                        loadInitialData();
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          right: 8.0, top: 25.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          SizedBox(
                            //height: screenHeight * 0.5,
                            //height: screenHeight * 0.539,
                            child: Column(
                              children: [
                                HomeExpansionTileBox(
                                  text: '운동',
                                  exerciseDailyRoutines:
                                      getAllFilteredExerciseRoutines(dayOfWeek),
                                  completeDay: formattedDateForServer,
                                ),
                                verticalSpace,
                                HomeExpansionTileBox(
                                  text: '수면',
                                  sleepDailyRoutines:
                                      getFilteredSleepRoutines(),
                                  completeDay: formattedDateForServer,
                                  sleepRecordCompleted: sleepRecordCompleted!,
                                ),
                                verticalSpace,
                                HomeExpansionTileBox(
                                  text: '마음 채우기',
                                  spiritDailyRoutines:
                                      getAllFilteredSpiritRoutines(dayOfWeek),
                                  completeDay: formattedDateForServer,
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
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                            color:
                                                                HOME_YELLOW_TEXT,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                const TextSpan(text: '를 했나요?')
                                              ]),
                                        ),
                                        LogButton(
                                          onPressed: () {
                                            showHobbyBottomSheet(
                                                context,
                                                '오늘 했던 취미는 어땠나요?',
                                                selectedDate);
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar:
                const CustomBottomNavigationBar(selectedIndex: 0)),
      ],
    );
  }
}
