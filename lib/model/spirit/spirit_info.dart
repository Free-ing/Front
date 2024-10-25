class SpiritInfo {
  String explanation;
  String mentalRoutineName;

  SpiritInfo({
    required this.explanation,
    required this.mentalRoutineName,
  });

  factory SpiritInfo.fromJson(Map<String, dynamic>json) {
    return SpiritInfo(
      explanation: json['explanation'],
      mentalRoutineName: json['mentalRoutineName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'explanation': explanation,
      'mentalRoutineName': mentalRoutineName,
    };
  }
}
