import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/layout/chart_layout.dart';

class StressChartScreen extends StatefulWidget {
  const StressChartScreen({super.key});

  @override
  State<StressChartScreen> createState() => _StressChartScreenState();
}

class _StressChartScreenState extends State<StressChartScreen> {
  DateTime selectedDate = DateTime.now();

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
    });
    //Todo: 날짜 변경될 때마다 서버 요청 보내기
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChartLayout(
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
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth * 0.18,
                      height: 180,
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.18,
                            height: screenWidth * 0.18,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.red,
                                side: BorderSide(width: 1),
                              ),
                              child: Text(
                                '12',
                                style: TextStyle(
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
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.01),
                          Text('2024-11-1', style: textTheme.bodySmall,)
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        onDateSelected: updateSelectedDate);
  }
}
