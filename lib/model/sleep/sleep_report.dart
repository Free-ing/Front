import 'package:intl/intl.dart';

class WeeklyReport {
  final int sleepWeeklyReportId;
  final int userId;
  final String avgSleepTime;
  final String avgWakeUpTime;
  final int avgSleepDurationInMinutes;
  final String reportStartDate;
  final String reportEndDate;
  final String aiFeedback;

  WeeklyReport({
    required this.sleepWeeklyReportId,
    required this.userId,
    required this.avgSleepTime,
    required this.avgWakeUpTime,
    required this.avgSleepDurationInMinutes,
    required this.reportStartDate,
    required this.reportEndDate,
    required this.aiFeedback,
  });

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {

    return WeeklyReport(
      sleepWeeklyReportId: json['sleepWeeklyReportId'],
      userId: json['userId'],
      avgSleepTime: json['avgSleepTime'],
      avgWakeUpTime: json['avgWakeUpTime'],
      avgSleepDurationInMinutes: json['avgSleepDurationInMinutes'],
      reportStartDate: json['reportStartDate'],
      reportEndDate: json['reportEndDate'],
      aiFeedback: json['aiFeedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleepWeeklyReportId': sleepWeeklyReportId,
      'userId': userId,
      'avgSleepTime': avgSleepTime,
      'avgWakeUpTime': avgWakeUpTime,
      'avgSleepDurationInMinutes': avgSleepDurationInMinutes,
      'reportStartDate': reportStartDate,
      'reportEndDate': reportEndDate,
      'aiFeedback': aiFeedback,
    };
  }

  String _formatToKoreanTime(String time){
    final DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    final String formattedTime = DateFormat('a hh시 mm분', 'ko_KR').format(dateTime);
    return formattedTime.replaceAll('AM', '오전').replaceAll('PM', '오후');
  }

  String get formattedAvgSleepTime => _formatToKoreanTime(avgSleepTime);
  String get formattedAvgWakeUpTime => _formatToKoreanTime(avgWakeUpTime);
}

class SleepRecord {
  final int sleepTimeRecordId;
  final int userId;
  final String wakeUpTime;
  final String sleepTime;
  final String recordDay;
  final String memo;
  final String sleepStatus;
  final int sleepDurationInMinutes;

  SleepRecord({
    required this.sleepTimeRecordId,
    required this.userId,
    required this.wakeUpTime,
    required this.sleepTime,
    required this.recordDay,
    required this.memo,
    required this.sleepStatus,
    required this.sleepDurationInMinutes,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      sleepTimeRecordId: json['sleepTimeRecordId'],
      userId: json['userId'],
      wakeUpTime: json['wakeUpTime'],
      sleepTime: json['sleepTime'],
      recordDay: json['recordDay'],
      memo: json['memo'],
      sleepStatus: json['sleepStatus'],
      sleepDurationInMinutes: json['sleepDurationInMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleepTimeRecordId': sleepTimeRecordId,
      'userId': userId,
      'wakeUpTime': wakeUpTime,
      'sleepTime': sleepTime,
      'recordDay': recordDay,
      'memo': memo,
      'sleepStatus': sleepStatus,
      'sleepDurationInMinutes': sleepDurationInMinutes,
    };
  }

  String _formatToKoreanTime(String date){
    final DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    final String formattedDate = DateFormat('MM월 dd일', 'ko_KR').format(dateTime);
    return formattedDate;
  }

  String get formattedDate => _formatToKoreanTime(recordDay);

}

class ResponseData {
  final WeeklyReport weeklyReport;
  final List<SleepRecord> sleepRecords;

  ResponseData({
    required this.weeklyReport,
    required this.sleepRecords,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      weeklyReport: WeeklyReport.fromJson(json['weeklyReport']),
      sleepRecords: List<SleepRecord>.from(
        json['sleepRecords'].map((record) => SleepRecord.fromJson(record)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklyReport': weeklyReport.toJson(),
      'sleepRecords': sleepRecords.map((record) => record.toJson()).toList(),
    };
  }
}
