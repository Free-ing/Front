import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:freeing/screen/setting/forget_password_page.dart';
import '../../common/service/token_storage.dart';
import '../member/login.dart';

class SettingResetPassword extends StatefulWidget {
  SettingResetPassword({super.key});

  @override
  State<SettingResetPassword> createState() => _SettingResetPasswordState();
}

class _SettingResetPasswordState extends State<SettingResetPassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordVerificationController =
      TextEditingController();

  bool validInputs() {
    return (_newPasswordController.text ==
            _newPasswordVerificationController.text) &&
        (_newPasswordController.text.length >= 8 &&
            _newPasswordVerificationController.text.length >= 8 &&
            _currentPasswordController.text.length >= 8);
  }

  void attemptResetPassword() async {
    if (validInputs()) {
      final response = await SettingAPIService().changePassword(
          _currentPasswordController.text, _newPasswordController.text);

      if (response.statusCode == 200) {
        DialogManager.showAlertDialog(
            context: context,
            title: '비밀번호 변경 성공',
            content: '비밀번호가 변경되었습니다.\n\n다시 로그인해주세요.',
            onConfirm: () async {
              final tokenStorage = TokenStorage();
              await tokenStorage.deleteAllTokens();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            });
      }
    } else {
      if (_currentPasswordController.text.length < 8) {
        DialogManager.showAlertDialog(
            context: context,
            title: '비밀번호 변경 실패',
            content: '현재 비밀번호는 8자 이상이여야합니다.');
      } else if (_newPasswordController.text.isEmpty ||
          _newPasswordVerificationController.text.isEmpty) {
        DialogManager.showAlertDialog(
            context: context,
            title: '비밀번호 변경 실패',
            content: '비밀번호와 확인 비밀번호를\n 모두 입력해주세요.');
      } else if (_newPasswordController.text.length < 8 &&
          _newPasswordVerificationController.text.length < 8) {
        DialogManager.showAlertDialog(
            context: context,
            title: '비밀번호 변경 실패',
            content: '비밀번호는 8자 이상이여야 합니다.');
      } else if (_newPasswordController.text !=
          _newPasswordVerificationController.text) {
        DialogManager.showAlertDialog(
            context: context,
            title: '비밀번호 변경 실패',
            content: '비밀번호와 확인 비밀번호가 다릅니다.');
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordVerificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    SizedBox verticalSpace = SizedBox(height: screenHeight * 0.02);

    return SettingLayout(
      title: '비밀번호 변경',
      color: Colors.white,
      isBottom: true,
      imgAddress: 'assets/imgs/background/letter_bottom.png',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrayTextFormFieldWithEye(
              controller: _currentPasswordController,
              labelText: '현재 비밀번호',
              hintText: '현재 비밀번호를 입력해주세요.',
              width: screenWidth * 0.777,
            ),
            verticalSpace,
            GrayTextFormFieldWithEye(
                controller: _newPasswordController,
                labelText: '새 비밀번호',
                hintText: '새 비밀번호를 입력해주세요.',
                width: screenWidth * 0.777),
            verticalSpace,
            GrayTextFormFieldWithEye(
                controller: _newPasswordVerificationController,
                labelText: '새 비밀번호 확인',
                hintText: '비밀번호를 한번 더 입력해주세요.',
                width: screenWidth * 0.777),
            UnderlineTextButton(
              text: '비밀번호를 잊으셨나요?',
              textPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                );
              },
            ),
            verticalSpace,
            Align(
                alignment: Alignment.center,
                child: GreenButton(
                    text: '비밀번호 변경하기',
                    width: screenWidth * 0.62,
                    onPressed: attemptResetPassword)),
          ],
        ),
      ),
    );
  }
}
