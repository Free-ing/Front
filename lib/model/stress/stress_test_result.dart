import 'package:intl/intl.dart';

class StressTestResult {
  int surveyId;
  int userId;
  int question1;
  int question2;
  int question3;
  int question4;
  int question5;
  int question6;
  int question7;
  int question8;
  int question9;
  int question10;
  int question11;
  int totalScore;
  String stressLevel;
  DateTime createdDate;
  String aiFeedback;

  StressTestResult({
    required this.surveyId,
    required this.userId,
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.question5,
    required this.question6,
    required this.question7,
    required this.question8,
    required this.question9,
    required this.question10,
    required this.question11,
    required this.totalScore,
    required this.stressLevel,
    required this.createdDate,
    required this.aiFeedback,
  });

  factory StressTestResult.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateFormat('yyyy-MM-dd').parse(json['createdDate']);

    return StressTestResult(
      surveyId: json['surveyId'],
      userId: json['userId'],
      question1: json['question1'],
      question2: json['question2'],
      question3: json['question3'],
      question4: json['question4'],
      question5: json['question5'],
      question6: json['question6'],
      question7: json['question7'],
      question8: json['question8'],
      question9: json['question9'],
      question10: json['question10'],
      question11: json['question11'],
      totalScore: json['totalScore'],
      stressLevel: json['stressLevel'],
      createdDate: parsedDate,
      aiFeedback: json['aiFeedback'],
    );
  }
}
