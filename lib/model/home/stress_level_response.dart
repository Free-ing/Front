import 'package:intl/intl.dart';

class StressLevelResponse {
  final int recentTotalScore;
  final String recentStressLevel;
  final int? scoreDifference;
  final DateTime createdDate;

  StressLevelResponse({
    required this.recentTotalScore,
    required this.recentStressLevel,
    required this.scoreDifference,
    required this.createdDate,
  });

  // JSON을 객체로 변환하는 팩토리 생성자
  factory StressLevelResponse.fromJson(Map<String, dynamic> json) {

    return StressLevelResponse(
      recentTotalScore: json['recentTotalScore'] as int,
      recentStressLevel: json['recentStressLevel']as String,
      scoreDifference: json['scoreDifference'] as int?,
      createdDate: DateTime.parse(json['createdDate']),

    );
  }
}
