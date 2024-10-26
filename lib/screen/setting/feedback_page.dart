import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingLayout(
      title: '문의/버그 신고',
      child: Text('띠요오옹'),
    );
  }
}
