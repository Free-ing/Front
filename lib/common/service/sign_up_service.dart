import 'dart:convert';
import 'base_url.dart';
import 'package:http/http.dart' as http;

enum VerificationStatus{
  success,
  codeNotFound,
  codeExpired,
  invalidCode,
  serverError,
}

class SignUpService {
  static const String _baseUrl = BaseUrl.baseUrl;
  static const String _signUpEndpoint = '$_baseUrl:8000/user-service/signup';
  static const String _checkEmailEndpoint =
      '$_baseUrl:8000/user-service/check-email';


  static Future<bool> checkEmail(String email) async {
    var url = Uri.parse(_checkEmailEndpoint);

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        bool emailExists =jsonDecode(response.body) as bool;
        print('응답이 정상적으로 왔음');
        return emailExists;

      } else if (response.statusCode == 400) {
        print('요청 형식이 올바르지 않음(유효설 검사 실패)');
        return false;
      } else {
        // 500 - 서버 내부 오류
        print('서버 내부 오류');
        return false;
      }
    } catch (e) {
      print('Error occured while sending email: $e');
      return false;
    }
  }

  static Future<bool> sendVerificationEmail(String email) async {
    final String _sendVerificationEndpoint =
        '$_baseUrl:8000/user-service/email/send-verification?email=$email';

    try {
      var url = Uri.parse(_sendVerificationEndpoint);

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        print('Verification email sent successfully');
        return true;
      } else {
        print('Failed to send verification email');
        return false;
      }
    } catch (e) {
      print('Error occured: $e');
      return false;
    }
  }


  static Future<VerificationStatus> verifyCode(String email,String code) async {
    final String _verifyCodeEndpoint = '$_baseUrl:8000/user-service/email/verify?email=$email&code=$code';
    var url = Uri.parse(_verifyCodeEndpoint);

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'code' : code,
        }),
      );
      print(email);
      print(code);

      if (response.statusCode == 200) {
        print('응답이 정상적으로 왔음');
        return VerificationStatus.success;
      } else if (response.statusCode == 404) {
        print('인증 기록이 존재하지 않음');
        return VerificationStatus.codeNotFound;
      } else if (response.statusCode == 400) {
        print('인증 코드가 만료되었습니다. 새 인증 코드를 요청해주세요.');
        return VerificationStatus.codeExpired;
      } else {
        // 401 - 서버 내부 오류
        print('인증 실패: 입력한 인증 코드가 올바르지 않습니다. 다시 시도해주세요.');
        return VerificationStatus.invalidCode;
      }
    } catch (e) {
      print('Error occured while verifying code: $e');
      return VerificationStatus.serverError;
    }
  }

  static Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required int role,
  }) async {
    var url = Uri.parse(_signUpEndpoint);

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        print('User registered successfully');
        return true;
      } else if (response.statusCode == 400) {
        print('400 - 유효성 검사 실패 (이메일 형식 불일치, 필수 필드 누락 등)');
        return false;
      } else if (response.statusCode == 404) {
        print('404 - 사용자 관련 리소스 찾기 실패(예. 등록된 사용자 없음??');
        return false;
      } else if (response.statusCode == 409) {
        print('409 - 이미 존재하는 이메일로 가입 시도');
        return false;
      } else {
        // 500 - 서버 내부 오류
        print('500 - 서버 내류 오류');
        return false;
      }
    } catch (e) {
      print('Error occured while sending data: $e');
      return false;
    }
  }
}
