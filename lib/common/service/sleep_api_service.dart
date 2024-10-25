import 'dart:convert';

import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/find_locale.dart';
import 'base_url.dart';

class SleepAPIService {
  //final String _baseUrl = BaseUrl.baseUrl;
  static const String _viewAllSleepRoutineEndpoint =
      'http://192.168.0.40:8000/sleep-service/routine/all';

  //Todo: 수면 루틴 추가
  Future<int> postSleepRoutine(
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
    String explanation,
    String url,
  ) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('http://172.30.1.3:8000/sleep-service/routine/add');

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
        'explanation': explanation,
        'status': true,
        'url': url,
      }),
    );

    return response.statusCode;
  }

  //Todo: 수면 리스트 조회
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

// TODO: 수면 루틴 toggle on (활성화)
  Future<int> activateSleepRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        'http://192.168.0.40:8000/sleep-service/routine/$routineId/activate');

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

// TODO: 수면 루틴 toggle off (비활성화)
  Future<int> deactivateSleepRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        'http://172.30.1.78:8000/sleep-service/routine/$routineId/deactivate');

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
}
