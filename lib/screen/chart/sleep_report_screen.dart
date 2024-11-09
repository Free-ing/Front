import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/sleep_api_service.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/model/sleep/sleep_report.dart';

import '../../common/component/custom_circular_progress_indicator.dart';
import '../../common/service/setting_api_service.dart';
import '../setting/account_management_page.dart';

class SleepReportScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SleepReportScreen(
      {super.key, required this.startDate, required this.endDate});

  @override
  State<SleepReportScreen> createState() => _SleepReportScreenState();
}

class _SleepReportScreenState extends State<SleepReportScreen> {
  final Map<String, int> wakeTimes = {
    'monTime': 50,
    'tueTime': 30,
    'wenTime': 0,
    'thuTime': 80,
    'friTime': 60,
    'satTime': 150,
    'sunTime': 20,
  };
  final Map<String, int> sleepTimes = {
    'monTime': 80,
    'tueTime': 90,
    'wenTime': 20,
    'thuTime': 90,
    'friTime': 200,
    'satTime': 190,
    'sunTime': 70,
  };
  ResponseData? responseData;
  bool isLoading = true;
  String name = '';

  @override
  void initState() {
    super.initState();
    _fetchSleepReport().then((data) {
      setState(() {
        responseData = data;
        isLoading = false;
      });
    });
    _viewUserInfo();
  }

  // 서버 요청
  Future<ResponseData> _fetchSleepReport() async {
    final sleepApiService = SleepAPIService();
    final response =
        await sleepApiService.getSleepReport(widget.startDate, widget.endDate);
    print(' 상태 코드!! ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print(jsonData);
      return ResponseData.fromJson(jsonData);
    } else {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print(jsonData['error']);
      throw Exception('주간 수면 리포트 조회 실패 ${response.statusCode}');
    }
  }

  // 사용자 이름 불러오기
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? const CustomCircularProgressIndicator()
        : ScreenLayout(
            title: '주간 수면 리포트',
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.028),
                  _showSleepTime(
                    textTheme: textTheme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    formattedAvgSleepTime:
                        responseData!.weeklyReport.formattedAvgSleepTime,
                    formattedAvgWakeUpTime:
                        responseData!.weeklyReport.formattedAvgWakeUpTime,
                    avgSleepDurationInMinutes:
                        responseData!.weeklyReport.avgSleepDurationInMinutes,
                  ),
                  SizedBox(height: screenHeight * 0.028),
                  SizedBox(height: screenHeight * 0.028),
                  _showSleepTimeGraph(
                      textTheme: textTheme,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  SizedBox(height: screenHeight * 0.028),
                  SizedBox(height: screenHeight * 0.028),
                  _showSleepStatusChange(
                      textTheme: textTheme,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  SizedBox(height: screenHeight * 0.028),
                  SizedBox(height: screenHeight * 0.028),
                  _showSleepRecord(
                      textTheme: textTheme,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  SizedBox(height: screenHeight * 0.028),
                  _showAIFeedback(textTheme: textTheme, screenWidth: screenWidth, screenHeight: screenHeight),
                  SizedBox(height: screenHeight * 0.028),
                  Center(
                      child: GreenButton(
                          width: screenWidth * 0.6, onPressed: () {})),
                  SizedBox(height: screenHeight * 0.028),
                ],
              ),
            ),
            color: LIGHT_IVORY,
          );
  }

  // 평균 잠드는 시간, 기상 시간, 수면 시간 보여주기
  Widget _showSleepTime({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required String formattedAvgSleepTime,
    required String formattedAvgWakeUpTime,
    required int avgSleepDurationInMinutes,
  }) {
    final int totalHours = avgSleepDurationInMinutes ~/ 60;
    final int totalMinutes = avgSleepDurationInMinutes % 60;
    final String totalAvgSleepTime = '$totalHours시간 $totalMinutes분';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleAndTime(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  textTheme: textTheme,
                  title: "평균 잠드는 시간",
                  formattedAvgTime: formattedAvgSleepTime),
              //SizedBox(width: screenWidth * 0.05,),
              _titleAndTime(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  textTheme: textTheme,
                  title: "평균 기상 시간",
                  formattedAvgTime: formattedAvgWakeUpTime),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _titleAndTime(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textTheme: textTheme,
              title: "평균 수면 시간",
              formattedAvgTime: totalAvgSleepTime),
        ],
      ),
    );
  }

  // TODO: 수면 시간 변동 그래프
  Widget _showSleepTimeGraph(
      {required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('수면 시간 변동 그래프', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.007),
        Card(
          margin: EdgeInsets.zero,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(width: 1.0),
          ),
          color: LIGHT_GREY,
          child: Container(
              height: screenHeight * 0.32,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: screenHeight * 0.26,
                    width: screenWidth * 0.8,
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: LineChart(
                      LineChartData(
                        maxY: 4,
                        backgroundColor: Colors.white,
                        lineBarsData: [
                          LineChartBarData(
                            spots: sleepTimes.entries
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              int minutes = entry.value.value;
                              return FlSpot(index.toDouble(), minutes / 60);
                            }).toList(),
                            isCurved: false,
                            color: const Color(0xFF61D0B0), // 초록색 선 (잠드는 시간)
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: wakeTimes.entries
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              int minutes = entry.value.value;
                              return FlSpot(index.toDouble(), minutes / 60);
                            }).toList(),
                            isCurved: false,
                            color: const Color(0xFFBAB8F3), // 보라색 선 (기상 시간)
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        betweenBarsData: [
                          BetweenBarsData(
                            fromIndex: 0,
                            toIndex: 1,
                            color: const Color(0xFF61D0B0).withOpacity(0.15),
                          ),
                        ],
                        gridData: const FlGridData(
                          drawHorizontalLine: false,
                          drawVerticalLine: false,
                          // verticalInterval: 1 / 7,
                          // getDrawingVerticalLine: (value) {
                          //   return const FlLine(
                          //     color: BASIC_GREY,
                          //     strokeWidth: 1,
                          //     dashArray: [5, 5],
                          //   );
                          // },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == 0) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.025),
                                    child: FittedBox(
                                      child: Text(
                                        '전날 밤',
                                        style: textTheme.labelMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else if (value == 4) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.025),
                                    child: Text(
                                      '아침',
                                      style: textTheme.labelMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: screenHeight * 0.04,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: screenHeight * 0.036,
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const days = [
                                  '월',
                                  '화',
                                  '수',
                                  '목',
                                  '금',
                                  '토',
                                  '일'
                                ];
                                if (value >= 0 && value < days.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(days[value.toInt()],
                                        style: textTheme.labelMedium),
                                  );
                                }
                                return const Text('');
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
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.021),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: screenWidth * 0.15,
                            height: 2.0,
                            child: Container(
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF61D0B0))))),
                        Text('잠드는 시간', style: textTheme.labelMedium),
                        const SizedBox(width: 30.0),
                        SizedBox(
                            width: screenWidth * 0.15,
                            height: 2.0,
                            child: Container(
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFBAB8F3))))),
                        Text('기상 시간', style: textTheme.labelMedium),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  // 일주일 간 자고 일어난 후 상태 변화
  Widget _showSleepStatusChange(
      {required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('일주일 간 자고 일어난 후 상태 변화', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.007),
        SizedBox(
          height: screenWidth * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: responseData!.sleepRecords.length, // 위젯의 개수 (예시로 5개 설정)
            itemBuilder: (context, index) {
              final sleepRecord = responseData!.sleepRecords[index];
              return Row(
                children: [
                  _imgAndContent(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      textTheme: textTheme,
                      sleepStatus: sleepRecord.sleepStatus),
                  const SizedBox(width: 12)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // 일주일 간 자고 일어난 후 기록
  Widget _showSleepRecord(
      {required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('일주일 간 자고 일어난 후 기록', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.007),
        SizedBox(
          height: screenWidth * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: responseData!.sleepRecords.length,
            itemBuilder: (context, index) {
              final sleepRecord = responseData!.sleepRecords[index];
              return Row(
                children: [
                  _dateAndRecord(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    textTheme: textTheme,
                    memo: sleepRecord.memo,
                    formattedDate: sleepRecord.formattedDate,
                  ),
                  const SizedBox(width: 12)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // AI 피드백
  Widget _showAIFeedback(
      {required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 1)),
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
                          style: textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
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
              Text(responseData!.weeklyReport.aiFeedback)
            ],
          );
        },
      ),
    );
  }

  // 제목 & 시간
  Widget _titleAndTime(
      {required double screenWidth,
      required double screenHeight,
      required TextTheme textTheme,
      required String title,
      required String formattedAvgTime}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: screenWidth * 0.35,
        height: screenHeight * 0.083,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                //color: Color.fromARGB(2, 0, 0, 0),
                color: Colors.white10,
                blurRadius: 2,
                spreadRadius: 0.2,
                offset: Offset(2, 4))
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(title, style: textTheme.bodyMedium),
              Text(
                formattedAvgTime,
                style: textTheme.bodyMedium?.copyWith(color: TEXT_PURPLE),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 이미지 & 내용
  Widget _imgAndContent({
    required double screenWidth,
    required double screenHeight,
    required TextTheme textTheme,
    required String sleepStatus,
  }) {
    String? getImageAddress(sleepStatus) {
      switch (sleepStatus) {
        case 'REFRESHED':
          return 'assets/imgs/home/after_refreshed.png';
        case 'STIFF':
          return 'assets/imgs/home/after_stiff.png';
        case 'UNRESTED':
          return 'assets/imgs/home/after_unrested.png';
        default:
          return null;
      }
    }
    String? getStatus(sleepStatus) {
      switch (sleepStatus) {
        case 'REFRESHED':
          return '개운해요';
        case 'STIFF':
          return '뻐근해요';
        case 'UNRESTED':
          return '잔 것 같지 않아요';
        default:
          return null;
      }
    }
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 100,
        height: 109,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD477).withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD477).withOpacity(0.4),
                      offset: const Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(getImageAddress(sleepStatus)!),
              ),
            ),
            //Image.asset(getImageAddress(sleepStatus)!),
            Text(getStatus(sleepStatus)!, style: textTheme.labelMedium),
          ],
        ),
      ),
    );
  }

  // 날짜 & 기록
  Widget _dateAndRecord({
    required double screenWidth,
    required double screenHeight,
    required TextTheme textTheme,
    required String memo,
    required String formattedDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$formattedDate의 기록'),
        const SizedBox(height: 5),
        Card(
          margin: EdgeInsets.zero,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              height: screenHeight * 0.05,
              width: screenWidth * 0.7,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD477).withOpacity(0.2),
                    offset: const Offset(2, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(memo)),
        ),
      ],
    );
  }
}
