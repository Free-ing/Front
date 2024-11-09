import 'package:intl/intl.dart';

class MoodMonthly {
  DateTime date;
  String emotion;
  int diaryId;
  int recordId;

  MoodMonthly({
    required this.date,
    required this.emotion,
    required this.diaryId,
    required this.recordId,
  });

  factory MoodMonthly.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(json['date']);

    return MoodMonthly(
      date: parsedDate,
      emotion: json['emotion'],
      diaryId: json['diaryId'],
      recordId: json['recordId'],
    );
  }
}
