import 'dart:convert';

import 'package:http/http.dart' as http;
import 'token_manager.dart';
import 'base_url.dart';

class HobbyAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 취미 루틴 추가
  Future<int> postHobbyRoutine(
    String hobbyName,
    String imageUrl, int userId
  ) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine/$userId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'hobbyName': hobbyName,
        'imageUrl': imageUrl,
      }),
    );

    return response.statusCode;
  }

  //Todo: AI 취미 추천
  Future<http.Response> recommendHobby(List answers) async {
    final tokenStorage = TokenManager();
    //final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/ai/recommend');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
       // 'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'leisureActivities': answers[0],
        'stressReliefActivities': answers[1],
        'hobbyPreference': answers[2],
        'activityLocation': answers[3],
        'stressResponse': answers[4],
        'newActivityPreference': answers[5],
        'budget':answers[6],
      }),
    );

  }

  //Todo: 취미 리스트 조회
  Future<http.Response> getHobbyList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine-list');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 취미 사진첩 조회
  Future<http.Response> getHobbyAlbum(int year, int month) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/hobby-service/album-list?year=$year&month=$month');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 취미 기록 삭제
  Future<int> deleteHobbyRecord(int recordId, int userId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/record/$recordId/$userId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }
}
