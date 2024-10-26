import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';

class QuestionMark extends StatelessWidget {
  final String title;
  final String content;
  final String? subContent;
  final TextAlign? textAlign;

  const QuestionMark(
      {super.key, required this.title, required this.content, this.subContent, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DialogManager.showAlertDialog(
          context: context,
          title: title,
          content: content,
          subContent: subContent,
          textAlign: textAlign,
        );
      },
      icon: Image.asset(
        "assets/icons/question_icon.png",
        width: 30,
      ),
    );
  }
}
