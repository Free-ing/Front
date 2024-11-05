import 'dart:convert';

import 'package:freeing/common/service/token_manager.dart';
import 'package:http/http.dart' as http;

import 'base_url.dart';

class SettingAPIService {
  final String _baseUrl = BaseUrl.baseUrl;
  final tokenStorage = TokenManager();

  //Todo: 설정 화면 사용자 조회
  Future<http.Response> getUserInfo() async {
    //final tokenStorage = TokenManager();
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

  Future<http.Response> changePassword(
      String currentPassword, String newPassword) async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _changePasswordEndpoint =
        '$_baseUrl/user-service/change-password/after-login';
    final url = Uri.parse(_changePasswordEndpoint);

    return http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );
  }

  Future<http.Response> viewNoticeList() async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _viewNoticeListEndpoint =
        '$_baseUrl/user-service/announcement/list';
    final url = Uri.parse(_viewNoticeListEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  Future<http.Response> submitFeedback({
    required String category,
    required String inquiriesTitle,
    required String content,
  }) async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _viewUserInfoEndpoint = '$_baseUrl/user-service/inquiries';
    final url = Uri.parse(_viewUserInfoEndpoint);

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'category' : category,
        'inquiriesTitle' : inquiriesTitle,
        'content': content,
      }),
    );
  }

  Future<http.Response> viewFeedbackList() async {
    final accessToken = await tokenStorage.getAccessToken();
    final String _viewFeedbackListEndpoint =
        '$_baseUrl/user-service/inquiries/list';
    final url = Uri.parse(_viewFeedbackListEndpoint);

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  Future<http.Response> removeUser() async {
    try {
      final accessToken = await tokenStorage.getAccessToken();
      final String _removeUserEndpoint = '$_baseUrl/user-service/user/remove';
      final url = Uri.parse(_removeUserEndpoint);

      return await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      // 예외 발생 시 예외를 다시 던지거나 기본 응답을 반환
      throw Exception('Failed to remove user: $e');
      // 또는 기본 응답을 반환할 경우
      // return http.Response('Error', 500);
    }
  }

  Future<http.Response> resetData() async {
    try {
      final accessToken = await tokenStorage.getAccessToken();
      final String _resetDataEndpoint = '$_baseUrl/user-service/user/reset';
      final url = Uri.parse(_resetDataEndpoint);

      return await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      // 예외 발생 시 예외를 다시 던지거나 기본 응답을 반환
      throw Exception('Failed to reset Data: $e');
      // 또는 기본 응답을 반환할 경우
      // return http.Response('Error', 500);
    }
  }



}
