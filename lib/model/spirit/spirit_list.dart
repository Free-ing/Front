import 'package:intl/intl.dart';

class SpiritList {
  String mentalRoutineName;
  String imageUrl;
  int routineId;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;
  bool status;
  DateTime? startTime;
  DateTime? endTime;
  String? explanation;

  SpiritList(
      {required this.mentalRoutineName,
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
      required this.explanation});

  factory SpiritList.fromJson(Map<String, dynamic> json) {
    DateTime? parsedStartTime = json['startTime'] != null ? DateFormat('HH:mm').parse(json['startTime']) : null;
    DateTime? parsedEndTime = json['endTime'] != null ? DateFormat('HH:mm').parse(json['endTime']) : null;


    return SpiritList(
        mentalRoutineName: json['mentalRoutineName'],
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
        explanation: json['explanation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'mentalRoutineName' : mentalRoutineName,
      'imageUrl' : imageUrl,
      'routineId' : routineId,
      'monday' : monday,
      'tuesday' : tuesday,
      'wednesday' : wednesday,
      'thursday' : thursday,
      'friday' : friday,
      'saturday' : saturday,
      'sunday' : sunday,
      'status' : status,
      'startTime' : startTime?.toIso8601String(),
      'endTime' : endTime?.toIso8601String(),
      'explanation' : explanation,
    };
  }
}
