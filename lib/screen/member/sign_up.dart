import 'package:flutter/material.dart';
import 'package:freeing/layout/default_layout.dart';
import 'package:page_transition/page_transition.dart';

import '../../common/component/buttons.dart';
import '../../common/component/text_form_fields.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _grayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          iconSize: 35.0,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   PageTransition(
            //     type: PageTransitionType.topToBottom,
            //     alignment: Alignment.topCenter,
            //     curve: Curves.bounceOut,
            //     duration: Duration(milliseconds: 900),
            //     child: Login(),
            //   ),
            // );
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.463,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  GrayTextFormField(
                    controller: _grayController,
                    width: 320,
                    labelText: '이름',
                    hintText: '이름을 입력해주세요',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  GrayTextFormFieldWithButton(
                    labelText: '이메일',
                    hintText: '이메일을 입력해주세요.',
                    buttonText: '중복 확인',
                    width: 320,
                    onButtonPressed: () {},
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  GrayTextFormFieldWithEye(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해주세요.',
                    width: 320,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  GrayTextFormFieldWithEye(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 한번 더 입력해주세요.',
                    width: 320,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  GreenButton(
                    text: '가입 하기',
                    width: 260,
                    onPressed: () => print('버튼 눌림'),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/imgs/background/signup.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
