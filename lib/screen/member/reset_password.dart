import 'package:flutter/material.dart';
import 'package:freeing/common/component/text_form_fields.dart';

import '../../common/component/buttons.dart';
import '../../layout/default_layout.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isTransmissionSuccessful = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        title: Text(
          '비밀번호 변경',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left),
          iconSize: 35.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          GrayTextFormFieldWithButton(
            buttonText: '인증번호 전송',
            width: 320,
            onButtonPressed: () {
              // 인증번호가 성공적으로 전송되었다는 모달창 띄우고
              // GrayTextFormFieldWithTimerButton 뜨도록 해야함!!
              setState(() {
                isTransmissionSuccessful = true;
              });
            },
          ),
          Visibility(
            visible: isTransmissionSuccessful,
            child:
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
          Visibility(
            visible: isTransmissionSuccessful,
            child: GrayTextFormFieldWihTimerButton(
              onButtonPressed: () {},
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          GrayTextFormFieldWithEye(
            labelText: '새 비밀번호',
            hintText: '새로운 비밀번호를 입력해주세요.',
            width: 320,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          GrayTextFormFieldWithEye(
            labelText: '새 비밀번호 확인',
            hintText: '비밀번호를 한번 더 입력해주세요.',
            width: 320,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          GreenButton(
            onPressed: () => print('버튼 눌림'),
            width: 260,
            text: '변경하기',
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0),

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
