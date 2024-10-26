import 'dart:convert';

import 'package:http/http.dart' as http;
import 'token_manager.dart';
import 'base_url.dart';

class SpiritAPIService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  //Todo: 마음 채우기 루틴 추가
  Future<int> postSpiritRoutine(
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
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine');

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
        'statue': true,
      }),
    );

    return response.statusCode;
  }

  //Todo: 마음 채우기 루틴 조회
  Future<http.Response> getSpiritList() async {
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine-list');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 마음 채우기 루틴 설명 조회
  Future<http.Response> getSpiritRoutineInfo(int routineId) async {
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine-info/$routineId');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 마음 채우기 루틴 수정
  Future<int> patchSpiritRoutine(
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
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine-list');

    final response = await http.patch(
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
        'statue': true,
      }),
    );

    return response.statusCode;
  }

  //Todo: 마음 채우기 루틴 켜기
  Future<int> onSpiritRoutine(int routineId) async {
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/$routineId/on?month=${DateTime.now().month}&day=${DateTime.now().day}');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 마음 채우기 루틴 끄기
  Future<int> offSpiritRoutine(int routineId) async {
    //final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/$routineId/on?month=${DateTime.now().month}&day=${DateTime.now().day}');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 감정 일기 작성 하기
Future<int> postEmotionalDiary(
    String wellDone, String hardWork, bool getAiLetter, String emotion) async {
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/emotional-diary');

    final response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
      },
      body: json.encode({
        'wellDone' : wellDone,
        'hardWork' : hardWork,
        'getAiLet' : getAiLetter,
        'emotion' : emotion,
      }),
    );

    return response.statusCode;
  }
}
