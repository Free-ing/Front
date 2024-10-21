class RecommendedHobby {
  String hobbyName;
  String explanation;

  RecommendedHobby({
    required this.hobbyName,
    required this.explanation,
  });

  factory RecommendedHobby.fromJson(Map<String, dynamic> json) {
    return RecommendedHobby(
      hobbyName: json['hobbyName'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'hobbyName': hobbyName,
      'explanation': explanation,
    };
  }
}
