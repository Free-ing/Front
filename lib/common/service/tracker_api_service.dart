import 'package:freeing/common/service/base_url.dart';
import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TrackerApiService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  //Todo: 운동 루틴 트래커 조회
  Future<http.Response> getExerciseTracker(DateTime selectedDate) async {
    final int year = selectedDate.year;
    final int month = selectedDate.month;

    final accessToken = await tokenStorage.getAccessToken();

    final url =
        Uri.parse('$_baseUrl/exercise-service/tracker?year=$year&month=$month');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
  }

  //Todo: 수면 루틴 트래커 조회
  Future<http.Response> getSleepTracker(
      DateTime startDate, DateTime endDate) async {
    final parsedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final parsedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/sleep-service/routine/tracker?startDate=$parsedStartDate&endDate=$parsedEndDate');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
  }

  //Todo: 마음 채우기 루틴 트래커 조회
  Future<http.Response> getSpiritTracker(DateTime selectedDate) async {
    final int year = selectedDate.year;
    final int month = selectedDate.month;

    final accessToken = await tokenStorage.getAccessToken();

    final url =
        Uri.parse('$_baseUrl/spirit-service/tracker?year=$year&month=$month');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
  }

  //Todo: 취미 트래커 조회
  Future<http.Response> getHobbyTracker(DateTime selectedDate) async {
    final int year = selectedDate.year;
    final int month = selectedDate.month;

    final accessToken = await tokenStorage.getAccessToken();

    final url =
        Uri.parse('$_baseUrl/hobby-service/tracker?year=$year&month=$month');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
  }
}
