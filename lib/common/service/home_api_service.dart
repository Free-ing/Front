import 'dart:convert';
import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'base_url.dart';

class HomeApiService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  bool isValidDateFormat(String completeDay) {
    try {
      DateFormat('yyyy-MM-dd').parseStrict(completeDay);
      return true; // 날짜 형식이 맞으면 true 반환
    } catch (e) {
      return false; // 형식이 맞지 않으면 false 반환
    }
  }

  // 수면 루틴 & 체크 박스 상태 받아오기 + 수면 시간 기록 상태 조회
  Future<http.Response> getSleepRoutine(int dayOfWeek, String queryDate) async {
    final Map<int, String> dayOfWeekMap = {
      1: 'MONDAY',
      2: 'TUESDAY',
      3: 'WEDNESDAY',
      4: 'THURSDAY',
      5: 'FRIDAY',
      6: 'SATURDAY',
      7: 'SUNDAY',
    };
    final String dayOfWeekString = dayOfWeekMap[dayOfWeek] ?? 'UNKNOWN';
    if (dayOfWeekString != 'UNKNOWN') {
      final accessToken = await tokenStorage.getAccessToken();
      final String _getSleepRoutineEndpoint =
          '$_baseUrl/sleep-service/routine/day?dayOfWeek=$dayOfWeekString&queryDate=$queryDate';
      final url = Uri.parse(_getSleepRoutineEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("요일이 unknown으로 뜸!!!!!");
      return Future.error("Invalid dayOfWeek value!!!!");
    }
  }
  Future<bool> checkSleepRoutine(bool isOn, String completeDay, int? sleepRoutineId) async {
    if (isValidDateFormat(completeDay) && sleepRoutineId != null) {
      final accessToken = await tokenStorage.getAccessToken();
      final String _checkSleepEndpoint =
          '$_baseUrl/sleep-service/routine/record';
      final url = Uri.parse(_checkSleepEndpoint);

      final response = await (isOn
          ? http.post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken',
              },
              body: json.encode({
                'completeDay': completeDay,
                'sleepRoutineId': sleepRoutineId,
              }),
            )
          : http.delete(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken',
              },
              body: json.encode({
                'completeDay': completeDay,
                'sleepRoutineId': sleepRoutineId,
              }),
            ));
      if(isOn ? response.statusCode == 201 : response.statusCode == 204){
        print('수면 루틴 ${isOn ? '체크' : '체크 취소'} 성공');
      } else {
        print('수면 루틴 ${isOn ? '체크' : '체크 취소'} 실패');
      }
      return true;
    } else {
      return false;
    }
  }
  Future<Map<String, dynamic>> getSleepTimeRecord(String queryDate) async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _getSleepTimeRecordEndpoint =
        '$_baseUrl/sleep-service/time-record/day?queryDate=$queryDate';
    final url = Uri.parse(_getSleepTimeRecordEndpoint);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      // JSON을 Map 형식으로 디코딩하여 반환
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load sleep record');
    }
  }

  // 운동 루틴 & 체크 박스 상태 받아오기
  Future<http.Response> getExerciseRoutine(String queryDate) async {
    //print('Exercise queryDate!!! $queryDate');
    final accessToken = await tokenStorage.getAccessToken();
    final String getExerciseRoutineEndpoint =
        '$_baseUrl/exercise-service/home?date=$queryDate';
    final url = Uri.parse(getExerciseRoutineEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<bool> checkExerciseRoutine(bool isOn, int? exerciseRoutineId) async {
    if(exerciseRoutineId != null){
      final accessToken = await tokenStorage.getAccessToken();
      final String checkExerciseEndpoint = isOn
          ? '$_baseUrl/exercise-service/$exerciseRoutineId/complete'
          : '$_baseUrl/exercise-service/$exerciseRoutineId/cancel';
      final url = Uri.parse(checkExerciseEndpoint);

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('운동 루틴 ${isOn ? '체크' : '체크 취소'} 성공');
      } else {
        print('운동 루틴 ${isOn ? '체크' : '체크 취소'} 실패');
      }
      return true;
    } else{
      return false;
    }
  }

  // 마음 채우기 루틴 & 체크 박스 상태 받아오기
  Future<http.Response> getSpiritRoutine(String queryDate) async {
    final accessToken = await tokenStorage.getAccessToken();
    final String getSpiritRoutineEndpoint =
        '$_baseUrl/spirit-service/home?date=$queryDate';
    final url = Uri.parse(getSpiritRoutineEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<bool> checkSpiritRoutine(bool isOn, int? spiritRoutineId) async {
    if (spiritRoutineId != null) {
      final accessToken = await tokenStorage.getAccessToken();
      final String _checkSpiritEndpoint = isOn
          ? '$_baseUrl/spirit-service/$spiritRoutineId/complete'
          : '$_baseUrl/spirit-service/$spiritRoutineId/cancel';
      final url = Uri.parse(_checkSpiritEndpoint);

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('마음 채우기 루틴 ${isOn ? '체크' : '체크 취소'} 성공');
      } else if(response.statusCode == 201){
        print('마음채우기 루틴 statuscode == 201');
      } else if(response.statusCode == 202){
        print('마음채우기 루틴 statuscode == 202');
      }else {
        print('마음 채우기 루틴 ${isOn ? '체크' : '체크 취소'} 실패');
        print('마음 채우기 루틴 상태 코드: ${response.statusCode}');
      }
      return true;
    } else {
      return false;
    }
  }

  // 운동 일주일 루틴 현황 받아오기 (핑크)
  Future<http.Response> getExerciseRecord(String startDate, String endDate) async {
    if(isValidDateFormat(startDate) && isValidDateFormat(endDate)){
      final accessToken = await tokenStorage.getAccessToken();
      final String getExerciseRecordEndpoint =
          '$_baseUrl/exercise-service/home/record-week/?startDate=$startDate&endDate=$endDate';
      final url = Uri.parse(getExerciseRecordEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("startDate와 endDate 형식이 올바르지 않음");
      return Future.error("startDate와 endDate 형식이 올바르지 않음");
    }
  }
  // 수면 일주일 루틴 현황 받아오기 (파랑)
  Future<http.Response> getSleepRecord(String startDate, String endDate) async {
    if(isValidDateFormat(startDate) && isValidDateFormat(endDate)){
      final accessToken = await tokenStorage.getAccessToken();
      final String getSleepRecordEndpoint =
          '$_baseUrl/sleep-service/routine/home/record-week?startDate=$startDate&endDate=$endDate';
      final url = Uri.parse(getSleepRecordEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("startDate와 endDate 형식이 올바르지 않음");
      return Future.error("startDate와 endDate 형식이 올바르지 않음");
    }
  }
  // 마음 채우기 일주일 루틴 현황 받아오기 (초록)
  Future<http.Response> getSpiritRecord(String startDate, String endDate) async {
    if(isValidDateFormat(startDate) && isValidDateFormat(endDate)){
      final accessToken = await tokenStorage.getAccessToken();
      final String getSpiritRecordEndpoint =
          '$_baseUrl/spirit-service/home/record-week?startDate=$startDate&endDate=$endDate';
      final url = Uri.parse(getSpiritRecordEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("startDate와 endDate 형식이 올바르지 않음");
      return Future.error("startDate와 endDate 형식이 올바르지 않음");
    }
  }
  // 취미 일주일 루틴 현황 받아오기 (노랑)
  Future<http.Response> getHobbyRecord(String startDate, String endDate) async {
    if(isValidDateFormat(startDate) && isValidDateFormat(endDate)){
      final accessToken = await tokenStorage.getAccessToken();
      final String getHobbyRecordEndpoint =
          '$_baseUrl/hobby-service/home/record-week?startDate=$startDate&endDate=$endDate';
      final url = Uri.parse(getHobbyRecordEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("startDate와 endDate 형식이 올바르지 않음");
      return Future.error("startDate와 endDate 형식이 올바르지 않음");
    }
  }
}
