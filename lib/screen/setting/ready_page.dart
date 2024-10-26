import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';

class ReadyPage extends StatelessWidget {
  final String appBarTitle;
  const ReadyPage({required this.appBarTitle, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SettingLayout(
      title: appBarTitle,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/imgs/setting/user_img.jpg'),
            Text('준비중.....', style: textTheme.bodyLarge,),
          ],
        ),
      ),
    );
  }
}
