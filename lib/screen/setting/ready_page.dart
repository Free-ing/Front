import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';

class ReadyPage extends StatelessWidget {
  const ReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingLayout(
      title: '준비중',
      child: Column(
        children: [
          Image.asset('assets/imgs/setting/user_img'),
          Text('준비중입니다.....'),
        ],
      ),
    );
  }
}
