import 'package:http/http.dart' as http;
import 'token_manager.dart';
import 'base_url.dart';

class HobbyAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 취미 리스트 조회
  Future<http.Response> getHobbyList(int userId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/hobby-service/routine-list/$userId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 취미 사진첩 조회
  Future<http.Response> getHobbyAlbum(int year, int month, int userId) async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse(
        '$_baseUrl/hobby-service/album-list/$userId?year=$year&month=$month');

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
