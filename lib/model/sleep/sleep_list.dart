class SleepList {
  String imageUrl;
  String sleepRoutineName;
  int routineId;

  SleepList({
    required this.imageUrl,
    required this.sleepRoutineName,
    required this.routineId,
  });

  factory SleepList.fromJson(Map<String, dynamic> json) {
    return SleepList(
      imageUrl: json['url'],
      sleepRoutineName: json['sleepRoutineName'],
      routineId: json['sleepRoutineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'sleepRoutineName': sleepRoutineName,
      'routineId': routineId,
    };
  }
}
