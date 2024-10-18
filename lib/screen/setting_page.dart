import 'package:flutter/material.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('설정 페이지'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
