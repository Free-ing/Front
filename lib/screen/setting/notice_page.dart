import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingLayout(child: Text('띠요오옹'), appBar: AppBar());
  }
}
