import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/service/login_service.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:freeing/layout/default_layout.dart';
import 'package:freeing/screen/home/home_page.dart';
import 'package:freeing/screen/member/reset_password.dart';
import 'package:freeing/screen/member/sign_up.dart';
import 'package:page_transition/page_transition.dart';

import '../../common/component/buttons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // 이메일 형식 검증을 위한 정규식
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(email)) {
      const ToastBarWidget(
        title: '이메일 형식이 잘못되었습니다.',
      ).showToast(context);
      return;
    }
    // 비밀번호 8자리 이상인지 검사
    if (password.length < 8) {
      const ToastBarWidget(
        title: '비밀번호는 8자 이상이어야 합니다.',
      ).showToast(context);
      return;
    }

    final response = await _loginService.login(email, password);

    if (response.statusCode == 200) {
      print('성공!!!!!!!!!!!!!!!!!!!!!!1');
      final responseData = json.decode(response.body);

      if (responseData.containsKey('accessToken') && responseData.containsKey('refreshToken')){
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];
        final tokenStorage = TokenStorage();
        try{
          await tokenStorage.saveTokens(accessToken, refreshToken);
          print('토큰 저장 성공!!!');
        }catch(e){
          print('토큰 저장 실패: $e');
        }
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else if (response.statusCode == 400) {
      const ToastBarWidget(
        title: '이메일 형식이 틀리거나 비밀번호를 입력하지 않았습니다.',
      ).showToast(context);
    } else if (response.statusCode == 401) {
      const ToastBarWidget(
        title: '틀린 비밀번호입니다.',
      ).showToast(context);
    } else {
      const ToastBarWidget(
        title: '해당 이메일이 존재하지 않습니다.',
      ).showToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
          'assets/imgs/login/login_top.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 1),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        '스트레스로부터',
                        style: TextStyle(
                          fontFamily: 'scdream',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'Freeing ',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '할 준비 되셨나요?',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      const Text(
                        '나를 위한 힐링을 시작해보세요.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045),
                      const Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.023),
                      GrayTextFormField(
                        controller: _emailController,
                        labelText: '이메일',
                        hintText: '이메일을 입력해주세요',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.016),
                      GrayTextFormFieldWithEye(
                        controller: _passwordController,
                        labelText: '비밀번호',
                        hintText: '비밀번호를 입력해주세요.',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045),
                      GreenButton(
                        width: MediaQuery.of(context).size.height * 0.33,
                        onPressed: _login,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.34,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.topToBottom,
                                    alignment: Alignment.topCenter,
                                    curve: Curves.bounceOut,
                                    duration: Duration(milliseconds: 300),
                                    reverseDuration:
                                        Duration(milliseconds: 300),
                                    child: SignUp(),
                                  ),
                                );
                              },
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.topToBottom,
                                    alignment: Alignment.topCenter,
                                    curve: Curves.bounceOut,
                                    duration: Duration(milliseconds: 300),
                                    reverseDuration:
                                        Duration(milliseconds: 300),
                                    child: ResetPassword(),
                                  ),
                                );
                              },
                              child: const Text(
                                '비밀번호를 잊으셨나요?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.023),
            child: Image.asset(
              "assets/imgs/login/login_bottom.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
