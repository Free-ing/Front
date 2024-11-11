import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui' as ui;

import '../const/colors.dart';

class CircleWidget extends StatefulWidget {
  final DateTime date;
  final String dayName;
  final bool isSelected;
  final List<String> exerciseDates;
  final List<String> sleepDates;
  final List<String> spiritDates;
  final List<String> hobbyDates;

  CircleWidget({
    required this.dayName,
    required this.date,
    required this.isSelected,
    required this.exerciseDates,
    required this.sleepDates,
    required this.spiritDates,
    required this.hobbyDates,
  });

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final widgetDate =
        DateTime(widget.date.year, widget.date.month, widget.date.day);

    final isToday = widgetDate == today;
    final isAfterToday = widgetDate.isAfter(today);

    return Center(
      child: Container(
        color: Colors.transparent,
        child: SizedBox(
          width: screenWidth * 0.1,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isToday)
                    Container(
                      width: screenWidth * 0.105,
                      height: screenHeight * 0.0889,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF0), // 아이보리 색상
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.dayName,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomPaint(
                        size: const Size(31.5, 31.5),
                        painter: ColorfulCirclePainter(
                          date: widget.date,
                          isSelected: widget.isSelected,
                          isAfterToday: isAfterToday,
                          exerciseDates: widget.exerciseDates,
                          sleepDates: widget.sleepDates,
                          spiritDates: widget.spiritDates,
                          hobbyDates: widget.hobbyDates,
                        ),
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
  final bool isSelected;
  final bool isAfterToday;
  final List<String> exerciseDates;
  final List<String> sleepDates;
  final List<String> spiritDates;
  final List<String> hobbyDates;

  ColorfulCirclePainter(
      {required this.date,
      required this.isSelected,
      required this.isAfterToday,
      required this.exerciseDates,
      required this.sleepDates,
      required this.spiritDates,
      required this.hobbyDates});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final today = DateTime.now();

    print('date $date');
    // Center and radius for the circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    String dateString = DateFormat('yyyy-MM-dd').format(date);

    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);

    if (isAfterToday && !isSelected) {
      paint.color = Colors.white;
      canvas.drawCircle(center, radius, paint);
    } else if (isSelected) {
      paint.color = PRIMARY_COLOR;
      canvas.drawCircle(center, radius, paint);
    } else {
      final colors = [
        Color(0xFF61D0B0), // 마음 채우기
        Color(0xFFFFCB85), // 취미
        Color(0xFFF69BF6), // 운동
        Color(0xFF609BDE) // 수면
      ];

      for (int i = 0; i < 4; i++) {
        switch (i) {
          case 0:
            if (spiritDates.contains(dateString)) {
              paint.color = colors[0];
            } else {
              continue;
            }
            break;
          case 1:
            if (hobbyDates.contains(dateString)) {
              paint.color = colors[1];
            } else {
              continue;
            }
            break;
          case 2:
            if (exerciseDates.contains(dateString)) {
              paint.color = colors[2];
            } else {
              continue;
            }
            break;
          case 3:
            if (sleepDates.contains(dateString)) {
              paint.color = colors[3];
            } else {
              continue;
            }
            break;
        }
        //paint.color = colors[i];
        final startAngle = i * pi / 2;
        const sweepAngle = pi / 2;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );
      }

      // 내부 흰색 원 생성
      paint.color = Colors.white;
      double innerCircleRadius = radius * 0.74;
      canvas.drawCircle(center, innerCircleRadius, paint);
    }

    // 검은색 외곽선
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, paint);

    // 날짜 숫자 표시
    final textPainter = TextPainter(
      text: TextSpan(
        text: date.day.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w300,
          fontFamily: 'scdream',
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
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
