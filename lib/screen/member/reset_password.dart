import 'package:flutter/material.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/service/reset_password_service.dart';

import '../../common/component/buttons.dart';
import '../../common/component/dialog_manager.dart';
import '../../common/service/sign_up_service.dart';
import '../../layout/default_layout.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerificationController =
      TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isEmailVerified = false;
  bool _isTransmissionSuccessful = false;
  bool _isEmailFieldEnabled = true;
  bool _isCodeFieldEnabled = true;
  bool _isTimerVisible = true;

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void sendEmail() {
    final email = _emailController.text;

    if (!_isValidEmail(email)) {
      DialogManager.showAlertDialog(
        context: context,
        title: '이메일 형식 오류',
        content: '올바른 이메일 형식이 아닙니다.\n다시 입력해주세요.',
      );
      return;
    }

    SignUpService.checkEmail(_emailController.text).then((success) {
      if (success) {
        // 회원가입 된 이메일
        DialogManager.showAlertDialog(
          context: context,
          title: '이메일 인증',
          content: '이메일로 인증번호를 보내드렸어요!\n인증번호를 입력해주세요.',
          onConfirm: () {
            setState(() {
              _isTransmissionSuccessful = true;
            });
          },
        );
        SignUpService.sendVerificationEmail(_emailController.text);
      } else {
        // 회원 가입 안된 이메일 -> 회원가입 하시오
        DialogManager.showAlertDialog(
            context: context,
            title: '이메일 전송 실패',
            content: '가입된 이메일이 아닙니다.\n회원가입을 먼저 진행해주세요.',
            onConfirm: () {
              Navigator.of(context).pop();
            });
      }
    });
  }

  void verifyCode() {
    SignUpService.verifyCode(_emailController.text, _codeController.text)
        .then((status) {
      switch (status) {
        case VerificationStatus.success:
          DialogManager.showAlertDialog(
              context: context, title: '인증 성공', content: '인증 성공했습니다.');
          setState(() {
            _isTimerVisible = false;
            _isEmailFieldEnabled = false;
            _isCodeFieldEnabled = false;
            _isEmailVerified = true;
          });

          break;
        case VerificationStatus.codeNotFound:
          DialogManager.showAlertDialog(
              context: context, title: '인증 실패', content: '인증 기록이 존재하지 않습니다.');
          break;
        case VerificationStatus.codeExpired:
          DialogManager.showAlertDialog(
              context: context,
              title: '인증 코드 만료',
              content: '인증 코드가 만료되었습니다. 새 인증 코드를 요청해주세요.');
          break;
        case VerificationStatus.invalidCode:
          DialogManager.showAlertDialog(
            context: context,
            title: '인증 실패',
            content: '입력한 인증 코드가 올바르지 않습니다.',
          );
          break;
        case VerificationStatus.serverError:
          DialogManager.showAlertDialog(
            context: context,
            title: '서버 오류',
            content: '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
          );
          break;
      }
    });
  }

  bool validInputs() {
    return (_passwordController.text == _passwordVerificationController.text) &&
        _isEmailVerified &&
        (_passwordController.text.length >= 8);
  }

  void attemptResetPassword() {
    if (validInputs()) {
      ResetPasswordService.changePassword(
              _emailController.text, _passwordController.text)
          .then((success) {
        if (success) {
          DialogManager.showAlertDialog(
              context: context,
              title: '비밀번호 변경 성공',
              content: '비밀번호가 변경되었습니다.\n\n다시 로그인해주세요.',
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              });
        }
      });
    } else {
      if(!_isEmailVerified){
        DialogManager.showAlertDialog(context: context, title: '비밀번호 변경 실패', content: '이메일 인증을 해주세요.');
      } else if(_passwordController.text.isEmpty || _passwordVerificationController.text.isEmpty){
        DialogManager.showAlertDialog(context: context, title: '비밀번호 변경 실패', content: '비밀번호와 확인 비밀번호를\n 모두 입력해주세요.');
      } else if(_passwordController.text.length <8 && _passwordVerificationController.text.length <8){
        DialogManager.showAlertDialog(context: context, title: '비밀번호 변경 실패', content: '비밀번호는 8자 이상이여야 합니다.');
      } else if (_passwordController.text != _passwordVerificationController.text){
        DialogManager.showAlertDialog(context: context, title: '비밀번호 변경 실패', content: '비밀번호와 확인 비밀번호가 다릅니다.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            GrayTextFormFieldWithButton(
              enabled: _isEmailFieldEnabled,
              controller: _emailController,
              buttonText: '인증번호 전송',
              width: screenWidth * 0.777,
              onButtonPressed: sendEmail,
            ),
            Visibility(
              visible: _isTransmissionSuccessful,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.015),
                  GrayTextFormFieldWihTimerButton(
                    width: screenWidth * 0.777,
                    controller: _codeController,
                    onButtonPressed: verifyCode,
                    enabled: _isCodeFieldEnabled,
                    isVisible: _isTimerVisible,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            GrayTextFormFieldWithEye(
              controller: _passwordController,
              labelText: '새 비밀번호',
              hintText: '새로운 비밀번호를 입력해주세요.',
              width: screenWidth * 0.777,
            ),
            SizedBox(height: screenHeight * 0.02),
            GrayTextFormFieldWithEye(
              controller: _passwordVerificationController,
              labelText: '새 비밀번호 확인',
              hintText: '비밀번호를 한번 더 입력해주세요.',
              width: screenWidth * 0.777,
            ),
            SizedBox(height: screenHeight * 0.03),
            GreenButton(
              onPressed: attemptResetPassword,
              width: screenWidth * 0.62,
              text: '변경하기',
            ),
            SizedBox(height: screenHeight * 0.13),
            Image.asset(
              "assets/imgs/login/login_bottom.png",
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              "assets/imgs/login/login_top.png",
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
