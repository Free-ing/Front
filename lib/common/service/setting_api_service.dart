import 'dart:convert';

import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;

import 'base_url.dart';

class SettingAPIService {
  final String _baseUrl = BaseUrl.baseUrl;

  //Todo: 설정 화면 사용자 조회
  Future<http.Response> getUserInfo() async {
    final tokenStorage = TokenManager();
    final accessToken = await tokenStorage.getAccessToken();
    final String _viewUserInfoEndpoint = '$_baseUrl/user-service/user';
    final url = Uri.parse(_viewUserInfoEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }



}