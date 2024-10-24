import 'dart:convert';

import 'package:http/http.dart' as http;
import 'token_manager.dart';
import 'base_url.dart';

class HomeBottomSheetApiService {
  //static const String _baseUrl = BaseUrl.baseUrl;
  static const String _sleepTimeRecordEndpoint =
      'http://192.168.0.40:8000/sleep-service/sleep-time/record';

  Future<http.Response> sleepTimeRecord({
    required String wakeUpTime,
    required String sleepTime,
    required String recordDay,
    required String memo,
    required String sleepStatus,
  }) async {
    try{
      final tokenStorage = TokenManager();
      final accessToken = await tokenStorage.getAccessToken();
      final url = Uri.parse(_sleepTimeRecordEndpoint);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'wakeUpTime': wakeUpTime,
          'sleepTime': sleepTime,
          'recordDay': recordDay,
          'memo': memo,
          'sleepStatus': sleepStatus,
        }),
      );
      return response;
    }catch (e){
      print('오류 발생!!!!!!!!!!!!11: $e');
      rethrow;
    }
  }
}
