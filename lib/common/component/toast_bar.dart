import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

class ToastBarWidget extends StatelessWidget {
  final String title;
  final String leadingImagePath;

  const ToastBarWidget({
    Key? key,
    required this.title,
    this.leadingImagePath = "assets/imgs/login/login_fail.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFFBF0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.black, width: 1.0), // ToastCard 내부에 테두리 적용
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ToastCard(
          shadowColor: Colors.transparent,
          title: Text(title, style: TextStyle(fontSize: 15.0),),
          color: const Color(0xFFFFFBF0),
          leading: Image.asset(leadingImagePath),
        ),
      ),
    );
  }

  void showToast(BuildContext context) {
    DelightToastBar(
      builder: (context) => Card(
        color: Color(0xFFFFFBF0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black, width: 1.0), // ToastCard 내부에 테두리 적용
        ),
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ToastCard(
            shadowColor: Colors.transparent,
            title: Text(title, style: const TextStyle(fontSize: 15.0)),
            color: const Color(0xFFFFFBF0),
            leading: Image.asset(leadingImagePath),
          ),
        ),
      ),
      autoDismiss: true,
      snackbarDuration: const Duration(milliseconds: 1000),
    ).show(context);
  }
}
