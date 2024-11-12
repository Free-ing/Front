class StressLevelResponse {
  final int recentTotalScore;
  final String recentStressLevel;
  final int? scoreDifference;

  StressLevelResponse({
    required this.recentTotalScore,
    required this.recentStressLevel,
    required this.scoreDifference,
  });

  // JSON을 객체로 변환하는 팩토리 생성자
  factory StressLevelResponse.fromJson(Map<String, dynamic> json) {
    return StressLevelResponse(
      recentTotalScore: json['recentTotalScore'],
      recentStressLevel: json['recentStressLevel'],
      scoreDifference: json['scoreDifference'],
    );
  }
}
