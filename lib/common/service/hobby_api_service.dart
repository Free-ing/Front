import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'token_manager.dart';
import 'base_url.dart';

class HobbyAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 취미 루틴 추가
  Future<int> postHobbyRoutine(String hobbyName, String imageUrl) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine');

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

  //Todo: 취미 루틴 수정
  Future<int> patchHobbyRoutine(
    String hobbyName,
    String imageUrl,
    int routineId,
  ) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine/$routineId');

    final response = await http.patch(
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

  //Todo: 취미 루틴 삭제
  Future<int> deleteHobbyRecord(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine/$routineId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 취미 기록
  Future<int> postHobbyRecord(
      String hobbyName, dynamic imageFile, String hobbyBody) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/record');
    // 멀티파트 요청 생성
    var request = http.MultipartRequest('POST', url);

    // 헤더 추가
    request.headers['Authorization'] = 'Bearer $accessToken';

    // 파일 추가
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // 서버에서 받을 필드명
        imageFile.path,
        filename: basename(imageFile.path), // 파일 이름 설정
      ),
    );

    // JSON 필드 추가
    request.fields['hobbyName'] = hobbyName;
    request.fields['hobbyBody'] = hobbyBody;

    // 멀티파트 요청을 서버에 전송
    var response = await request.send();

    // 응답 처리
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var responseData = json.decode(responseBody.body);
      print('서버 응답: $responseData');
    }

    return response.statusCode;
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
  Future<int> deleteHobbyRoutine(int recordId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/record/$recordId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: AI 취미 추천
  Future<http.Response> recommendHobby(List answers) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/ai/recommend');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'leisureActivities': answers[0],
        'stressReliefActivities': answers[1],
        'hobbyPreference': answers[2],
        'activityLocation': answers[3],
        'stressResponse': answers[4],
        'newActivityPreference': answers[5],
        'budget': answers[6],
      }),
    );
  }
}
