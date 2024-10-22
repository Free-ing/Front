import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/model/hobby/recommend_hobby.dart';
import 'package:freeing/screen/routine/add_recommended_hobby_screen.dart';

class SurveyResponseScreen extends StatefulWidget {
  final String category;
  final List<RecommendedHobby> recommend;
  const SurveyResponseScreen({
    super.key,
    required this.category,
    required this.recommend,
  });

  @override
  State<SurveyResponseScreen> createState() => _SurveyResponseScreenState();
}

class _SurveyResponseScreenState extends State<SurveyResponseScreen> {
  bool _isAdded = false;
  late List<bool> _isAddedList;

  void initState(){
    super.initState();
    _isAddedList = List<bool>.filled(widget.recommend.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.072, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenHeight * 0.094),
            _title(
                category: widget.category,
                textTheme: textTheme,
                screenHeight: screenHeight),
            SizedBox(height: screenHeight * 0.06),
            Expanded(
              child: widget.recommend.isEmpty
                  ? Center(child: Text('추천할 ${widget.category}가 없습니다.'))
                  : MediaQuery.removePadding(
                context: context,
                removeTop: true,
                    child: ListView.builder(
                        itemCount: widget.recommend.length,
                        itemBuilder: (context, index) {
                          final hobby = widget.recommend[index];
                          final isAdded = _isAddedList[index];
                          return _buildCard(
                              hobby, textTheme, screenWidth, screenHeight, isAdded, index);
                        }),
                  ),
            ),
            SizedBox(height: screenHeight * 0.04),
            _button(context),
            SizedBox(height: screenHeight * 0.033),
          ],
        ),
      ),
    );
  }

  //Todo: title
  Widget _title(
      {required String category,
      required TextTheme textTheme,
      required double screenHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('조예진',
                style: textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontSize: 26,
                    decoration: TextDecoration.underline)),
            Text('님을 위한',
                style: textTheme.headlineSmall?.copyWith(color: Colors.black))
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Text('추천 $category 리스트에요.',
            style: textTheme.headlineSmall?.copyWith(color: Colors.black)),
        SizedBox(height: screenHeight * 0.01),
        Text('추가 후 언제든지 수정하거나 삭제할 수 있어요')
      ],
    );
  }

  //Todo: 추천 리스트
  Widget _buildCard(
      RecommendedHobby hobby, TextTheme textTheme, double screenWidth, double screenHeight, bool isAdded, int index) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 6,
            margin: EdgeInsets.only(bottom: screenHeight*0.023),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.095,
              ),
              decoration: BoxDecoration(
                color: _isAdded ? BLUE_PURPLE : Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hobby.hobbyName,
                            style: textTheme.titleLarge?.copyWith(
                                color: _isAdded ? Colors.white : Colors.black),
                          ),
                          SizedBox(height: screenHeight*0.01,),
                          Text(
                            hobby.explanation,
                            style: textTheme.bodySmall?.copyWith(
                                color: _isAdded ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (!_isAdded) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecommendedHobbyScreen(hobbyName: hobby.hobbyName),
                          ),
                        );

                        if (result is bool && result == true) {
                          setState(() {
                            _isAddedList[index] = true;
                          });
                        }
                      }
                    },
                    icon: Image.asset(
                        isAdded
                            ? 'assets/icons/ai_minus_button_icon.png'
                            : 'assets/icons/ai_plus_button_icon.png',
                        width: screenWidth * 0.1),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _button(context) {
    return PairedButtons(
      onGreenPressed: () {
        Navigator.of(context).pop();
      },
      onGrayPressed: () {},
      greenText: '완료',
      grayText: '다시 추천',
    );
  }
}
