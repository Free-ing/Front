import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/chart/chart_page.dart';
import 'package:freeing/screen/home_page.dart';
import 'package:freeing/screen/routine/routine_page.dart';
import 'package:freeing/screen/setting_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<Widget> _pages = [
    HomePage(),
    RoutinePage(),
    ChartPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        switch (index) {
          case 0:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _pages[0]));
            break;
          case 1:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _pages[1]));
            break;
          case 2:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _pages[2]));
            break;
          case 3:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _pages[3]));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          screenWidth * 0.06, 0, screenWidth * 0.06, screenHeight * 0.035),
      // padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem('assets/icons/home_icon_white.png',
                'assets/icons/home_icon_black.png', 0),
            _buildNavItem('assets/icons/routine_icon_white.png',
                'assets/icons/routine_icon_black.png', 1),
            _buildNavItem('assets/icons/chart_icon_white.png',
                'assets/icons/chart_icon_black.png', 2),
            _buildNavItem('assets/icons/setting_icon_white.png',
                'assets/icons/setting_icon_black.png', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String unselectedIcon, String selectedIcon, int index) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => {
        _onItemTapped(index),
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: 65,
          height: 45,
        decoration: BoxDecoration(
          color:
              isSelected ? LIGHT_IVORY : Colors.transparent, // 선택 아이콘 배경 색 지정
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? Border.all(color: Colors.black)
              : Border.all(color: Colors.transparent),
        ),
        child: Image.asset(
          isSelected ? selectedIcon : unselectedIcon, // 선택 여부에 따른 아이콘 변경
        ),
      ),
    );
  }
}
