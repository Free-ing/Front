import 'dart:convert';

// ExerciseRoutine 클래스 정의
class ExerciseRoutine {
  final String name;
  final String imageUrl;
  final int routineTime;

  ExerciseRoutine({
    required this.name,
    required this.imageUrl,
    required this.routineTime,
  });

  factory ExerciseRoutine.fromJson(Map<String, dynamic> json) {
    return ExerciseRoutine(
      name: json['name'],
      imageUrl: json['imageUrl'],
      routineTime: json['routineTime'],
    );
  }
}

// ExerciseData 클래스 정의
class ExerciseReport {
  final int totalExerciseTime;
  final int avgExerciseTime;
  final DateTime startTime;
  final DateTime endTime;
  final int monTime;
  final int tueTime;
  final int wenTime;
  final int thuTime;
  final int friTime;
  final int satTime;
  final int sunTime;
  final String feedBack;
  final List<ExerciseRoutine> exerciseRoutineDtoList;

  ExerciseReport({
    required this.totalExerciseTime,
    required this.avgExerciseTime,
    required this.startTime,
    required this.endTime,
    required this.monTime,
    required this.tueTime,
    required this.wenTime,
    required this.thuTime,
    required this.friTime,
    required this.satTime,
    required this.sunTime,
    required this.feedBack,
    required this.exerciseRoutineDtoList,
  });

  factory ExerciseReport.fromJson(Map<String, dynamic> json) {
    return ExerciseReport(
      totalExerciseTime: json['totalExerciseTime'],
      avgExerciseTime: json['avgExerciseTime'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      monTime: json['monTime'],
      tueTime: json['tueTime'],
      wenTime: json['wenTime'],
      thuTime: json['thuTime'],
      friTime: json['friTime'],
      satTime: json['satTime'],
      sunTime: json['sunTime'],
      feedBack: json['feedBack'],
      exerciseRoutineDtoList: (json['exerciseRoutineDtoList'] as List?)
          ?.map((item) => ExerciseRoutine.fromJson(item))
          .toList() ?? [],
    );
  }
}
