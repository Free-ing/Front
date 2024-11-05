import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class LoginService {
  static const String _baseUrl = 'http://freeing-apigateway-service-893483672.ap-northeast-2.elb.amazonaws.com:8000';
  static const String _loginEndpoint = '$_baseUrl/user-service/login';

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_loginEndpoint),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: json.encode(<String, String>{
        'email' : email,
        'password' : password,
      }),
    );
    return response;
  }

}