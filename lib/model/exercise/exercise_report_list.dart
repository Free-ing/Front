import 'dart:convert';

import 'package:intl/intl.dart';

class ExerciseReportList {
  final int feedbackId;
  final DateTime startDate;
  final DateTime endDate;

  ExerciseReportList({
    required this.feedbackId,
    required this.startDate,
    required this.endDate,
});

  factory ExerciseReportList.fromJson(Map<String, dynamic> json) {
    DateTime parsedStartDate = DateFormat('yyyy-MM-dd').parse(json['startDate']);
    DateTime parsedEndDate = DateFormat('yyyy-MM-dd').parse(json['endDate']);

    return ExerciseReportList(
     feedbackId: json['feedbackId'],
      startDate: parsedStartDate,
      endDate: parsedEndDate,

    );
  }
}