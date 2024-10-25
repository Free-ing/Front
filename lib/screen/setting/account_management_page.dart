import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';

class AccountManagementPage extends StatelessWidget {
  const AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingLayout(child: Text('계정 관리'), appBar: AppBar());
  }
}
