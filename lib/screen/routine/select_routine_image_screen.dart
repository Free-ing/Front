import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/navigationbar/category_tabbar.dart';

class SelectRoutineImageScreen extends StatefulWidget {
  final String selectImage;

  const SelectRoutineImageScreen({
    super.key, required this.selectImage,
  });

  @override
  State<SelectRoutineImageScreen> createState() =>
      _SelectRoutineImageScreenState();
}

class _SelectRoutineImageScreenState extends State<SelectRoutineImageScreen> {
  late String _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.selectImage;
  }

  void _changeImage(String newImage) {
    setState((){
      _currentImage = newImage;
    });
  }

  // 운동 이미지 리스트
  final List<String> exerciseImage = [
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_exercise.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/walking.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/running.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/muscle.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/aerobic.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/core.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/balance.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/diet.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/stamina.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/rehabilitation.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/static_stretching.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/dynamic_stretching.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/flexiblility.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/inside.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/outside.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/interval.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/morning.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/afternoon.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/night.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/exercise_report.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/bicycle.png',

  ];

  // 수면 이미지 리스트
  final List<String> sleepImage = [
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/water.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/bag.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/coffee.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/phone.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/%EC%88%98%EB%A9%B4.png',
  ];

  // 취미 이미지 리스트
  final List<String> hobbyImage = [
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/physical_activity.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/reading.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_hobby.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/stroll.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/watching_tv.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/alone.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/group.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/art.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/guitar.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/balloon.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/games.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/cook.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/leisure_activity.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/creative.png',
  ];

  // 마음채우기 이미지 리스트
  final List<String> mindImage = [
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/emotional_diary.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/leaf_and_music.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/meditaiton_routine.png',
    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/yoga.png',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: "루틴 이미지 선택",
      body: Column(
        children: [
          _viewSelectImage(screenWidth), // 선택한 이미지 보기
          SizedBox(height: screenHeight * 0.03),
          _viewCategoryImage(screenWidth, screenHeight),
          SizedBox(
            width: screenWidth * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      width: 1,
                    ),
                  )),
              onPressed: () {
                Navigator.pop(context, _currentImage);
              },
              child: Text('완료', style: textTheme.titleLarge),
            ),
          ),
          SizedBox(height: screenHeight*0.028,)
        ],
      ),
    );
  }

  //Todo: 선택한 이미지 조회
  Widget _viewSelectImage(screenWidth){
    return Align(
      alignment: Alignment.center,
      child: Card(
        elevation: 6,
        shadowColor: YELLOW_SHADOW,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        margin: EdgeInsets.all(12),
        child: Container(
          width: screenWidth * 0.38,
          height: screenWidth * 0.38,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Image.network(_currentImage),
        ),
      ),
    );
  }

  //Todo: 카테고리별 이미지 조회
  Widget _viewCategoryImage(screenWidth, screenHeight){
    return Expanded(
      child: CategoryTabBar(
        index: 0,
        exercise: _buildImage(
          category: exerciseImage,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          // selectImage: widget.selectImage,
        ),
        sleep: _buildImage(
          category: sleepImage,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          // selectImage: widget.selectImage,
        ),
        hobby: _buildImage(
          category: hobbyImage,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          // selectImage: widget.selectImage,
        ),
        spirit: _buildImage(
          category: mindImage,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          //selectImage: widget.selectImage,
        ),
      ),
    );
  }

  //Todo: 이미지 빌드
  Widget _buildImage({
    required List<String> category,
   // required String selectImage,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenWidth * 0.03,
      ),
      itemCount: category.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _changeImage(category[index]);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            child: Image.network(
              category[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      },
    );
  }
}
