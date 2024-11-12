class SpiritTracker {
  final String mentalName;
  final List<Record> records;

  SpiritTracker({
    required this.mentalName,
    required this.records,
  });

  factory SpiritTracker.fromJson(Map<String, dynamic> json) {
    return SpiritTracker(
      mentalName: json['mentalName'],
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
