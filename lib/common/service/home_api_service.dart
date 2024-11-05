import 'dart:convert';
import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class HomeApiService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  Future<http.Response> getSleepRoutine(int dayOfWeek, String queryDate) async {
    final Map<int, String> dayOfWeekMap = {
      1: 'MONDAY',
      2: 'TUESDAY',
      3: 'WEDNESDAY',
      4: 'THURSDAY',
      5: 'FRIDAY',
      6: 'SATURDAY',
      7: 'SUNDAY',
    };
    final String dayOfWeekString = dayOfWeekMap[dayOfWeek] ?? 'UNKNOWN';
    if(dayOfWeekString != 'UNKNOWN'){
      final accessToken = await tokenStorage.getAccessToken();
      final String _getSleepRoutineEndpoint =
          '$_baseUrl/sleep-service/routine/day?dayOfWeek=$dayOfWeekString&queryDate=$queryDate';
      final url = Uri.parse(_getSleepRoutineEndpoint);

      return http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } else {
      print("요일이 unknown으로 뜸!!!!!");
      return Future.error("Invalid dayOfWeek value!!!!");
    }
  }


}
