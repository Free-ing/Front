import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/loading.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/common/service/stress_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/stress/stress_test_result.dart';
import 'package:freeing/screen/chart/stress_chart_screen.dart';
import 'package:freeing/screen/setting/setting_page.dart';
import 'package:intl/intl.dart';

class StressResultScreen extends StatefulWidget {
  final Widget? replacementScreen;
  final int surveyId;
  const StressResultScreen({super.key, required this.surveyId, this.replacementScreen});

  @override
  State<StressResultScreen> createState() => _StressResultScreenState();
}

class _StressResultScreenState extends State<StressResultScreen> {
  String name = '';
  StressTestResult? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchStressTestResult().then((data) {
      setState(() {
        result = data;
        isLoading = false;
      });
    });

    _viewUserInfo();
  }

  // Todo: 서버 요청 (사용자 이름 받아오기)
  Future<void> _viewUserInfo() async {
    final response = await SettingAPIService().getUserInfo();

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final userData = User.fromJson(json.decode(decodedBody));
      name = userData.name;
    } else {
      throw Exception('사용자 정보 가져오기 실패 ${response.statusCode}');
    }
  }

  //Todo: 서버 요청 (측정 결과 불러오기)
  Future<StressTestResult> _fetchStressTestResult() async {
    final apiService = await StressAPIService();

    final response = await apiService.getStressTestResult(widget.surveyId);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print(jsonData);
      if (jsonData != null) {
        return StressTestResult.fromJson(jsonData);
      } else {
        print('Error: Response data is null or does not contain expected key.');
        throw Exception('Invalid data structure from server');
      }
    } else {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print('jsonData error ${jsonData['error']}');
      throw Exception('일일 감정 일기 기록 조회 실패 ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final formattedDate = DateFormat('yyyy년 MM월 dd일')
        .format(result?.createdDate ?? DateTime.now());
    final int totalScore = result?.totalScore ?? -1;
    final String stressLevel = result?.stressLevel ?? '';
    final String aiFeedback = result?.aiFeedback ?? '';
    Color resultColor;

    switch (stressLevel) {
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

    return isLoading
        ? Loading()
        : ChartLayout(
            title: '스트레스 측정 결과',
            chartWidget: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '$formattedDate\n',
                            style: textTheme.titleSmall?.copyWith(
                                height: 1.8, fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(
                                text: '$name',
                                style: textTheme.titleSmall?.copyWith(
                                    height: 1.8, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '님의 스트레스 지수는\n$totalScore점 입니다.',
                                style:
                                    textTheme.titleSmall?.copyWith(height: 1.8),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: screenWidth * 0.18,
                              height: screenWidth * 0.18,
                              decoration: BoxDecoration(
                                color: resultColor,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  totalScore.toString(),
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
                              stressLevel,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.028),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 1),
                      ),
                      child: Text(
                        aiFeedback,
                        style: textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.028),
                    GreenButton(
                      width: screenWidth * 0.6,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.replacementScreen!),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.028),
                  ],
                ),
              ),
            ),
            onDateSelected: (date) {},
            selectMonth: false,
          );
  }
}
