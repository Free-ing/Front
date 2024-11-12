class RoutineRecord {
  final int routineId;
  final String routineName;
  final List<String> records;
  final String imageUrl;

  RoutineRecord({
    required this.routineId,
    required this.routineName,
    required this.records,
    required this.imageUrl,
  });

  factory RoutineRecord.fromJson(Map<String, dynamic> json) {
    return RoutineRecord(
      routineId: json['routineId'],
      routineName: json['routineName'],
      records: List<String>.from(json['completeDay'] ?? []),
      imageUrl: json['url'],
    );
  }
}

class SleepTracker {
  final List<RoutineRecord> routineRecords;
  final List<String> timeRecords;

  SleepTracker({
    required this.routineRecords,
    required this.timeRecords,
  });

  factory SleepTracker.fromJson(Map<String, dynamic> json) {
    return SleepTracker(
      routineRecords: (json['routineRecords'] as List?)
              ?.map((record) => RoutineRecord.fromJson(record))
              .toList() ??
          [],
      timeRecords: List<String>.from(json['timeRecords'] ?? []),
    );
  }
}
