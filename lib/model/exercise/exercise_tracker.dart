class ExerciseTracker {
  final String exerciseName;
  final List<Record> records;

  ExerciseTracker({
    required this.exerciseName,
    required this.records,
  });

  factory ExerciseTracker.fromJson(Map<String, dynamic> json) {
    return ExerciseTracker(
      exerciseName: json['exerciseName'],
      records:
          (json['record'] as List?)?.map((e) => Record.fromJson(e)).toList() ??
              [],
    );
  }
}

class Record {
  final int id;
  final DateTime routineDate;

  Record({required this.id, required this.routineDate});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      routineDate: DateTime.parse(json['routineDate']),
    );
  }
}
