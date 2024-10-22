import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class SleepAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 수면 리스트 조회 ---- 일단 예시로 적어둠!!!
  Future<http.Response> getSleepList() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/??');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }


}