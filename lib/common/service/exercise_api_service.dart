import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:freeing/common/service/base_url.dart';
import 'package:freeing/common/service/token_manager.dart';
import 'package:intl/intl.dart';

class ExerciseAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 운동 루틴 추가
  Future<http.Response> postExerciseRoutine(
    String routineName,
    String imageUrl,
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday,
    bool sunday,
    startTime,
    endTime,
    String explanation,
  ) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/exercise-service/routine');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'routineName': routineName,
        'imageUrl': imageUrl,
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'startTime': startTime,
        'endTime': endTime,
        'explanation': explanation,
        'status': true,
      }),
    );

    return response;
  }

  //Todo: 운동 루틴 조회
  Future<http.Response> getExerciseList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/exercise-service/routine-list');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 운동 루틴 수정
  Future<http.Response> patchExerciseRoutine(
    String routineName,
    String imageUrl,
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday,
    bool sunday,
    startTime,
    endTime,
    String explanation,
    bool status,
    int routineId,
  ) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final url =
        Uri.parse('$_baseUrl/exercise-service/$routineId?today=$formattedDate');

    print(status);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(
        {
          'routineName': routineName,
          'explanation': explanation,
          'sunday': sunday,
          'saturday': saturday,
          'friday': friday,
          'thursday': thursday,
          'wednesday': wednesday,
          'tuesday': tuesday,
          'monday': monday,
          'imageUrl': imageUrl,
          'startTime': startTime,
          'endTime': endTime,
          'status': status,
        },
      ),
    );

    return response;
  }

  //Todo: 운동 루틴 삭제
  Future<int> deleteExerciseRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/exercise-service/$routineId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 운동 채우기 루틴 켜기
  Future<int> onExerciseRoutine(int routineId) async {
    DateTime? date = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/exercise-service/$routineId/on?date=$formattedDate');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 운동 루틴 끄기
  Future<int> offExerciseRoutine(int routineId) async {
    DateTime? date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/exercise-service/$routineId/off?date=$formattedDate');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

//Todo: AI 운동 추천
  Future<http.Response> recommendExercise(List answers) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/exercise-service/routine/ai');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(
        {
          'exerciseType': answers[0],
          'preferredTime': answers[1],
          'preferredPlace': answers[2],
          'exercisePurpose': answers[3],
        },
      ),
    );
  }

  //Todo: 월별 운동 리포트 리스트 조회
  Future<http.Response> getReportList(DateTime selectedDate) async {
    final year = selectedDate.year;
    final month = selectedDate.month;
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();

    final url = Uri.parse(
        '$_baseUrl/exercise-service/report-list?year=$year&month=$month');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 주간 운동 리포트 조회
  Future<http.Response> getExerciseReport(
      DateTime startDate, DateTime endDate) async {
    final String formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate);
    final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    print('formattedEndDate $formattedEndDate');
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/exercise-service/report?startDate=$formattedStartDate&endDate=$formattedEndDate');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
}
