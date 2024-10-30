import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:freeing/screen/member/login.dart';
import 'package:freeing/screen/setting/ready_page.dart';
import 'package:freeing/screen/setting/setting_reset_password.dart';
import 'package:page_transition/page_transition.dart';

import '../../common/service/setting_api_service.dart';

class User {
  final String email;
  final String name;
  final int userId;

  User({required this.email, required this.name, required this.userId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      userId: json['userId'],
    );
  }
}

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  String _email = '';
  String _name = '';

  // Todo: 서버 요청
  Future<void> _viewUserInfo() async {
    final response = await SettingAPIService().getUserInfo();

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final userData = User.fromJson(json.decode(decodedBody));
      setState(() {
        _email = userData.email;
        _name = userData.name;
      });
    } else {
      throw Exception('사용자 정보 가져오기 실패 ${response.statusCode}');
    }
  }

  // Todo: 로그아웃
  void logout(BuildContext context) async {
    final tokenStorage = TokenStorage();
    await tokenStorage.deleteAllTokens();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route)=> false,);
  }

  @override
  initState(){
    super.initState();
    _viewUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SettingLayout(
      title: '계정 관리',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이름', style: textTheme.bodyMedium),
                  Text('$_name', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이메일', style: textTheme.bodyMedium),
                  Text('$_email', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('비밀번호', style: textTheme.bodyMedium),
                  SizedBox(
                    width: screenWidth * 0.43,
                    height: screenHeight * 0.03,
                    child: TextButton(
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
                            child: SettingResetPassword(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(width: 1, color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.white,
                      ),
                      child: Text('비밀번호 변경', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              width: screenWidth,
              child: Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
            ),
            SettingTextButton(
                address: 'assets/icons/setting_data_reset.png',
                text: '데이터 초기화',
                targetPage: ReadyPage(appBarTitle: '데이터 초기화',)),
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              width: screenWidth,
              child: Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
            ),
            SettingTextButton(
                address: 'assets/icons/setting_terms_of_use.png',
                text: '서비스 이용약관',
                targetPage: ReadyPage(appBarTitle: '서비스 이용약관',),),
            SettingTextButton(
                address: 'assets/icons/setting_privacy_policy.png',
                text: '개인 정보 처리 방침',
                targetPage: ReadyPage(appBarTitle: '개인 정보 처리 방침',)),
            SettingTextButton(
                address: 'assets/icons/setting_version_info.png',
                text: '버전 정보',
                targetPage: ReadyPage(appBarTitle: '버전 정보',)),
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              width: screenWidth,
              child: Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
            ),
            SettingTextButton(
                address: 'assets/icons/setting_logout.png',
                text: '로그아웃',
                isModal: true,
                modalTitle: '로그아웃',
                modalContent: '로그아웃을 하시겠습니까?',
                modalOnConfirm: (){logout(context);},),
            SettingTextButton(
                address: 'assets/icons/setting_withdraw.png',
                text: '회원 탈퇴',
                targetPage: ReadyPage(appBarTitle: '회원 탈퇴',)),
          ],
        ),
      ),
    );
  }
}

