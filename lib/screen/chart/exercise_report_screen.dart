import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/custom_circular_progress_indicator.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/model/exercise/exercise_report.dart';
import 'package:freeing/screen/setting/setting_page.dart';

class ExerciseReportScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  ExerciseReportScreen(
      {super.key, required this.startDate, required this.endDate});

  @override
  State<ExerciseReportScreen> createState() => _ExerciseReportScreenState();
}

class _ExerciseReportScreenState extends State<ExerciseReportScreen> {
  String name = '';
  ExerciseReport? exerciseReport;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExerciseReport().then((data) {
      setState(() {
        exerciseReport = data;
        isLoading = false;
      });
    });
    _viewUserInfo();
  }

  // Todo: 서버 요청 (사용자 이름 받아오기)
  Future<void> _viewUserInfo() async {
    print(widget.startDate);
    print(widget.endDate);
    final response = await SettingAPIService().getUserInfo();

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final userData = User.fromJson(json.decode(decodedBody));
      name = userData.name;
    } else {
      throw Exception('사용자 정보 가져오기 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (주간 운동 리포트 받아오기)
  Future<ExerciseReport> _fetchExerciseReport() async {
    final apiService = ExerciseAPIService();
    final response =
        await apiService.getExerciseReport(widget.startDate, widget.endDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print(jsonData['result']);
      if (jsonData != null && jsonData['result'] != null) {
        // setState(() {
        //   exerciseReport =  ExerciseReport.fromJson(jsonData['result']);
        // });
        return ExerciseReport.fromJson(jsonData['result']);
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print(jsonData['error']);
      throw Exception('주간 운동 리포트 조회 실패 ${response.statusCode}');
    }
  }

  //Todo: 주간 운동 시간 데이터(분 단위)
  Map<String, int> getExerciseTimes(ExerciseReport data) {
    return {
      'monTime': data.monTime,
      'tueTime': data.tueTime,
      'wenTime': data.wenTime,
      'thuTime': data.thuTime,
      'friTime': data.friTime,
      'satTime': data.satTime,
      'sunTime': data.sunTime,
    };
  }

  //Todo: 시간 변환(00h 00m)
  String formatTime(int minutes) {
    int h = minutes ~/ 60; // 시간
    int m = minutes % 60; // 분

    return '${h.toString()}h${m.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? CustomCircularProgressIndicator()
        : ScreenLayout(
            title: '주간 운동 리포트',
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.028),

                  /// 총 운동 시간, 평균 운동 시간
                  _showStartAverageExerciseTime(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    totalExerciseTime: exerciseReport!.totalExerciseTime,
                    avgExerciseTime: exerciseReport!.avgExerciseTime,
                  ),
                  SizedBox(height: screenHeight * 0.028),

                  /// 주간 운동 시간 그래프
                  _showWeeklyExerciseTime(
                      textTheme: textTheme,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      exerciseTimes: getExerciseTimes(exerciseReport!)),
                  SizedBox(height: screenHeight * 0.028),

                  /// 루틴별 운동 시간
                  _showRoutineExerciseTime(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    routineData: exerciseReport!.exerciseRoutineDtoList,
                  ),
                  SizedBox(height: screenHeight * 0.028),

                  /// 피드백
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: '\n$name',
                                        style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600),
                                        children: <TextSpan>[
                                      TextSpan(
                                        text: '님을 위한\n분석 결과와 피드백 입니다.',
                                        style: textTheme.bodyMedium,
                                      )
                                    ])),
                                Image.asset(
                                  'assets/imgs/etc/report_mascot.png',
                                  width: screenWidth * 0.2,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.028),
                            Text(exerciseReport!.feedBack)
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.028),
                  GreenButton(width: screenWidth * 0.6, onPressed: () {}),
                  SizedBox(height: screenHeight * 0.028),
                ],
              ),
            ),
            color: LIGHT_IVORY,
          );
  }

  //Todo: 총 운동 시간, 평균 운동 시간
  Widget _showStartAverageExerciseTime({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required int totalExerciseTime,
    required int avgExerciseTime,
  }) {
    final totalHours = (totalExerciseTime ~/ 60).toString().padLeft(2, '0');
    final totalMinutes = (totalExerciseTime % 60).toString().padLeft(2, '0');
    final avgHours = (avgExerciseTime ~/ 60).toString().padLeft(2, '0');
    final avgMinutes = (avgExerciseTime % 60).toString().padLeft(2, '0');
    return Column(
      children: [
        _titleAndTimeCard(
          textTheme: textTheme,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: '총 운동 시간',
          hour: totalHours,
          minute: totalMinutes,
        ),
        SizedBox(height: screenHeight * 0.028),
        _titleAndTimeCard(
          textTheme: textTheme,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: '일 평균 운동 시간',
          hour: avgHours,
          minute: avgMinutes,
        ),
        SizedBox(height: screenHeight * 0.008),
        Text(
          '* 시작 시각, 종료 시각이 설정된 루틴에 대해서만 측정됩니다.',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }

  //Todo: 주간 운동 그래프
  Widget _showWeeklyExerciseTime({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required exerciseTimes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('주간 운동 시간 그래프', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.008),
        Card(
          margin: EdgeInsets.zero,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(width: 1.0),
          ),
          color: LIGHT_GREY,
          child: Container(
            height: screenHeight * 0.29,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.26,
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BarChart(
                          BarChartData(
                            maxY: 4,
                            backgroundColor: Colors.white,
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(enabled: false),
                            gridData: FlGridData(
                              drawHorizontalLine: false,
                              drawVerticalLine: true,
                              verticalInterval: 1 / 7,
                              getDrawingVerticalLine: (value) {
                                return const FlLine(
                                  color: BASIC_GREY, // 세로 선의 색상 설정
                                  strokeWidth: 1, // 세로 선의 두께 설정
                                  dashArray: [5, 5], // 점선 스타일 (선 길이와 간격)
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              // 왼쪽 제목 비활
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              // 위쪽 제목 비활
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              // 오른쪽 제목 비활
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: screenHeight * 0.036,
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const days = [
                                      '월',
                                      '화',
                                      '수',
                                      '목',
                                      '금',
                                      '토',
                                      '일'
                                    ];
                                    return Column(
                                      children: [
                                        SizedBox(height: screenHeight * 0.01),
                                        Text(days[value.toInt()]),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                top: BorderSide.none,
                                left: BorderSide.none,
                                right: BorderSide.none,
                                bottom: BorderSide(width: 1),
                              ),
                            ),

                            /// 막대 그래프 표시
                            barGroups: exerciseTimes.entries.map<BarChartGroupData>((entry) {
                              int index =  exerciseTimes.keys.toList().indexOf(entry.key);
                              int minutes = entry.value;

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: minutes / 60,
                                    color: BLUE_PURPLE,
                                    width: 20,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6), // 윗부분 왼쪽 둥글게
                                      topRight:
                                          Radius.circular(6), // 윗부분 오른쪽 둥글게
                                    ),
                                    borderSide: const BorderSide(width: 1),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 10,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      /// 시간 나타내는 Text
                      ...exerciseTimes.entries
                          .where((MapEntry<String, int> entry) => entry.value > 0)// 시간이 0인 경우 텍스트 X
                          .map((entry) {
                        int index = exerciseTimes.keys.toList().indexOf(entry.key);
                        int minutes = entry.value;
                        double posX = index *
                            (screenWidth * 0.112); // 각 막대 위치에 맞춘 x 좌표 계산
                        double barHeightRatio =
                            screenHeight * 0.2; // 막대 그래프가 차지하는 높이 비율 조정
                        double posY = screenHeight * 0.18 -
                            (minutes / 240 * barHeightRatio) -
                            screenHeight * 0.004; // 각 막대 위치에 맞는 y 촤표 계산
                        // y 좌표 계산 (위로 띄워)
                        return Positioned(
                          left: posX,
                          top: posY,
                          child: Text(formatTime(minutes),
                              style: textTheme.labelMedium
                                  ?.copyWith(color: TEXT_PURPLE)),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '* 최대 4시간까지 표시됩니다.',
                  style: textTheme.bodySmall?.copyWith(color: DARK_GREY),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Todo: 일주일 간 수행한 운동 루틴
  Widget _showRoutineExerciseTime({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required List<ExerciseRoutine> routineData,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('일주일 간 수행한 운동 루틴', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.008),
        SizedBox(
          height: screenWidth * 0.32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: routineData.length,
            itemBuilder: (context, index) {
              final routine = routineData[index];
              final hours =
                  (routine.routineTime ~/ 60).toString().padLeft(2, '0');
              final minutes =
                  (routine.routineTime % 60).toString().padLeft(2, '0');
              final exerciseTime = '${hours}h ${minutes}m';

              return _buildRoutineTimeCard(
                textTheme: textTheme,
                screenWidth: screenWidth,
                exerciseTime: exerciseTime,
                imageUrl: routine.imageUrl,
                routineName: routine.name, // 실제 루틴 이름으로 변경
              );
            },
          ),
        ),
      ],
    );
  }

  //Todo: 시간 종류, 시간 카드 위젯
  Widget _titleAndTimeCard({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required String title,
    required String hour,
    required String minute,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: screenHeight * 0.053,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.titleMedium),
            Text('$hour h $minute m',
                style: textTheme.titleMedium?.copyWith(color: TEXT_PURPLE)),
          ],
        ),
      ),
    );
  }

  //Todo: 운동 루틴, 시간 카드 위젯
  Widget _buildRoutineTimeCard({
    required TextTheme textTheme,
    required double screenWidth,
    required String exerciseTime,
    required String imageUrl,
    required String routineName,
  }) {
    return Card(
      elevation: 4,
      shadowColor: YELLOW_SHADOW,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: EdgeInsets.all(screenWidth * 0.01),
      child: Container(
        width: screenWidth * 0.3,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Text(
                exerciseTime,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: TEXT_PURPLE),
              ),
            ),
            _routineImage(imageUrl: imageUrl),
            _routineTitle(textTheme: textTheme, title: routineName),
          ],
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      left: 15,
      right: 15,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _routineTitle({required TextTheme textTheme, required String title}) {
    return Positioned(
      bottom: 4,
      left: 0,
      right: 0,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
