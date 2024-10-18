import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/service/login_service.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:freeing/layout/default_layout.dart';
import 'package:freeing/screen/member/reset_password.dart';
import 'package:freeing/screen/member/sign_up.dart';
import 'package:page_transition/page_transition.dart';

import '../../common/component/buttons.dart';
import '../home/home.dart';

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
      DelightToastBar(
        builder: (context) => const ToastCard(
          title: Text('프론트 - 이메일 형식이 잘못되었습니다.'),
        ),
      ).show(context);
      return;
    }

    if (password.length < 8) {
      DelightToastBar(
        builder: (context) => const ToastCard(
          title: Text('프론트 - 비밀번호는 8자 이상이어야 합니다.'),
        ),
      ).show(context);
      return;
    }

    final response = await _loginService.login(email, password);

    if (response.statusCode == 200) {
      print('성공!!!!!!!!!!!!!!!!!!!!!!1');
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];
      final refreshToken = responseData['refreshToken'];

      final tokenStorage = TokenStorage();
      await tokenStorage.saveTokens(accessToken, refreshToken);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else if (response.statusCode == 400) {
      // 이메일 형식 틀림, 비밀번호 안적음
      DelightToastBar(
        builder: (context) => const ToastCard(
          title: Text('이메일 형식이 틀리거나 비밀번호를 입력하지 않았습니다.'),
        ),
      ).show(context);
    } else if (response.statusCode == 401) {
      // 틀린 비밀번호
      DelightToastBar(
        builder: (context) => const ToastCard(
          title: Text('틀린 비밀번호입니다.'),
        ),
      ).show(context);
    } else {
      // statusCode == 404 해당 이메일 없음
      DelightToastBar(
        builder: (context) => const ToastCard(
          title: Text('해당 이메일이 존재하지 않습니다.'),
        ),
      ).show(context);
    }
  }

  void _test() {
    DelightToastBar(
      builder: (context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ToastCard(
          title: const Text('테스트'),
          color: const Color(0xFFFFFBF0),
          leading: Image.asset("assets/imgs/login/login_fail.png"),
        ),
      ),
      autoDismiss: true,
      snackbarDuration: Duration(milliseconds: 1000),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Image.asset(
                "assets/imgs/login/login_top.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.57,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 1),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        const Text(
                          '스트레스로부터',
                          style: TextStyle(
                              fontFamily: 'scdream',
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                        const Row(
                          children: [
                            Text(
                              'Freeing',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '할 준비 되셨나요?',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        const Text(
                          '나를 위한 힐링을 시작해보세요.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        GrayTextFormField(
                          controller: _emailController,
                          labelText: '이메일',
                          hintText: '이메일을 입력해주세요',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        GrayTextFormFieldWithEye(
                          controller: _passwordController,
                          labelText: '비밀번호',
                          hintText: '비밀번호를 입력해주세요.',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.040),
                        GreenButton(
                          width: 260,
                          onPressed: _test,
                        ),
                        SizedBox(
                          width: 270,
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
                                      fontWeight: FontWeight.w300),
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
                                        fontWeight: FontWeight.w300),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/imgs/login/login_bottom.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
