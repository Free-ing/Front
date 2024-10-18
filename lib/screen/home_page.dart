import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                _buildCancelConfirmButton(context, textTheme),
                _buildAlertmButton(context, textTheme),
                _buildAlertReportImageButton(context, textTheme),
                _buildAlertLetterImageButton(context, textTheme)
              ],
            ),
          ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
    );
  }

  Widget _buildCancelConfirmButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () {
        DialogManager.showConfirmDialog(
          context: context,
          title: ("회원 탈퇴"),
          content: "정말 회원탈퇴를 하시겠어요?\n기록된 정보는 모두 삭제됩니다.",
          onConfirm: () {},
        );
        //_showAlertDialog(context, textTheme);
      },
      child: Text(
        '취소, 확인 버튼 모달창',
        style: textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildAlertmButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () {
        DialogManager.showAlertDialog(
            context: context, title: "정적 스트레칭", content: "내용");
      },
      child: Text(
        '확인 버튼만 있는  모달창',
        style: textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildAlertReportImageButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () {
        DialogManager.showImageDialog(
          context: context,
          userName: "문승주",
          topic: "운동 리포트",
          image: Image.asset("assets/imgs/etc/report_mascot.png",
              fit: BoxFit.contain),
          onConfirm: () {},
          confirmButtonText: "확인하기"
        );
      },
      child: Text(
        "리포트 모달창",
        style: textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildAlertLetterImageButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: () {
        DialogManager.showImageDialog(
          context: context,
          userName: "문승주",
          topic: "편지",
          image: Image.asset("assets/imgs/etc/letter_mascot.png",
              fit: BoxFit.contain),
          onConfirm: () {},
          confirmButtonText: "확인하기"
        );
      },
      child: Text(
        "편지 모달창",
        style: textTheme.headlineLarge,
      ),
    );
}}
