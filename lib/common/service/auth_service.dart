import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:freeing/screen/member/login.dart';
import 'package:http/http.dart' as http;
import '../component/toast_bar.dart';
import 'base_url.dart'; // 실제 API 서비스 임포트

class AuthService {
  final tokenStorage = TokenStorage();
  final String _baseUrl = BaseUrl.baseUrl;

  // TODO: refreshtoken으로 accessToken 발급 but refreshtoken도 만료된 경우 다시 로그인
  /// AccessToken 재발급
  Future<http.Response?> reissueAccessToken(BuildContext context) async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      // refreshToken이 없는 경우 로그인 페이지로 이동
      ToastBarWidget(
        title: '토큰 만료로 다시 로그인해주세요.',
      ).showToast(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      return null;
    }
    final url = Uri.parse('$_baseUrl/user-service/refresh-token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final newAccessToken = responseData['accessToken'];
      await tokenStorage.saveAccessTokens(newAccessToken);
      return response;
    } else if (response.statusCode == 400) {
      ToastBarWidget(
        title: '토큰 만료로 다시 로그인해주세요.',
      ).showToast(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      return null;
    } else {
      return response;
    }
  }
}
