import 'package:flutter/material.dart';
import 'package:freeing/common/component/survey_buttons.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/screen/routine/survey_exercise_screen.dart';
import 'package:freeing/screen/routine/survey_hobby_screen.dart';

class SelectRecommendCategory extends StatelessWidget {
  const SelectRecommendCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.1),
          Text('안녕하세요!',
              style: textTheme.headlineSmall?.copyWith(color: Colors.black)),
          Text('어떤 종류의 루틴을 추천해드릴까요?',
              style: textTheme.headlineSmall?.copyWith(color: Colors.black)),
          SizedBox(height: screenHeight * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectCategoryButton(
                imageUrl:
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_exercise.png',
                label: "운동",
                onSelected: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SurveyExerciseScreen(),
                    ),
                  );
                },
              ),
              SelectCategoryButton(
                imageUrl:
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_hobby.png',
                label: "취미",
                onSelected: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SurveyHobbyScreen(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
