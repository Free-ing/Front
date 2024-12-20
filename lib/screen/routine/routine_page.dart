import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freeing/navigationbar/category_tabbar.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/routine/exercise_tabbar_view.dart';
import 'package:freeing/screen/routine/floating_action_menu.dart';
import 'package:freeing/screen/routine/hobby_tabbar_view.dart';
import 'package:freeing/screen/routine/sleep_tabbar_view.dart';
import 'package:freeing/screen/routine/spirit_tabbar_view.dart';

class RoutinePage extends StatefulWidget {
  final int index;

  const RoutinePage({super.key, required this.index});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/imgs/background/background_image_routine_chart.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03),
              child: Text("루틴", style: textTheme.headlineLarge),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
            child: CategoryTabBar(
              index: widget.index,
              exercise: const ExerciseTabBarView(),
              sleep: const SleepTabBarView(),
              hobby: const HobbyTabBarView(),
              spirit: const SpiritTabBarView(),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionMenu(),
          bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
        ),
      ],
    );
  }
}
