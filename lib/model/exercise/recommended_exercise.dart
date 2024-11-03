class RecommendedExercise {
  String exerciseName;
  String explanation;

  RecommendedExercise({
    required this.exerciseName,
    required this.explanation,
  });

  factory RecommendedExercise.fromJson(Map<String, dynamic> json) {
    return RecommendedExercise(
      exerciseName: json['exerciseName'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'explanation': explanation,
    };
  }
}
