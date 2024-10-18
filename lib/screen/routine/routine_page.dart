import 'package:flutter/material.dart';
import 'package:freeing/common/component/hobby_card.dart';
import 'package:freeing/common/component/toggled_routine_card.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/navigationbar/category_tabbar.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/routine/floating_action_menu.dart';
import 'package:freeing/screen/routine/hobby_tabbar_view.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

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
         // floatingActionButton: FloatingActionMenu(),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenHeight*0.02),
            child: CategoryTabBar(
              exercise: _buildExerciseTabBarView(),
              sleep: _buildSleepTabBarView(),
              hobby: HobbyTabBarView(),
              spirit: _buildSpiritTabBarView(),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1),
        ),
      ],
    );
  }

  // Widget _buildExerciseTabBarView() {
  //   bool isToggled = false;
  //
  //   return
  // }

  Widget _buildSleepTabBarView() {
    return Center(
      child: Icon(Icons.nightlight_round),
    );
  }

  // Widget _buildHobbyTabBarView() {
  //   return Center(
  //     child: Icon(Icons.palette),
  //   );
  // }

  Widget _buildSpiritTabBarView() {
    return Center(child: Icon(Icons.self_improvement));
  }

  /// FloatingActionButton
  Widget _buildFloatingActionButton(screenWidth) {return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: SizedBox(
        width: screenWidth * 0.18,
        height: screenWidth * 0.18,
        child: FloatingActionButton.large(
          onPressed: () {
          },
          backgroundColor: BLUE_PURPLE,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(
            'assets/icons/floating_button_icon.png',
            width: screenWidth * 0.12,
          ),
        ),
      ),
    );
  }
}

class _buildExerciseTabBarView extends StatefulWidget {
  const _buildExerciseTabBarView({super.key});

  @override
  State<_buildExerciseTabBarView> createState() =>
      _buildExerciseTabBarViewState();
}

//Todo: 운동 TabBarView(임시)
class _buildExerciseTabBarViewState extends State<_buildExerciseTabBarView> {
  //bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 3,
      itemBuilder: (context, index) {
        return ToggledRoutineCard(imageUrl: 'assets/imgs/exercise/running.png', title: '달리기', description: '루틴에 대한 설명');
      },
    );
  }
}
