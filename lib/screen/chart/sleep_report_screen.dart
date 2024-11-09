import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: '주간 수면 리포트',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.028),
            _showSleepTime(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight),
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
            // AI 피드백
            SizedBox(height: screenHeight * 0.028),
            Center(
                child: GreenButton(width: screenWidth * 0.6, onPressed: () {})),
            SizedBox(height: screenHeight * 0.028),
          ],
        ),
      ),
      color: LIGHT_IVORY,
    );
  }

  // 평균 잠드는 시간, 기상 시간, 수면 시간 보여주기
  Widget _showSleepTime(
      {required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
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
                  hour: '11',
                  minute: '11'),
              //SizedBox(width: screenWidth * 0.05,),
              _titleAndTime(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  textTheme: textTheme,
                  title: "평균 기상 시간",
                  hour: '11',
                  minute: '11'),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _titleAndTime(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textTheme: textTheme,
              title: "평균 수면 시간",
              hour: '11',
              minute: '11'),
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
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.025),
                                    child: FittedBox(
                                      child: Text('전날 밤',
                                          style: textTheme.labelMedium, textAlign: TextAlign.center,),
                                    ),
                                  );
                                } else if (value == 4) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: screenHeight * 0.025),
                                    child: Text('아침',
                                        style: textTheme.labelMedium, textAlign: TextAlign.center,),
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
                    padding: const EdgeInsets.only(right: 20.0),
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
                        const SizedBox(width: 16.0),
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
            itemCount: 5, // 위젯의 개수 (예시로 5개 설정)
            itemBuilder: (context, index) {
              return Row(
                children: [
                  _imgAndContent(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      textTheme: textTheme,
                      sleepStatus: '개운해요'),
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
            itemCount: 5, // 위젯의 개수 (예시로 5개 설정)
            itemBuilder: (context, index) {
              return Row(
                children: [
                  _dateAndRecord(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      textTheme: textTheme),
                  const SizedBox(width: 12)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // TODO: AI 피드백 내용

  // 제목 & 시간
  Widget _titleAndTime(
      {required double screenWidth,
      required double screenHeight,
      required TextTheme textTheme,
      required String title,
      required String hour,
      required String minute}) {
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
              // TODO: 오전 오후 어떻게 할건지!!!
              Text(
                '오전 $hour시 $minute분',
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
        case '개운해요':
          return 'assets/imgs/home/after_refreshed.png';
        case '뻐근해요':
          return 'assets/imgs/home/after_stiff.png';
        case '잔 것 같지 않아요':
          return 'assets/imgs/home/after_unrested.png';
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
              color: Color(0xFFFFD477).withOpacity(0.2),
              offset: Offset(2, 4),
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
                      color: Color(0xFFFFD477).withOpacity(0.4),
                      offset: Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(getImageAddress(sleepStatus)!),
              ),
            ),
            //Image.asset(getImageAddress(sleepStatus)!),
            Text(sleepStatus, style: textTheme.labelMedium),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' 8월 27일의 기록'),
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
                    color: Color(0xFFFFD477).withOpacity(0.2),
                    offset: Offset(2, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text('기로오오옥')),
        ),
      ],
    );
  }
}
