import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class LoginService {
  static const String _baseUrl = BaseUrl.baseUrl;
  static const String _loginEndpoint = '$_baseUrl:8000/user-service/login';

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