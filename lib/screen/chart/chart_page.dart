import 'package:flutter/material.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/chart/ai_letter.dart';
import 'package:freeing/screen/chart/exercise_report_screen.dart';

import 'package:freeing/screen/chart/hobby_gallery_screen.dart';
import 'package:freeing/screen/chart/mood_calendar_screen.dart';
import 'package:freeing/layout/select_week_layout.dart';
import 'package:freeing/screen/chart/sleep_report_screen.dart';
import 'package:freeing/screen/routine/survey_response_screen.dart';

import '../../model/hobby/recommend_hobby.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 예시로 추천 리스트를 생성
    List<RecommendedHobby> recommendedHobbies = [
      RecommendedHobby(hobbyName: '취미', explanation: '에 대한 설명'),
      RecommendedHobby(hobbyName: '설명', explanation: '에 대한 취미'),
      RecommendedHobby(hobbyName: '취미', explanation: '에 대한 설명'),
      RecommendedHobby(hobbyName: '설명', explanation: '에 대한 취미'),
    ];

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
            //centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, top: screenHeight * 0.03),
              child: Text("나의 기록 돌아보기", style: textTheme.headlineLarge),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: GridView.count(
              //crossAxisSpacing: screenWidth*0.03,
              //mainAxisSpacing: screenWidth*0.03,
              crossAxisCount: 2,
              childAspectRatio: screenWidth * 0.38 / 180,
              children: [
                _chartCard(
                  imageUrl: 'assets/imgs/chart/routine_tracker.png',
                  title: "월간\n루틴 트래커",
                  navigatePage: SurveyResponseScreen(
                      category: '취미',
                      recommend: recommendedHobbies,
                      answers: [],
                      remain: 0),
                  context: context,
                ),
                _chartCard(
                  imageUrl: 'assets/imgs/chart/sleep_report.png',
                  title: "수면 리포트\n몰아보기",
                  navigatePage: SleepReportScreen(),
                  context: context,
                ),
                _chartCard(
                  imageUrl: 'assets/imgs/chart/hobby_gallery.png',
                  title: "취미 사진첩",
                  navigatePage: HobbyGalleryScreen(),
                  context: context,
                ),
                _chartCard(
                  imageUrl: 'assets/imgs/chart/emotional_diary_and_letter.png',
                  title: "무드 캘린더",
                  navigatePage: MoodCalendar(),
                  context: context,
                ),
                _chartCard(
                  imageUrl: 'assets/imgs/chart/exercise_report.png',
                  title: "운동 리포트\n몰아보기",
                  navigatePage: ExerciseReportScreen(),
                  context: context,
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
        ),
      ],
    );
  }

  Widget _chartCard(
      {required String imageUrl,
      required String title,
      required Widget navigatePage,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => navigatePage));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Stack(
            children: [
              _routineImage(imageUrl: imageUrl),
              _routineTitle(context: context, title: title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        width: 130,
        height: 130,
      ),
    );
  }

  Widget _routineTitle({required BuildContext context, required String title}) {
    return Positioned(
      top: 25,
      left: 10,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
