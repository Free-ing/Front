import 'package:flutter/material.dart';
import 'package:freeing/common/service/sign_up_service.dart';
import 'package:freeing/layout/default_layout.dart';
import '../../common/component/buttons.dart';
import '../../common/component/dialog_manager.dart';
import '../../common/component/text_form_fields.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerificationController =
      TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isEmailVerified = false;
  bool _isEmailSent = false;
  bool _isEmailFieldEnabled = true;
  bool _isCodeFieldEnabled = true;
  bool _isTimerVisible = true;

  bool _isValidEmail(String email) {
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void checkEmail() {
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
        DialogManager.showAlertDialog(
            context: context,
            title: '이메일 중복 확인',
            content: '이미 사용중인 이메일입니다.\n다른 이메일을 입력해주세요.');
      } else {
        DialogManager.showConfirmDialog(
          context: context,
          title: '이메일 중복 확인',
          content: '이메일을 사용할 수 있어요.\n이 이메일로 인증하시겠어요?',
          confirmButtonText: '이메일 전송',
          onConfirm: () {
            SignUpService.sendVerificationEmail(_emailController.text)
                .then((success) {
              if (success) {
                setState(() {
                  _isEmailSent = true;
                });
                Navigator.pop(context);
                DialogManager.showAlertDialog(
                  context: context,
                  title: '이메일 인증',
                  content: '이메일로 인증번호를 보내드렸어요!\n인증번호를 입력해주세요.',
                );
              } else {
                DialogManager.showAlertDialog(
                    context: context,
                    title: '이메일 전송 실패',
                    content: '이메일 전송에 실패했습니다.\n다시 시도해주세요.',
                    onConfirm: () {
                      Navigator.of(context).pop();
                    });
              }
            });
          },
        );
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

  bool validateInputs() {
    return _nameController.text.isNotEmpty &&
        (_passwordController.text == _passwordVerificationController.text) &&
        _isEmailVerified &&
        (_passwordController.text.length >= 8);
  }

  void attemptSignUp() {
    if (validateInputs()) {
      SignUpService.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        role: 1,
      ).then((success) {
        if (success) {
          DialogManager.showAlertDialog(
              context: context,
              title: '회원가입 성공',
              content: '축하드립니다! \n\n회원가입에 성공하셨습니다! \n\n로그인해주세요.',
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              });
        } else {
          DialogManager.showAlertDialog(
              context: context,
              title: '회원가입에 실패하셨습니다.',
              content: '회원가입에 실패하셨습니다.\n\n다시 시도해주세요',
              onConfirm: () {
                Navigator.of(context).pop();
              });
        }
      });
    } else {
      if(_nameController.text.isEmpty){
        DialogManager.showAlertDialog(context: context, title: '회원가입 실패', content: '이름을 입력해주세요.');
      } else if(!_isEmailVerified){
        DialogManager.showAlertDialog(context: context, title: '회원가입 실패', content: '이메일 인증을 해주세요.');
      } else if(_passwordController.text.isEmpty || _passwordVerificationController.text.isEmpty){
        DialogManager.showAlertDialog(context: context, title: '회원가입 실패', content: '비밀번호와 확인 비밀번호를\n 모두 입력해주세요.');
      } else if(_passwordController.text.length <8 && _passwordVerificationController.text.length <8){
        DialogManager.showAlertDialog(context: context, title: '회원가입 실패', content: '비밀번호는 8자 이상이여야 합니다.');
      } else if (_passwordController.text != _passwordVerificationController.text){
        DialogManager.showAlertDialog(context: context, title: '회원가입 변경 실패', content: '비밀번호와 확인 비밀번호가 다릅니다.');
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
          '회원가입',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          iconSize: 35.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  GrayTextFormField(
                    controller: _nameController,
                    width: screenWidth * 0.777,
                    labelText: '이름',
                    hintText: '이름을 입력해주세요',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  GrayTextFormFieldWithButton(
                    controller: _emailController,
                    labelText: '이메일',
                    hintText: '이메일을 입력해주세요.',
                    buttonText: '중복 확인',
                    width: screenWidth * 0.777,
                    onButtonPressed: checkEmail,
                    enabled: _isEmailFieldEnabled,
                  ),
                  Visibility(
                    visible: _isEmailSent,
                    child: Column(
                      children: [
                        SizedBox(
                            height: screenHeight * 0.015),
                        GrayTextFormFieldWihTimerButton(
                          controller: _codeController,
                          onButtonPressed: verifyCode,
                          enabled: _isCodeFieldEnabled,
                          isVisible: _isTimerVisible,
                          width: screenWidth * 0.777,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  GrayTextFormFieldWithEye(
                    controller: _passwordController,
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해주세요.',
                    width: screenWidth * 0.777,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  GrayTextFormFieldWithEye(
                    controller: _passwordVerificationController,
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 한번 더 입력해주세요.',
                    width: screenWidth * 0.777,
                  ),
                  SizedBox(height: screenHeight * 0.035),
                  GreenButton(
                    text: '가입 하기',
                    width: screenWidth * 0.62,
                    onPressed: attemptSignUp,
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            "assets/imgs/login/login_bottom.png",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            "assets/imgs/login/login_top.png",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
