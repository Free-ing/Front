class ExerciseTracker {
  final String routineName;
  final String imageUrl;
  final List<Record> records;

  ExerciseTracker({
    required this.routineName,
    required this.imageUrl,
    required this.records,
  });

  factory ExerciseTracker.fromJson(Map<String, dynamic> json) {
    return ExerciseTracker(
      routineName: json['exerciseName'],
      imageUrl: json['imageUrl'] ?? '',
      records:
          (json['records'] as List?)?.map((e) => Record.fromJson(e)).toList() ??
              [],
    );
  }
}

class Record {
  final int id;
  final String routineDate;

  Record({required this.id, required this.routineDate});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      routineDate: json['routineDate'],
    );
  }
}
