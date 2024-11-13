import 'package:freeing/common/service/base_url.dart';
import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;

class StressAPIService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  //Todo: 스트레스 측정 결과 리스트 조회
  Future<http.Response> getStressTestResultList(DateTime selectedDate) async {
    final year = selectedDate.year;
    final month = selectedDate.month;

    final accessToken = await tokenStorage.getAccessToken();

    final url =
        Uri.parse('$_baseUrl/user-service/stress-test/results/list/monthly?year=$year&month=$month');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  //Todo: 스트레스 지수 개별 상세 조회
  Future<http.Response> getStressTestResult(int surveyId) async {
    final accessToken = await tokenStorage.getAccessToken();

    final url =
        Uri.parse('$_baseUrl/user-service/stress-test/results/$surveyId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
}
