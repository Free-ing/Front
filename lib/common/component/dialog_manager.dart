import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class DialogManager {
  /// 확인 버튼만 있는 Dialog
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? subContent,
    TextAlign? textAlign,
    VoidCallback? onConfirm,
    String buttonText = '확인',
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: _buildDialogShape(),
          backgroundColor: Colors.white,
          title: _buildDialogTitle(title, context),
          content: _buildAlertDialogContent(context, content, subContent ?? '',
              textAlign ?? TextAlign.center, buttonText, onConfirm),
        );
      },
    );
  }

  /// 취소, 확인 버튼 있는 Dialog
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmButtonText = '확인',
    String cancelButtonText = '취소',
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: _buildDialogShape(),
          backgroundColor: Colors.white,
          title: _buildDialogTitle(title, context),
          content: _buildDialogCancelConfirmContent(
              context, content, onConfirm, cancelButtonText, confirmButtonText),
        );
      },
    );
  }

  ///이미지 있는 Dialog
  static Future<void> showImageDialog({
    required BuildContext context,
    required String userName,
    required String topic,
    required String image,
    required VoidCallback onConfirm,
    String confirmButtonText = '확인',
    String cancelButtonText = '취소',
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: _buildDialogShape(),
          backgroundColor: Colors.white,
          content: _buildDialogImageContent(context, userName, topic, image,
              onConfirm, cancelButtonText, confirmButtonText),
        );
      },
    );
  }

  // Dialog shape
  static RoundedRectangleBorder _buildDialogShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.black),
    );
  }

  // Dialog Title
  static Widget _buildDialogTitle(String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5E9),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      width: 260.0,
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // 확인 버튼만 있는 Content
  static Widget _buildAlertDialogContent(
    BuildContext context,
    String content,
    String subContent,
    TextAlign textAlign,
    String buttonText,
    VoidCallback? onConfirm,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: textAlign,
        ),
        const SizedBox(height: 12),
        subContent != ''
            ? Text(
                subContent,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: textAlign,
              )
            : const SizedBox(height: 0),
        subContent != ''
            ? const SizedBox(height: 12)
            : const SizedBox(height: 0),
        _buildDialogButton(
          buttonWidth: 180,
          context: context,
          text: buttonText,
          color: PRIMARY_COLOR,
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) {
              onConfirm();
            }
          },
        )
      ],
    );
  }

  // 확인, 취소 버튼 있는 Content
  static Widget _buildDialogCancelConfirmContent(
    BuildContext context,
    String content,
    VoidCallback onConfirm,
    String cancelButtonText,
    String confirmButtonText,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _buildDialogButtons(
            context, onConfirm, cancelButtonText, confirmButtonText),
      ],
    );
  }

  // 이미지 있는 Content
  static Widget _buildDialogImageContent(
    BuildContext context,
    String userName,
    String topic,
    String image,
    VoidCallback onConfirm,
    String cancelButtonText,
    String confirmButtonText,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //const SizedBox(height: 12),
        Row(
          children: [
            _buildCustomText(context, userName, topic),
            SizedBox(width: screenWidth*0.19, height: screenHeight * 0.118, child: Image.asset(image)),
          ],
        ),
        _buildDialogButtons(
            context, onConfirm, cancelButtonText, confirmButtonText),
      ],
    );
  }

  static Widget _buildCustomText(
    BuildContext context,
    String userName,
    String topic,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$userName", // 사용자 이름
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600, // 다른 weight 적용
                ),
          ),
          TextSpan(
            text: "님을 위한\n${topic}가 있어요.\n광고 시청 후 확인해 보시겠어요?",
            style: Theme.of(context).textTheme.bodySmall, // 기본 스타일
          ),
        ],
      ),
    );
  }

  // 버튼 2개 Buttons
  static Widget _buildDialogButtons(
      BuildContext context,
      VoidCallback onConfirm,
      String cancelButtonText,
      String confirmButtonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDialogButton(
          buttonWidth: 100.0,
          context: context,
          text: cancelButtonText,
          color: LIGHT_GREY,
          onPressed: () {
            Navigator.of(context).pop(); // 취소 버튼
          },
        ),
        const SizedBox(width: 30.0),
        _buildDialogButton(
          buttonWidth: 100.0,
          context: context,
          text: confirmButtonText,
          color: PRIMARY_COLOR,
          onPressed: onConfirm,
        ),
      ],
    );
  }

  static Widget _buildDialogButton({
    required double buttonWidth,
    required BuildContext context,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          backgroundColor: color,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          iconColor: Colors.white,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
