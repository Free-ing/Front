import 'package:flutter/material.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/layout/default_layout.dart';
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
  final TextEditingController _grayController = TextEditingController();
  final TextEditingController _yellowController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GreenButton(width: 260, onPressed: () => print('버튼 눌림')),
            // PairedButtons(
            //   onGreenPressed: () => print('확인 눌림'),
            //   onGrayPressed: () => print('취소 눌림'),
            // ),
            // GrayTextFormField(
            //   controller: _grayController,
            //   labelText: '이메일',
            //   hintText: '이메일을 입력해주세요',
            //   // validator: (value){
            //   //   if(value == null || value.isEmpty){
            //   //     return '이메일을 입력해주세요';
            //   //   }
            //   //   return null;
            //   // },
            //   keyboardType: TextInputType.text,
            // ),
            // SizedBox(height: 30,),
            // YellowTextFormField(
            //   controller: _yellowController,
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Image.asset(
                'assets/imgs/login_top.png',
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
                        Text(
                          '스트레스로부터',
                          style: TextStyle(
                              fontFamily: 'scdream',
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                        Row(
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
                        Text(
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
                        Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        GrayTextFormField(
                          //controller: _grayController,
                          labelText: '이메일',
                          hintText: '이메일을 입력해주세요',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        GrayTextFormFieldWithEye(
                          //controller: _grayController,
                          labelText: '비밀번호',
                          hintText: '비밀번호를 입력해주세요.',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.040),
                        GreenButton(
                            width: 260, onPressed: () => print('버튼 눌림')),
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
                                      duration: Duration(milliseconds: 900),
                                      reverseDuration: Duration(milliseconds: 900),
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
                                        duration: Duration(milliseconds: 900),
                                        reverseDuration: Duration(milliseconds: 900),
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
                'assets/imgs/login_bottom.png',
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
