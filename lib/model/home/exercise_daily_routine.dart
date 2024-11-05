import 'package:intl/intl.dart';

class ExerciseDailyRoutine {
  final String? timestamp;
  final bool? success;
  final String? code;
  final String? message;
  final List<ExerciseRoutineDetail>? result;

  ExerciseDailyRoutine({
    required this.timestamp,
    required this.success,
    required this.code,
    required this.message,
    required this.result,
  });

  factory ExerciseDailyRoutine.fromJson(Map<String, dynamic> json) {
    var resultList = json['result'] as List<dynamic>?;

    return ExerciseDailyRoutine(
      timestamp: json['timestamp'],
      success: json['success'],
      code: json['code'],
      message: json['message'],
      result: resultList?.map((item) => ExerciseRoutineDetail.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'success': success,
      'code': code,
      'message': message,
      'result': result?.map((item) => item.toJson()).toList(),
    };
  }
}

class ExerciseRoutineDetail {
  final String? imageUrl;
  final int? routineId;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;
  final bool? sunday;
  final bool? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? explanation;
  final String? basicService;
  final int? recordId;
  final bool? complete;
  final String? name;

  ExerciseRoutineDetail({
    required this.imageUrl,
    required this.routineId,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.explanation,
    required this.basicService,
    required this.recordId,
    required this.complete,
    required this.name,
  });

  factory ExerciseRoutineDetail.fromJson(Map<String, dynamic> json) {
    DateTime? parsedStartTime = json['startTime'] != null
        ? DateFormat('HH:mm:ss').parse(json['startTime'])
        : null;
    DateTime? parsedEndTime = json['endTime'] != null
        ? DateFormat('HH:mm:ss').parse(json['endTime'])
        : null;

    return ExerciseRoutineDetail(
      imageUrl: json['imageUrl'],
      routineId: json['routineId'],
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
      status: json['status'],
      startTime: parsedStartTime,
      endTime: parsedEndTime,
      explanation: json['explanation'],
      basicService: json['basicService'],
      recordId: json['recordId'],
      complete: json['complete'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'routineId': routineId,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'explanation': explanation,
      'basicService': basicService,
      'recordId': recordId,
      'complete': complete,
      'name': name,
    };
  }
}
