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
      imageUrl: json['imageUrl'],
      sleepRoutineName: json['sleepRoutineName'],
      routineId: json['routineId'],
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

List<SleepList> defaultSleepList = [
  SleepList(imageUrl: 'assets/imgs/sleep/water.png', sleepRoutineName: '따뜻한 물 마시기', routineId: 1),
  SleepList(imageUrl: 'assets/imgs/sleep/coffee.png', sleepRoutineName: '6시간 전 커피 금지', routineId: 2),
  SleepList(imageUrl: 'assets/imgs/sleep/phone.png', sleepRoutineName: '30분 전 폰 금지', routineId: 3),
  SleepList(imageUrl: 'assets/imgs/sleep/bag.png', sleepRoutineName: '짐 미리 챙겨두기', routineId: 4),
];

