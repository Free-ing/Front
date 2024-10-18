import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class CategoryTabBar extends StatefulWidget {
  final Widget exercise;
  final Widget sleep;
  final Widget hobby;
  final Widget spirit;

  const CategoryTabBar(
      {super.key,
      required this.exercise,
      required this.sleep,
      required this.hobby,
      required this.spirit});

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            physics: NeverScrollableScrollPhysics(),
            backgroundColor: BLUE_PURPLE,
            unselectedBackgroundColor: LIGHT_GREY,
            buttonMargin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            contentPadding:
                EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            radius: 15,
            height: screenHeight * 0.045,
            borderWidth: 1,
            unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
            labelStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
            tabs: [
              Tab(text: "운동"),
              Tab(text: "수면"),
              Tab(text: "취미"),
              Tab(text: "마음채우기"),
            ],
          ),
          SizedBox(height: screenHeight*0.02),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                widget.exercise,
                widget.sleep,
                widget.hobby,
                widget.spirit,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
