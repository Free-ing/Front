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
  Future<bool> checkSleepRoutine(
      bool isOn, String completeDay, int? sleepRoutineId) async {
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

      if (response.statusCode == 201) {
        print('수면 루틴 ${isOn ? '켜기' : '끄기'} 성공');
      } else {
        print('수면 루틴 ${isOn ? '켜기' : '끄기'} 실패');
      }
      return true;
    } else {
      return false;
    }
  }

  Future<http.Response> getExerciseRoutine(String queryDate) async {
    print('Exercise queryDate!!! $queryDate');
    final accessToken = await tokenStorage.getAccessToken();
    final String _getExerciseRoutineEndpoint =
        '$_baseUrl/exercise-service/home?date=$queryDate';
    final url = Uri.parse(_getExerciseRoutineEndpoint);

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
      final String _checkExerciseEndpoint = isOn
          ? '$_baseUrl/spirit-service/{$exerciseRoutineId}/complete'
          : '$_baseUrl/spirit-service/{$exerciseRoutineId}/cancel';
      final url = Uri.parse(_checkExerciseEndpoint);

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('운동 루틴 ${isOn ? '켜기' : '끄기'} 성공');
      } else {
        print('운동 루틴 ${isOn ? '켜기' : '끄기'} 실패');
      }
      return true;
    } else{
      return false;
    }
  }

  Future<http.Response> getSpiritRoutine(String queryDate) async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _getSpiritRoutineEndpoint =
        '$_baseUrl/spirit-service/home?date=$queryDate';
    final url = Uri.parse(_getSpiritRoutineEndpoint);

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
          ? '$_baseUrl/spirit-service/{$spiritRoutineId}/complete'
          : '$_baseUrl/spirit-service/{$spiritRoutineId}/cancel';
      final url = Uri.parse(_checkSpiritEndpoint);

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('마음 채우기 루틴 ${isOn ? '켜기' : '끄기'} 성공');
      } else {
        print('마음 채우기 루틴 ${isOn ? '켜기' : '끄기'} 실패');
      }
      return true;
    } else {
      return false;
    }
  }
}
