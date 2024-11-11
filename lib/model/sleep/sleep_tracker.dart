class RoutineRecord {
  final int routineId;
  final String routineName;
  final List<String> completeDay;
  final String url;

  RoutineRecord({
    required this.routineId,
    required this.routineName,
    required this.completeDay,
    required this.url,
  });

  factory RoutineRecord.fromJson(Map<String, dynamic> json) {
    return RoutineRecord(
      routineId: json['routineId'],
      routineName: json['routineName'],
      completeDay: List<String>.from(json['completeDay']),
      url: json['url'],
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
