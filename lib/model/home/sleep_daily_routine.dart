import 'package:intl/intl.dart';

class SleepDailyRoutine {
  final int? sleepRoutineId;
  final int? userId;
  final String? sleepRoutineName;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;
  final bool? sunday;
  final bool status;
  final String? url;
  final bool? completed;
  DateTime? startTime;
  DateTime? endTime;
  DateTime createDate;
  DateTime? onDate;
  DateTime? offDate;

  SleepDailyRoutine(
      {this.sleepRoutineId,
      this.userId,
      required this.sleepRoutineName,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday,
      required this.status,
      this.url,
      this.completed,
      this.startTime,
      this.endTime,
      required this.createDate,
      this.onDate,
      this.offDate
      });

  factory SleepDailyRoutine.fromJson(Map<String, dynamic> json) {
    //print('Parsing SleepDailyRoutine: $json');

    final routine = json['sleepRoutine'] ?? {};

    DateTime? parsedStartTime = routine['startTime'] != null
        ? DateFormat('HH:mm').parse(routine['startTime'])
        : null;
    DateTime? parsedEndTime = routine['endTime'] != null
        ? DateFormat('HH:mm').parse(routine['endTime'])
        : null;
    if (routine['createDate'] == null) {
      throw Exception('createDate가 JSON에서 누락되었습니다.');
    }
    DateTime? parsedOnDate = routine['onDate'] != null
        ? DateTime.parse(routine['onDate'])
        : null;
    DateTime? parsedOffDate = routine['offDate'] != null
        ? DateTime.parse(routine['offDate'])
        : null;

    return SleepDailyRoutine(
        sleepRoutineId: routine['sleepRoutineId'],
        userId: routine['userId'],
        sleepRoutineName: routine['sleepRoutineName'],
        monday: routine['monday'],
        tuesday: routine['tuesday'],
        wednesday: routine['wednesday'],
        thursday: routine['thursday'],
        friday: routine['friday'],
        saturday: routine['saturday'],
        sunday: routine['sunday'],
        status:routine['status'],
        url: routine['url'],
        completed: json['completed'],
        startTime: parsedStartTime,
        endTime: parsedEndTime,
        createDate: DateTime.parse(routine['createDate']),
        onDate: parsedOnDate,
        offDate: parsedOffDate
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'sleepRoutineId': sleepRoutineId,
      'userId': userId,
      'sleepRoutineName': sleepRoutineName,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'status': status,
      'url': url,
      'completed': completed,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'onDate': onDate?.toIso8601String(),
      'offDate': offDate?.toIso8601String(),
    };
  }

}
