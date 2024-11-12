class HobbyTracker {
  final String routineName;
  final String imageUrl;
  final List<Record> records;

  HobbyTracker({
    required this.routineName,
    required this.imageUrl,
    required this.records,
  });

  factory HobbyTracker.fromJson(Map<String, dynamic> json) {
    return HobbyTracker(
      routineName: json['hobbyName'],
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
