import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/chart/chart_page.dart';
import 'package:freeing/screen/routine/add_routine_screen.dart';
import 'package:freeing/screen/routine/select_recommend_category.dart';

class FloatingActionMenu extends StatefulWidget {
  @override
  _FloatingActionMenuState createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _controller;
  late Animation<Offset> _menu1Animation;
  late Animation<Offset> _menu2Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // 각각의 메뉴에 대한 애니메이션을 위쪽으로 설정 (y축 기준으로 위로 올라가게 함)
    _menu1Animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _menu2Animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // AnimatedContainer(
        //   duration: Duration(milliseconds: 300),
        //   height: isMenuOpen ? screenHeight * 0.22 : 0, // 충분한 공간을 미리 확보
        //   child: SingleChildScrollView(
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         Opacity(
        //           opacity: isMenuOpen ? 1.0 : 0.0,
        //           child: _buildMenuButton(
        //             context: context,
        //             label: "AI에게 추천받기",
        //             onPressed: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (BuildContext context) =>
        //                       SelectRecommendCategory()));
        //             },
        //           ),
        //         ),
        //         SizedBox(height: screenHeight * 0.01),
        //         Opacity(
        //           opacity: isMenuOpen ? 1.0 : 0.0,
        //           child: _buildMenuButton(
        //             context: context,
        //             label: "직접 추가하기",
        //             onPressed: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (BuildContext context) =>
        //                       AddRoutineScreen()));
        //             },
        //           ),
        //         ),
        //         SizedBox(height: screenHeight * 0.01),
        //       ],
        //     ),
        //   ),
        // ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: screenHeight * 0.168,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SlideTransition(
                position: _menu1Animation,
                child: AnimatedOpacity(
                  opacity: isMenuOpen ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: _buildMenuButton(
                    context: context,
                    label: "AI에게 추천받기",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SelectRecommendCategory(),
                      ));
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SlideTransition(
                position: _menu2Animation,
                child: AnimatedOpacity(
                  opacity: isMenuOpen ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: _buildMenuButton(
                    context: context,
                    label: "직접 추가하기",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddRoutineScreen(),
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        //Todo: 플로팅 액션 버튼
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

  Widget _buildMenuButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(screenWidth * 0.38, 0),
          padding: EdgeInsets.all(screenWidth * 0.03),
          backgroundColor: Colors.white,
          foregroundColor: ORANGE,
          textStyle: textTheme.titleSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: Colors.black),
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
