import 'package:intl/intl.dart';

class StressTestResultsList {
  int surveyId;
  int totalScore;
  String stressLevel;
  String createdDate;

  StressTestResultsList({
    required this.surveyId,
    required this.totalScore,
    required this.stressLevel,
    required this.createdDate,
  });

  factory StressTestResultsList.fromJson(Map<String, dynamic> json) {
    return StressTestResultsList(
      surveyId: json['surveyId'],
      totalScore:json['totalScore'],
      stressLevel: json['stressLevel'],
      createdDate: json['createdDate'],
    );
  }
}
