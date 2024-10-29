import 'package:intl/intl.dart';

class EmotionDiary {
  DateTime date;
  String emotion;
  int diaryId;
  String wellDone;
  String hardWork;
  bool scrap;
  int letterId;

  EmotionDiary({
    required this.date,
    required this.emotion,
    required this.diaryId,
    required this.wellDone,
    required this.hardWork,
    required this.scrap,
    required this.letterId,
  });

  factory EmotionDiary.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(json['date']);

    return EmotionDiary(
      date: parsedDate,
      emotion: json['emotion'],
      diaryId: json['diaryId'],
      wellDone: json['wellDone'],
      hardWork: json['hardWork'],
      scrap: json['scrap'],
      letterId: json['letterId'] ?? -1,
    );
  }
}
