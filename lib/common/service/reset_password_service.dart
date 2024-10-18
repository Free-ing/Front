import 'dart:convert';
import 'base_url.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService{
  static const String _baseUrl = BaseUrl.baseUrl;
  static const String _changePassword = '$_baseUrl:8000/user-service/change-password/before-login';

  static Future<bool> changePassword(String email, String newPassword) async{
    var url = Uri.parse(_changePassword);

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
        return true;
      } else {
        // 400 - 비밀번호 변경 실패
        print('400 - 비밀번호 변경 실패');
        return false;
      }
    } catch (e) {
      print('Error occured while sending data: $e');
      return false;
    }

  }



}