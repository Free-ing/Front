import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'token_manager.dart';
import 'base_url.dart';

class SpiritAPIService {
  //final String _baseUrl = BaseUrl.baseUrl;
  final String _baseUrl = 'http://172.25.11.156:9965';

  //Todo: 마음 채우기 루틴 추가
  Future<http.Response> postSpiritRoutine(
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

    return response;
  }

  //Todo: 마음 채우기 루틴 조회
  Future<http.Response> getSpiritList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine-list');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 마음 채우기 루틴 설명 조회
  Future<http.Response> getSpiritRoutineInfo(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/routine-info/$routineId');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 마음 채우기 루틴 수정
  Future<http.Response> patchSpiritRoutine(
    String spiritName,
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

    final url = Uri.parse('$_baseUrl/spirit-service/$routineId?today=$formattedDate');

    print(status);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(
        {
          'spiritName': spiritName,
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
          'status': status,
        },
      ),
    );

    return response;
  }

  //Todo: 마음 채우기 루틴 삭제
  Future<int> deleteSpiritRoutine(int routineId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/$routineId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 마음 채우기 루틴 켜기
  Future<int> onSpiritRoutine(int routineId) async {
    DateTime? date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/spirit-service/$routineId/on?date=$formattedDate');

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
        '$_baseUrl/spirit-service/$routineId/off?date=$formattedDate');

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
  Future<http.Response> postEmotionalDiary(String wellDone, String hardWork,
      bool getAiLetter, String emotion, int recordId) async {
    //final int recordId= 88;
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/emotional-diary/$recordId');

    print(recordId);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'wellDone': wellDone,
        'hardWork': hardWork,
        'getAiLetter': getAiLetter,
        'emotion': emotion,
      }),
    );

    return response;
  }

  //Todo: ai 편지 받기 요청
  Future<int> postLetterTrue(int diaryId) async{
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/ai/emotional-record/$diaryId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 월별 감정 조회
  Future<http.Response> getMoodList(int year, int month) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/spirit-service/emotional-record-list?year=$year&month=$month');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 특정 일기 조회
  Future<http.Response> getEmotionDiary(int diaryId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/emotional-record/$diaryId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: ai 편지 조회
  Future<http.Response> getAiLetter(int letterId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/spirit-service/ai-letter/$letterId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 스크랩한 감정 일기 조회
  Future<http.Response> getScrapList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/spirit-service/emotional-record-list/scrap');

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }

  //Todo: 감정 일기 스크랩 하기
  Future<int> scrapEmotionDiary(int diaryId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url =
        Uri.parse('$_baseUrl/spirit-service/emotional-records/scrap/$diaryId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 감정 일기 스크랩 취소
  Future<int> scrapCancelEmotionDiary(int diaryId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/spirit-service/emotional-records/scrap-cancel/$diaryId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }

  //Todo: 감정 일기 수정
  Future<int> editEmotionDiary(int diaryId, String wellDone, String hardWork, String emotion) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/emotional-record/$diaryId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'wellDone': wellDone,
        'hardWork': hardWork,
        'emotion': emotion,
      }),
    );

    return response.statusCode;
  }

  //Todo: 감정 일기 삭제
  Future<int> deleteEmotionDiary(int diaryId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/emotional-diary/$diaryId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    return response.statusCode;
  }

  //Todo: ai 편지 삭제
  Future<int> deleteAiLetter(int letterId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/spirit-service/ai/$letterId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    return response.statusCode;
  }
}
