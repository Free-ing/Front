import 'dart:convert';

import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'base_url.dart';

class SleepAPIService {
  static const String _baseUrl = BaseUrl.baseUrl;
  static const String _viewAllSleepRoutineEndpoint =
      '$_baseUrl/sleep-service/routine/all';

  get tokenStorage => null;

  // 수면 루틴 추가
  Future<http.Response> postSleepRoutine(
      String sleepRoutineName,
      startTime,
      endTime,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      String imageUrl) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/sleep-service/routine/add');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'sleepRoutineName': sleepRoutineName,
        'startTime': startTime,
        'endTime': endTime,
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'status': true,
        'url': imageUrl,
      }),
    );

    return response;
  }

  // 수면 루틴 수정
  Future<http.Response> patchSleepRoutine(
      String sleepRoutineName,
      startTime,
      endTime,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      bool status,
      String imageUrl,
      int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/sleep-service/routine/update/$routineId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'sleepRoutineName': sleepRoutineName,
        'startTime': startTime,
        'endTime': endTime,
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'status': status,
        'url': imageUrl,
      }),
    );

    return response;
  }

  // 수면 루틴 삭제
  Future<int> deleteSleepRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/sleep-service/routine/remove/$routineId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  // 수면 리스트 조회
  Future<http.Response> getSleepList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(_viewAllSleepRoutineEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  // 수면 기록 toggle 상태 불러오기
  Future<bool> getRecordSleepStatus() async{
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    const String _getRecordStatusEndpoint = '$_baseUrl/sleep-service/time-record';
    final url = Uri.parse(_getRecordStatusEndpoint);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('수면 기록 상태 불러오기 성공');
      final data = jsonDecode(response.body); // JSON 파싱
      return data['status']; // 응답의 "isRecordOn" 값 반환
    } else if (response.statusCode == 401) {
      print('수면 기록 상태 불러오기 실패');
      return false;
    } else if (response.statusCode == 500) {
      print('수면 기록 상태 불러오기 실패');
      return false;
    } else {
      print('수면 기록 상태 코드: ${response.statusCode}');
      return false;
    }
  }

  // 수면 기록 toggle on / off
  Future<bool> sleepRecord(bool isRecordOn) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final String _sleepRecordEndpoint = isRecordOn
        ? '$_baseUrl/sleep-service/time-record/status/on'
        : '$_baseUrl/sleep-service/time-record/status/off';
    final url = Uri.parse(_sleepRecordEndpoint);

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('수면 기록 ${isRecordOn ? 'on' : 'off'} 성공');
      return true;
    } else if (response.statusCode == 401) {
      print('수면 기록 statuscode == 401');
      return false;
    } else if (response.statusCode == 500) {
      print('수면 기록 statuscode == 500');
      return false;
    } else {
      print('수면 기록 ${isRecordOn ? 'on' : 'off'} 실패');
      print('수면 기록 상태 코드: ${response.statusCode}');
      return false;
    }
  }

  // 수면 루틴 toggle on (활성화)
  Future<int> activateSleepRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
    Uri.parse('$_baseUrl/sleep-service/routine/$routineId/activate');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'routineId': routineId,
        }),
      );
      return response.statusCode;
    } catch (e) {
      print('Error occured while sending data: $e');
      return -1;
    }
  }

  // 수면 루틴 toggle off (비활성화)
  Future<int> deactivateSleepRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
    Uri.parse('$_baseUrl/sleep-service/routine/$routineId/deactivate');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'routineId': routineId,
        }),
      );
      return response.statusCode;
    } catch (e) {
      print('Error occured while sending data: $e');
      return -1;
    }
  }

  //Todo: 주간 수면 리포트 조회
  Future<http.Response> getSleepReport(
      DateTime startDate, DateTime endDate) async {
    final String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    print('formattedEndDate $formattedEndDate');
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/sleep-service/weekly-report?startDate=$formattedStartDate&endDate=$formattedEndDate');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

  }
}