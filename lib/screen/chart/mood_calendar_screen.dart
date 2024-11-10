import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/emotion_diary_card.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/spirit/emotion_diary.dart';
import 'package:freeing/model/spirit/mood_monthly.dart';
import 'package:freeing/screen/chart/chart_page.dart';
import 'package:freeing/screen/chart/mood_scrap_screen.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';
import 'package:freeing/screen/member/login.dart';
import 'package:freeing/screen/routine/routine_page.dart';

class MoodCalendar extends StatefulWidget {
  final DateTime? selectTime;
  const MoodCalendar({super.key, this.selectTime});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  final tokenStorage = TokenStorage();
  DateTime select = DateTime.now();
  late int selectedDate = DateTime.now().day;
  late int selectYear = DateTime.now().year;
  late int selectMonth = DateTime.now().month;
  int getFirstDayOfMonth() => DateTime(selectYear, selectMonth, 1).weekday;
  int getDaysInMonth() => DateTime(selectYear, selectMonth + 1, 0).day;
  final apiService = SpiritAPIService();

  Map<int, String> emotionDataByDay = {};
  Map<int, int> diaryIdByDay = {};
  Map<int, int> recordIdByDay = {};
  EmotionDiary? selectedDiary;
  bool _isScrap = false;

  //Todo: 서버 요청 (월별 감정 조회)
  Future<List<MoodMonthly>> _fetchMonthlyEmotion(int year, int month) async {
    print('Fetching Monthly Emotion $year - $month');
    final response = await apiService.getMoodList(year, month);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print(jsonData);

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> moodList = jsonData['result'];
        List<MoodMonthly> moodMonthlyList = moodList.map((data) {
          return MoodMonthly.fromJson(data);
        }).toList();
        return moodMonthlyList;
      } else {
        throw Exception('데이터 형식 오류');
      }
    } else if (response.statusCode == 401) {
      String? refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        var newAccessToken = await tokenStorage.getAccessToken();
        print('newAccessToken: $newAccessToken');
        await tokenStorage.saveAccessTokens(newAccessToken!);
      } else {
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '로그인 세션이 만료되었습니다.\n다시 로그인 해주세요.',
          onConfirm: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Login(),
            ));
          },
        );
      }
      return [];
    } else if (response.statusCode == 404) {
      return [];
    } else
      throw Exception('월별 감정 조회 실패 ${response.statusCode}');
  }

  //Todo: 날짜별 감정 데이터로 전환
  Future<Map<String, Map<int, dynamic>>> getEmotionDataByDay(
      int year, int month) async {
    List<MoodMonthly> moodMonthlyList = await _fetchMonthlyEmotion(year, month);

    Map<int, String> emotions = {};
    Map<int, int> diaryIds = {};
    Map<int, int> recordIds = {};

    for (var mood in moodMonthlyList) {
      int day = mood.routineDate.day;
      emotions[day] = mood.emotion;
      diaryIds[day] = mood.diaryId;
      recordIds[day] = mood.recordId;
    }

    print('최종 emotions 맵: $emotions');
    print('최종 diaryIds 맵: $diaryIds');
    print('최종 recordIds 맵: $recordIds');

    return {'emotions': emotions, 'diaryIds': diaryIds, 'recordIds': recordIds};
  }

  //Todo: 서버 요청 (일일 감정 일기 기록 조회)
  Future<void> _fetchEmotionDiary(int diaryId) async {
    final response = await apiService.getEmotionDiary(diaryId);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print(jsonData);
      if (jsonData != null && jsonData['result'] != null) {
        setState(() {
          selectedDiary = EmotionDiary.fromJson(jsonData['result']);
        });
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print('이게 도대체 왜이럴까 선택된 다이어리 아이디는?? $diaryId');
      print('jsonData error ${jsonData['error']}');
      throw Exception('일일 감정 일기 기록 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (감정 일기 삭제)
  Future<void> _deleteEmotionDiary(int diaryId) async {
    final responseCode = await apiService.deleteEmotionDiary(diaryId);

    print(diaryId);
    print(responseCode);
    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => MoodCalendar(
                  selectTime: DateTime(selectYear, selectMonth, selectedDate),
                )),
      );
      ToastBarWidget(
        title: '감정일기가 삭제되었습니다.',
      ).showToast(context);
    } else {
      ToastBarWidget(
        title: '감정일기가 삭제되지 않았습니다. ${responseCode}',
      ).showToast(context);
    }
  }

  //Todo: 서버 요청 (감정 일기 스크랩 하기)
  Future<void> _scrapEmotionDiary(int diaryId) async {
    print('감정 일기 스크랩 하기');
    final responseCode = await apiService.scrapEmotionDiary(diaryId);
    if (responseCode == 200) {
      print('감정일기 스크랩 성공');
      setState(() {
        _isScrap = !_isScrap;
      });
      print('이제 출력해야할 값: true, 실제 출력 값: $_isScrap');
    } else {
      print('감정일기 스크랩 실패(${responseCode})');
    }
  }

  //Todo: 서버 요청 (감정 일기 스크랩 취소 하기)
  Future<void> _scrapCancelEmotionDiary(int diaryId) async {
    print('감정 일기 스크랩 취소 하기');
    final responseCode = await apiService.scrapCancelEmotionDiary(diaryId);
    if (responseCode == 200) {
      print('감정일기 스크랩 취소 성공');
      setState(() {
        _isScrap = !_isScrap;
      });
      print('이제 출력해야할 값: false, 실제 출력 값: $_isScrap');
    } else {
      print('감정일기 스크랩 취소 실패($responseCode');
    }
  }

  @override
  void initState() {
    super.initState();
    selectYear = widget.selectTime?.year ?? DateTime.now().year;
    selectMonth = widget.selectTime?.month ?? DateTime.now().month;
    selectedDate = widget.selectTime?.day ?? DateTime.now().day;

    getEmotionDataByDay(selectYear, selectMonth).then((data) {
      setState(() {
        emotionDataByDay = Map<int, String>.from(data['emotions']!);
        diaryIdByDay = Map<int, int>.from(data['diaryIds']!);
        recordIdByDay = Map<int, int>.from(data['recordIds']!);
      });

      if (diaryIdByDay.containsKey(selectedDate) &&
          diaryIdByDay[selectedDate] != -1) {
        print('선택 날짜 다이어리 아이디: ${diaryIdByDay[selectedDate]}');
        _fetchEmotionDiary(diaryIdByDay[selectedDate]!);
        print(recordIdByDay[selectedDate]);
      } else {
        print('선택한 날짜에 해당하는 일기 데이터가 없습니다.');
      }
    });
    // }).catchError((error) {
    //   print('에러 발생: $error');
    // });
  }

  //Todo: 날짜 update
  Future<void> updateSelectedMonth(DateTime date) async {
    setState(() {
      select = date;
      selectYear = select.year;
      selectMonth = select.month;
    });

    final emotionList = await getEmotionDataByDay(selectYear, selectMonth);

    setState(() {
      emotionDataByDay = Map<int, String>.from(emotionList['emotions']!);
      diaryIdByDay = Map<int, int>.from(emotionList['diaryIds']!);
      recordIdByDay = Map<int, int>.from(emotionList['recordIds']!);

      // 데이터를 모두 업데이트한 후 selectedDate에 대한 일기 데이터 확인
      if (diaryIdByDay.containsKey(selectedDate) &&
          diaryIdByDay[selectedDate] != -1) {
        _fetchEmotionDiary(diaryIdByDay[selectedDate]!);
      } else {
        print('선택한 날짜에 해당하는 일기 데이터가 없습니다.');
      }
    });
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

    return ChartLayout(
        title: '무드 캘린더',
        backToPage: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChartPage()),
          );
        },
        chartWidget: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              // 년, 월 선택 및 스크랩 화면 이동 버튼
              _selectMonthAndScrapPageButton(
                  textTheme, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.01),
              // 날짜, 감정 표시 달력
              _monthlyCalendar(textTheme, screenWidth, screenHeight,
                  daysInMonth, firstDayOfMonth),
              SizedBox(height: screenHeight * 0.017),
              (recordIdByDay[selectedDate] == null &&
                      recordIdByDay[selectedDate] == null)
                  ? _goToRoutineOn(textTheme, screenWidth, screenHeight)
                  : diaryIdByDay[selectedDate] != -1
                      ? _viewEmotionalDiary()
                      : _noneEmotionDiary(textTheme, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.08),
            ],
          ),
        ),
        onDateSelected: updateSelectedMonth);
  }

  //Todo: 날짜 선택 및 스크랩 화면 이동 버튼
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
              selectedDate: select,
              onDateChanged: updateSelectedMonth,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: screenHeight * 0.03,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MoodScrap()));
                },
                child: Text(
                  '스크랩',
                  style: textTheme.bodyMedium,
                ),
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(screenWidth * 0.18, screenHeight * 0.03),
                  backgroundColor: Colors.white,
                  foregroundColor: LIGHT_GREY,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(
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

  // Todo: 달력
  Widget _monthlyCalendar(
    TextTheme textTheme,
    double screenWidth,
    double screenHeight,
    int daysInMonth,
    int firstDayOfMonth,
  ) {
    int rows = ((daysInMonth + firstDayOfMonth - 1) / 7).ceil(); // 달력 row 개수 계산
    return Card(
      margin: EdgeInsets.zero,
      elevation: 6,
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
            horizontal: screenWidth * 0.01, vertical: screenHeight * 0.014),
        decoration: BoxDecoration(
          color: LIGHT_IVORY,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: screenHeight * 0.006,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            itemBuilder: (context, index) {
              int dayNumber = index - firstDayOfMonth + 2;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink(); // 날짜 범위 밖일 경우 빈 셀 반환
              }

              String emotion = emotionDataByDay[dayNumber] ?? "NONE";
              String imagePath = getEmotionImagePath(emotion);
              return GestureDetector(
                onTap: () async {
                  print('선택된 날짜: $selectedDate');
                  setState(() {
                    selectedDate = dayNumber; // 날짜 업데이트
                  });

                  if (diaryIdByDay.containsKey(dayNumber) &&
                      diaryIdByDay[selectedDate] != -1) {
                    await _fetchEmotionDiary(diaryIdByDay[dayNumber]!);
                    _isScrap = selectedDiary?.scrap ?? false;
                    print('불러온 일기 스크랩 여부 $_isScrap');
                  } else {
                    setState(() {
                      selectedDiary = null; // 또는 EmotionDiary()와 같이 초기화
                    });
                    print('기록없음');
                  }
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
    );
  }

  // Todo: 상세 보기 (선택된 날짜에 감정 일기 있을 때)
  Widget _viewEmotionalDiary() {
    print('넘어가는 scrap값 : ${selectedDiary?.scrap ?? ''}');
    final diaryId = selectedDiary?.diaryId ?? -1;
    print('letterId: ${selectedDiary?.letterId ?? -1}');
    print('레코드 아이디 ${recordIdByDay[selectedDate]}');
    print('다이어리 아이디 ${diaryIdByDay[selectedDate]}');

    return EmotionDiaryCard(
      diaryId: diaryId,
      date: DateTime(selectYear, selectMonth, selectedDate),
      letterId: selectedDiary?.letterId ?? -1,
      scrap: _isScrap,
      emotion: selectedDiary?.emotion ?? '',
      emotionImage: getEmotionImagePath(selectedDiary?.emotion ?? ''),
      wellDone: selectedDiary?.wellDone ?? '',
      hardWork: selectedDiary?.hardWork ?? '',
      deleteDiary: () {
        _deleteEmotionDiary(diaryId);
      },
      from: 'calendar',
      onScrapToggle: () async {
        !_isScrap
            ? await _scrapEmotionDiary(diaryId)
            : await _scrapCancelEmotionDiary(diaryId);
      },
    );
  }

  // Todo: 상세 보기 (선택된 날짜에 감정 일기 없을 때)
  /// 감정 일기 켜져 있을 때 - 일기 작성하기 버튼 -> 바텀 시트 올라옴
  Widget _noneEmotionDiary(
    TextTheme textTheme,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.035,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$selectYear년 $selectMonth월 $selectedDate일',
              style: textTheme.titleSmall,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.008),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(15),
          padding: EdgeInsets.zero,
          dashPattern: [6, 4],
          color: SEMI_GREY,
          strokeWidth: 1.5,
          child: Container(
            height: screenHeight * 0.22,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '작성한 일기가 없어요\n'
                    '일기를 작성하고 편지를 받아보세요.',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    //width: screenWidth * 0.33,
                    height: screenHeight * 0.035,
                    child: OutlinedButton(
                      onPressed: () async {
                        print(
                            '감정일기 작생해보세요잉의 recordId 입니다! ${recordIdByDay[selectedDate]!}');
                        // TODO: 감정일기 작성하기 bottom sheet
                        bool result = await showDiaryBottomSheet(
                          context: context,
                          title: '오늘 하루 어땠나요?',
                          selectedDate: DateTime(selectYear, selectMonth, selectedDate),
                          recordId: recordIdByDay[selectedDate]!,
                        );
                        if (result){
                          setState((){
                            getEmotionDataByDay(selectYear, selectMonth).then((data) {
                              setState(() {
                                emotionDataByDay = Map<int, String>.from(data['emotions']!);
                                diaryIdByDay = Map<int, int>.from(data['diaryIds']!);
                                recordIdByDay = Map<int, int>.from(data['recordIds']!);
                              });

                              if (diaryIdByDay.containsKey(selectedDate) &&
                                  diaryIdByDay[selectedDate] != -1) {
                                print('선택 날짜 다이어리 아이디: ${diaryIdByDay[selectedDate]}');
                                _fetchEmotionDiary(diaryIdByDay[selectedDate]!);
                                print(recordIdByDay[selectedDate]);
                              } else {
                                print('선택한 날짜에 해당하는 일기 데이터가 없습니다.');
                              }
                            });
                          });
                        }
                      },
                      child: Text('일기 작성하기', style: textTheme.bodySmall),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: LIGHT_GREY,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.2),
      ],
    );
  }

  //Todo: 루틴 키러 가기
  /// 감정 일기 꺼져 있을 때 - 루틴 키러 가기 버튼
  Widget _goToRoutineOn(textTheme, screenWidth, screenHeight) {
    print('레코드 아이디 바이 데이 $recordIdByDay');
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.035,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$selectYear년 $selectMonth월 $selectedDate일',
              style: textTheme.titleSmall,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.008),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(15),
          padding: EdgeInsets.zero,
          dashPattern: [6, 4],
          color: SEMI_GREY,
          strokeWidth: 1.5,
          child: Container(
            height: screenHeight * 0.22,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '작성한 일기가 없어요\n'
                    '일기를 작성하고 편지를 받아보세요.',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    '루틴이 꺼져 있다면?',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  SizedBox(
                    //width: screenWidth * 0.33,
                    height: screenHeight * 0.035,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RoutinePage(index: 3)),
                        );
                      },
                      child: Text('루틴 키러 가기', style: textTheme.bodySmall),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: LIGHT_GREY,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.2),
      ],
    );
  }
}
