import 'package:intl/intl.dart';

class MoodMonthly {
  DateTime routineDate;
  String emotion;
  int diaryId;
  int recordId;

  MoodMonthly({
    required this.routineDate,
    required this.emotion,
    required this.diaryId,
    required this.recordId,
  });

  factory MoodMonthly.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(json['routineDate']);

    return MoodMonthly(
      routineDate: parsedDate,
      emotion: json['emotion'] ??'',
      diaryId: json['diaryId'] ?? -1,
      recordId: json['recordId'] ?? -1,
    );
  }
}
