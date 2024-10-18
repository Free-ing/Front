import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class FloatingActionMenu extends StatefulWidget {
  @override
  _FloatingActionMenuState createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // 메뉴 버튼들
        Positioned(
          bottom: 120,
          right: 30,
          child: AnimatedOpacity(
            opacity: isMenuOpen ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Column(
              children: [
                _buildMenuButton(Icons.menu, "Menu 1"),
                SizedBox(height: 10),
                _buildMenuButton(Icons.menu_open, "Menu 2"),
              ],
            ),
          ),
        ),
        // 플로팅 액션 버튼
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: SizedBox(
            width: screenWidth * 0.18,
            height: screenWidth * 0.18,
            child: FloatingActionButton(
              onPressed: _toggleMenu,
              backgroundColor: isMenuOpen ? ORANGE : BLUE_PURPLE,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
              child: AnimatedRotation(
                turns: isMenuOpen ? 0.125 : 0, // 45도 회전
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  'assets/icons/floating_button_icon.png',
                  width: screenWidth * 0.12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, String label) {
    return FloatingActionButton(
      onPressed: () {
        print('$label clicked');
      },
      child: Icon(icon),
    );
  }
}
