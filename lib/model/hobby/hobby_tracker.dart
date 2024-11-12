class HobbyTracker {
  final String hobbyName;
  final List<Record> records;

  HobbyTracker({
    required this.hobbyName,
    required this.records,
  });

  factory HobbyTracker.fromJson(Map<String, dynamic> json) {
    return HobbyTracker(
      hobbyName: json['hobbyName'],
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
