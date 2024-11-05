import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final bool? showIconButton;
  final VoidCallback? onDeletePressed;
  final Color? color;

  const ScreenLayout({
    super.key,
    required this.title,
    required this.body,
    this.showIconButton,
    this.onDeletePressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: color ?? Colors.white,
      appBar: AppBar(
        backgroundColor: color ?? Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Stack(
            alignment: Alignment.center, // Stack의 중앙에 텍스트를 고정
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                  )),
              Text(title, style: textTheme.headlineLarge),
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: showIconButton ?? false,
                  child: IconButton(
                    onPressed: () {
                      DialogManager.showConfirmDialog(
                        context: context,
                        title: '루틴 삭제',
                        content: '삭제된 루틴은 복구할 수 없고,'
                            '\n루틴과 관련된 모든 기록도 함께 삭제됩니다.'
                            '\n삭제하시겠습니까?',
                        onConfirm: onDeletePressed ?? () {},
                      );
                    },
                    icon: Icon(Icons.delete_forever_outlined),
                    iconSize: 35.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
        child: body,
      ),
    );
  }
}
