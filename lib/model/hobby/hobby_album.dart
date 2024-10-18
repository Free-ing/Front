import 'package:intl/intl.dart' show DateFormat;

class HobbyAlbum {
  DateTime date;
  String hobbyName;
  String photoUrl;
  String recordBody;
  int recordId;

  HobbyAlbum({
    required this.date,
    required this.hobbyName,
    required this.photoUrl,
    required this.recordBody,
    required this.recordId,
  });

  factory HobbyAlbum.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(json['date']);

    return HobbyAlbum(
      date: parsedDate,
      hobbyName: json['hobbyName'],
      photoUrl: json['photoUrl'],
      recordBody: json['recordBody'],
      recordId: json['recordId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'hobbyName': hobbyName,
      'photoUrl': photoUrl,
      'recordBody': recordBody,
      'recordId': recordId
    };
  }
}
