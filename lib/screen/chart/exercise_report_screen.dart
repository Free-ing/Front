import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';

class ExerciseReportScreen extends StatelessWidget {
  ExerciseReportScreen({super.key});

  //Todo: 주간 운동 시간 예시 데이터(분 단위)
  final Map<String, int> exerciseTimes = {
    'monTime': 50,
    'tueTime': 30,
    'wenTime': 0,
    'thuTime': 80,
    'friTime': 60,
    'satTime': 180,
    'sunTime': 20,
  };

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

    return ScreenLayout(
      title: '주간 운동 리포트',
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 총 운동 시간, 평균 운동 시간
              _showStartAverageExerciseTime(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(height: screenHeight * 0.028),

              /// 주간 운동 시간 그래프
              _showWeeklyExerciseTime(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(height: screenHeight * 0.028),

              /// 루틴별 운동 시간
              _showRoutineExerciseTime(
                  textTheme: textTheme,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight),
              SizedBox(height: screenHeight * 0.028),

            ],
          ),
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
  }) {
    return Column(
      children: [
        _titleAndTimeCard(
          textTheme: textTheme,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: '총 운동 시간',
          hour: '00',
          minute: '56',
        ),
        SizedBox(height: screenHeight * 0.028),
        _titleAndTimeCard(
          textTheme: textTheme,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: '일 평균 운동 시간',
          hour: '00',
          minute: '56',
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
            side: BorderSide(width: 1.0),
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
                              border: Border(
                                top: BorderSide.none,
                                left: BorderSide.none,
                                right: BorderSide.none,
                                bottom: BorderSide(width: 1),
                              ),
                            ),

                            /// 막대 그래프 표시
                            barGroups: exerciseTimes.entries
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              int minutes = entry.value.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: minutes / 60,
                                    color: BLUE_PURPLE,
                                    width: 20,
                                    borderRadius: BorderRadius.only(
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
                          .toList()
                          .asMap()
                          .entries
                          .where((entry) =>
                              entry.value.value > 0) // 시간이 0인 경우 텍스트 X
                          .map((entry) {
                        int index = entry.key;
                        int minutes = entry.value.value;
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('일주일 간 수행한 운동 루틴', style: textTheme.titleSmall),
        SizedBox(height: screenHeight * 0.008),
        SizedBox(
          height: screenWidth * 0.32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 수평 스크롤
            itemCount: 5, // 위젯의 개수 (예시로 5개 설정)
            itemBuilder: (context, index) {
              return _buildRoutineTimeCard(
                textTheme: textTheme,
                screenWidth: screenWidth,
                exerciseTime: '00H 56M', // 실제 값으로 변경
                imageUrl:
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/static_stretching.png', // 실제 URL로 변경
                routineName: '정적 스트레칭', // 실제 루틴 이름으로 변경
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
            Text('$hour H $minute M',
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
        padding: EdgeInsets.all(2),
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
