class SpiritList {
  String imageUrl;
  String mentalRoutineName;
  int routineId;

  SpiritList({
    required this.imageUrl,
    required this.mentalRoutineName,
    required this.routineId,
  });

  factory SpiritList.fromJson(Map<String, dynamic> json) {
    return SpiritList(
      imageUrl: json['imageUrl'],
      mentalRoutineName: json['mentalRoutineName'],
      routineId: json['routineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'sleepRoutineName': mentalRoutineName,
      'routineId': routineId,
    };
  }
}

List<SpiritList> defaultSleepList = [
  SpiritList(imageUrl: 'https://freeingimage.s3.ap-northeast-2.amazonaws.com/meditaiton_routine.png', mentalRoutineName: '명상', routineId: 1),
  SpiritList(imageUrl: 'https://freeingimage.s3.ap-northeast-2.amazonaws.com/emotional_diary.png', mentalRoutineName: '감정 일기', routineId: 2),
];

