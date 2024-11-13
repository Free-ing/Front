import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/stress_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/stress/stress_testresult_list.dart';
import 'package:freeing/screen/chart/stress_result_screen.dart';

class StressChartScreen extends StatefulWidget {
  const StressChartScreen({
    super.key,
  });

  @override
  State<StressChartScreen> createState() => _StressChartScreenState();
}

class _StressChartScreenState extends State<StressChartScreen> {
  DateTime selectedDate = DateTime.now();
  List<StressTestResultsList> _stressTestResult = [];

  //Todo: 서버 요청 (스트레스 측정 결과 리스트 조회)
  Future<List<StressTestResultsList>> _fetchStressTestResultList(
      selectedDate) async {
    final apiService = StressAPIService();
    final response = await apiService.getStressTestResultList(selectedDate);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      _stressTestResult.clear();
      print('원본 데이터 $jsonData');
      for (dynamic data in jsonData) {
        StressTestResultsList results = StressTestResultsList.fromJson(data);
        _stressTestResult.add(results);
      }

      _stressTestResult.sort((a, b) => b.createdDate.compareTo(a.createdDate));

      return _stressTestResult;
    } else if (response.statusCode == 204) {
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

    print('확인 ~! $_stressTestResult');
  }

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
    });
    //Todo: 날짜 변경될 때마다 서버 요청 보내기
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
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.08),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: screenWidth * 0.06,
                      mainAxisSpacing: screenHeight * 0.1,
                    ),
                    itemCount: _stressTestResult.length,
                    itemBuilder: (context, index) {
                      Color resultColor;
                      final result = _stressTestResult[
                          _stressTestResult.length - 1 - index];

                      print('처리~ $index ~ ${result.surveyId}');
                      print('처리~ $index ~ ${result.totalScore}');
                      print('처리~ $index ~ ${result.surveyId}');

                      String formattedDate =
                          result.createdDate.replaceAll('-', '.');
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

                      return SizedBox(
                        width: screenWidth * 0.18,
                        height: 180,
                        child: Column(
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
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StressChartScreen()));
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
                                      Shadow(
                                          // bottomLeft
                                          offset: Offset(-1, -1),
                                          color: Colors.black),
                                      Shadow(
                                          // bottomRight
                                          offset: Offset(1, -1),
                                          color: Colors.black),
                                      Shadow(
                                          // topRight
                                          offset: Offset(1, 1),
                                          color: Colors.black),
                                      Shadow(
                                          // topLeft
                                          offset: Offset(-1, 1),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              formattedDate,
                              style: textTheme.bodySmall?.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        onDateSelected: updateSelectedDate);
  }
}
