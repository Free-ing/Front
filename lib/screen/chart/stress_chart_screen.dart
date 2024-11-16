import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/stress_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/stress/stress_testresult_list.dart';
import 'package:freeing/screen/chart/stress_result_screen.dart';

class StressChartScreen extends StatefulWidget {
  const StressChartScreen({super.key});

  @override
  State<StressChartScreen> createState() => _StressChartScreenState();
}

class _StressChartScreenState extends State<StressChartScreen> {
  DateTime selectedDate = DateTime.now();
  List<StressTestResultsList> _stressTestResult = [];
  List<List<StressTestResultsList>> groupedResults = [];

  Future<List<StressTestResultsList>> _fetchStressTestResultList(
      DateTime selectedDate) async {
    final apiService = StressAPIService();
    final response = await apiService.getStressTestResultList(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      _stressTestResult.clear();
      groupedResults.clear();

      for (dynamic data in jsonData) {
        StressTestResultsList results = StressTestResultsList.fromJson(data);
        _stressTestResult.add(results);
      }

      // 날짜별로 데이터 정렬
      _stressTestResult.sort((a, b) => a.createdDate.compareTo(b.createdDate));

      // 데이터 그룹화 (3개씩 나눔)
      groupedResults = [];
      for (var i = 0; i < _stressTestResult.length; i += 3) {
        List<StressTestResultsList> group = _stressTestResult.sublist(
            i,
            (i + 3) > _stressTestResult.length
                ? _stressTestResult.length
                : i + 3);
        if (groupedResults.length % 2 == 1) {
          group = group.reversed.toList(); // 홀수 번째 리스트 역순 정렬
        }
        groupedResults.add(group);
      }

      return _stressTestResult;
    } else if (response.statusCode == 204) {
      setState(() {
        groupedResults = [];
      });

      return _stressTestResult = [];
    } else {
      throw Exception('스트레스 측정 결과 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStressTestResultList(selectedDate).then((results) {
      setState(() {
        _stressTestResult = results;
      });
    });
  }

  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
    });
    final results = await _fetchStressTestResultList(selectedDate);

    setState(() {
      _stressTestResult = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChartLayout(
      noPadding: true,
      title: '스트레스 변화 몰아 보기',
      chartWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),
          ShowChartDate(
            selectedDate: selectedDate,
            onDateChanged: updateSelectedDate, // 콜백 함수 전달
          ),
          SizedBox(height: screenHeight * 0.03),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/imgs/background/stress_chart_background.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.06,
                    top: screenHeight * 0.036),
                child: ListView.separated(
                  itemCount: groupedResults.length,
                  itemBuilder: (context, groupIndex) {
                    final group = groupedResults[groupIndex];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: group.map((result) {
                          return _buildStressResults(
                            textTheme: textTheme,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            result: result,
                          );
                        }).toList(),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: screenHeight * 0.11,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      onDateSelected: updateSelectedDate,
    );
  }

  Widget _buildStressResults({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required StressTestResultsList result,
  }) {
    String formattedDate = result.createdDate.replaceAll('-', '.');
    Color resultColor;

    switch (result.stressLevel) {
      case '높음':
        resultColor = STRESS_HIGH;
        break;
      case '중간':
        resultColor = STRESS_MIDDLE;
        break;
      case '낮음':
        resultColor = STRESS_LOW;
        break;
      default:
        resultColor = Colors.white;
    }

    return Column(
      children: [
        SizedBox(
          width: screenWidth * 0.18,
          height: screenWidth * 0.18,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StressResultScreen(
                    surveyId: result.surveyId,
                    replacementScreen: StressChartScreen(),
                  ),
                ),
              )
                  .then(
                (_) {
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => StressChartScreen()));
                  }
                },
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: resultColor,
              side: const BorderSide(width: 1),
            ),
            child: Text(
              result.totalScore.toString(),
              style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                shadows: [
                  Shadow(offset: Offset(-1, -1), color: Colors.black),
                  Shadow(offset: Offset(1, -1), color: Colors.black),
                  Shadow(offset: Offset(1, 1), color: Colors.black),
                  Shadow(offset: Offset(-1, 1), color: Colors.black),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          formattedDate,
          style: textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
