import 'package:flutter/material.dart';
import 'dart:math';

import '../const/colors.dart';


// TODO : 넘어온 날짜가 오늘과 같은 경우 초록원!!!
class CircleWidget extends StatefulWidget {
  final DateTime date;
  final String dayName;
  final bool isSelected;
  CircleWidget({required this.dayName, required this.date,required this.isSelected});

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;



    return Center(
      child: Container(
        color: Colors.transparent, // 배경색 설정
        child: SizedBox(
          width: screenWidth * 0.1,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if(widget.isSelected)
                    Container(
                      width: screenWidth * 0.105,
                      height: screenHeight * 0.0889,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFBF0), // Ivory color
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                    // Positioned(
                    //   child: Container(
                    //     width: screenWidth * 0.105,
                    //     height: screenHeight * 0.0889,
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFFFFBF0), // Ivory color
                    //       borderRadius: BorderRadius.circular(20),
                    //       border: Border.all(color: Colors.black, width: 1)
                    //     ),
                    //   ),
                    // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.dayName,
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: screenHeight * 0.01,),
                      CustomPaint(
                        size: Size(30,30),
                        painter: ColorfulCirclePainter(date: widget.date),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ColorfulCirclePainter extends CustomPainter {
  final DateTime date;

  ColorfulCirclePainter({required this.date});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    final today = DateTime.now();

    // 원의 중심과 반지름 설정
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if(date.year == today.year && date.month == today.month && date.day == today.day){
      paint.color = PRIMARY_COLOR;
      canvas.drawCircle(center, radius, paint);
    } else {
      // 각 영역의 색상 설정
      final colors = [
        Color(0xFF61D0B0),
        Color(0xFFFFCB85),
        Color(0xFFF69BF6),
        Color(0xFF609BDE)
      ];
      // 각 영역을 90도씩 그리기
      for (int i = 0; i < 4; i++) {
        paint.color = colors[i];
        final startAngle = i * pi / 2;
        final sweepAngle = pi / 2;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );
      }
      // 하얀 원 그리기
      paint.color = Colors.white;
      double innerCircleRadius = radius * 0.75;
      canvas.drawCircle(center, innerCircleRadius, paint);

    }

    // 검정 외곽선
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // 외곽선 두께 설정
    canvas.drawCircle(center, radius, paint);

    // 숫자 추가하기
    final textPainter = TextPainter(
      text: TextSpan(
        text: date.day.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w300,
          fontFamily: 'scdream',
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // 텍스트 크기 측정 후 중앙에 배치
    textPainter.layout();
    final textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, textOffset);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

