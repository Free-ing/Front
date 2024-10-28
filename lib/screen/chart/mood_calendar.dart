import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/screen/chart/mood_scrap.dart';
import 'package:freeing/screen/home/diary_bottom_sheet.dart';

import 'ai_letter.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  DateTime selectedMonth = DateTime.now();
  late int selectedDate = DateTime.now().day as int;
  late int year = DateTime.now().year;
  late int month = DateTime.now().month;
  int getFirstDayOfMonth() => DateTime(year, month, 1).weekday;
  int getDaysInMonth() => DateTime(year, month + 1, 0).day;
  bool _existLetter = true; // 편지 존재 여부
  bool _isScrap = false; // 스크랩 여부

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

  //Todo: 모달 바텀 시트: 감정 일기 편집 옵션
  void showMenu(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit_note_rounded),
                title: const Text('일기 수정하기'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete_forever_outlined),
                title: const Text('일기 삭제하기'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
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
              // 선택된 날짜 상세 보기
              exampleEmotions[selectedDate] != null ?
                  _viewEmotionalDiary(textTheme, screenWidth, screenHeight)
              : _noneEmotionDiary(textTheme, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.017),
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
                crossAxisCount: 7, mainAxisSpacing: screenHeight * 0.006),
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
    );
  }

  // Todo: 상세 보기 (선택된 날짜에 감정 일기 있을 때)
  Widget _viewEmotionalDiary(
      TextTheme textTheme, double screenWidth, double screenHeight) {
    return Column(
      children: [
        /// 날짜 표시, 편지 보기 버튼, 스크랩 버튼
        SizedBox(
          height: screenHeight * 0.035,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    /// 날짜 표시
                    Text(
                      '$year년 $month월 $selectedDate일',
                      style: textTheme.titleSmall,
                    ),
                    SizedBox(width: screenWidth * 0.02),

                    /// 편지 보기 버튼
                    Visibility(
                      visible: _existLetter,
                      child: SizedBox(
                        width: screenWidth * 0.19,
                        height: screenHeight * 0.027,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AiLetter()));
                          },
                          child: Text('편지 보기', style: textTheme.labelMedium),
                          style: OutlinedButton.styleFrom(
                            fixedSize:
                                Size(screenWidth * 0.18, screenHeight * 0.02),
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: LIGHT_GREY,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 스크랩 버튼 - 아직 서버 요청 구현 X
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isScrap = !_isScrap;
                      });
                    },
                    icon: Image.asset(
                      _isScrap
                          ? 'assets/icons/bookmark_icon_on.png'
                          : 'assets/icons/bookmark_icon_off.png',
                      width: screenWidth * 0.07,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ))
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.008),

        /// 감정 일기 조회 (선택 날짜에 감정 일기 있을 때)
        Card(
          margin: EdgeInsets.zero,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.033, vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: LIGHT_GREY,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                /// 감정 얼굴
                Positioned(
                  top: screenHeight * 0.023,
                  child: Image.asset(
                      getEmotionImagePath(exampleEmotions[selectedDate] ?? ''),
                      width: screenWidth * 0.15),
                ),

                /// 기록한 내용
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: screenWidth * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('칭찬하고 싶은 일'),
                            /// 감정 일기 편집 버튼
                            Container(
                              width: screenWidth * 0.07,
                              height: screenHeight * 0.035,
                              child: IconButton(
                                onPressed: () {showMenu(context);},
                                icon: Icon(Icons.more_horiz),
                                padding: EdgeInsets.zero,
                                iconSize: screenWidth * 0.06,
                                color: DARK_GREY,
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          constraints: BoxConstraints(
                            minHeight: screenHeight * 0.05,
                            maxHeight: screenHeight * 0.135,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Text(
                                '딱 백자. 딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.'
                                '딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자',
                                style: textTheme.bodySmall,
                                maxLines: null, // 텍스트가 줄바꿈 되도록 설정
                                overflow: TextOverflow.clip,
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Text('슬펐던 일'),
                            SizedBox(height: screenHeight * 0.04)
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          constraints: BoxConstraints(
                            minHeight: screenHeight * 0.05,
                            maxHeight: screenHeight * 0.135,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Text(
                                '딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자',
                                style: textTheme.bodySmall,
                                maxLines: null, // 텍스트가 줄바꿈 되도록 설정
                                overflow: TextOverflow.clip,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }

  Widget _noneEmotionDiary(
    TextTheme textTheme,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$year년 $month월 $selectedDate일',
          style: textTheme.titleSmall,
        ),
        SizedBox(height: screenHeight * 0.008),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          padding: EdgeInsets.zero,
          dashPattern: [6, 4],
          color: SEMI_GREY,
          strokeWidth: 1.5,
          child: Container(
            color: Colors.transparent,
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
                    width: screenWidth * 0.23,
                    height: screenHeight * 0.035,
                    child: OutlinedButton(
                      onPressed: () {
                        showDiaryBottomSheet(
                          context,
                          '오늘 하루 어땠나요?',
                          // year,
                          // month,
                          // selectedDate,
                        );
                      },
                      child: Text('일기 작성하기', style: textTheme.bodySmall),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: LIGHT_GREY,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
      ],
    );
  }
}
