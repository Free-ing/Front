import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'token_manager.dart';
import 'base_url.dart';

class HobbyAPIService {
  final Dio dio = Dio();
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 취미 루틴 추가
  Future<http.Response> postHobbyRoutine(
      String hobbyName, String imageUrl) async {
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

    return response;
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
  Future<http.Response> patchHobbyRoutine(
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

    return response;
  }

  //Todo: 취미 루틴 삭제
  Future<int> deleteHobbyRoutine(int routineId) async {
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

  //Todo: 취미 기록 저장
  Future<int> postHobbyRecord(
    String hobbyName,
    File imageFile,
    String hobbyBody,
    DateTime date,
  ) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final tokenStorage = TokenManager();
      final accessToken = await tokenStorage.getAccessToken();
      final url =
          Uri.parse('$_baseUrl/hobby-service/record?date=$formattedDate');

      // 기본 요청 데이터 생성
      var request = http.MultipartRequest('POST', url);

      // 헤더 설정
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });

      // 이미지 파일 추가
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      // Form 데이터에 JSON 문자열 추가 시 Content-Type 설정
      var hobbyRecordDtoJson = json.encode({
        'hobbyName': hobbyName,
        'hobbyBody': hobbyBody,
      });

      // JSON 데이터를 MultipartFile로 추가하여 Content-Type 지정
      request.files.add(
        http.MultipartFile.fromString(
          'hobbyRecordDto',
          hobbyRecordDtoJson,
          contentType: MediaType(
              'application', 'json'), // Content-Type을 application/json으로 설정
        ),
      );

      // 디버깅용 로그
      print('Request headers: ${request.headers}');
      print('Request files: ${request.files}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode;
    } catch (e) {
      print('Error in postHobbyRecord: $e');
      return 500;
    }
  }

  //Todo: 취미 사진첩 조회
  Future<http.Response> getHobbyAlbum(int year, int month) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/hobby-service/album-list?year=$year&month=$month');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 취미 기록 수정
  Future<int> putHobbyRecord(
    int recordId,
    String hobbyName,
    File? imageFile,
    String hobbyBody,
  ) async {
    try {
      final tokenStorage = TokenManager();
      final accessToken = await tokenStorage.getAccessToken();
      final url = Uri.parse('$_baseUrl/hobby-service/record/$recordId');

      // 기본 요청 데이터 생성
      var request = http.MultipartRequest('PUT', url);

      // 헤더 설정
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });

     if(imageFile != null) {
       // 이미지 파일 추가
       request.files.add(
         await http.MultipartFile.fromPath(
           'file',
           imageFile.path,
         ),
       );
     }

      // Form 데이터에 JSON 문자열 추가 시 Content-Type 설정
      var hobbyRecordDtoJson = json.encode({
        'hobbyName': hobbyName,
        'hobbyBody': hobbyBody,
      });

      // JSON 데이터를 MultipartFile로 추가하여 Content-Type 지정
      request.files.add(
        http.MultipartFile.fromString(
          'hobbyRecordDto',
          hobbyRecordDtoJson,
          contentType: MediaType(
              'application', 'json'), // Content-Type을 application/json으로 설정
        ),
      );

      // 디버깅용 로그
      print('Request headers: ${request.headers}');
      print('Request files: ${request.files}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode;
    } catch (e) {
      print('Error in postHobbyRecord: $e');
      return 500;
    }
  }

  //Todo: 취미 기록 삭제
  Future<int> deleteHobbyRecord(int recordId) async {
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
      body: json.encode(
        {
          'leisureActivities': answers[0],
          'stressReliefActivities': answers[1],
          'hobbyPreference': answers[2],
          'activityLocation': answers[3],
          'stressResponse': answers[4],
          'newActivityPreference': answers[5],
          'budget': answers[6],
        },
      ),
    );
  }
}
