import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/model/hobby/recommend_hobby.dart';
import 'package:freeing/screen/routine/add_recommended_hobby_screen.dart';

import 'ai_loading_screen.dart';

class SurveyResponseScreen extends StatefulWidget {
  final String category;
  final List<RecommendedHobby> recommend;
  final List<String?> answers;

  const SurveyResponseScreen({
    super.key,
    required this.category,
    required this.recommend,
    required this.answers,
  });

  @override
  State<SurveyResponseScreen> createState() => _SurveyResponseScreenState();
}

class _SurveyResponseScreenState extends State<SurveyResponseScreen> {
  bool _isAdded = false;
  late List<bool> _isAddedList;
  List<RecommendedHobby> _recommendList = [];

  @override
  void initState() {
    super.initState();
    _isAddedList = List<bool>.filled(widget.recommend.length, false);
  }

  //Todo: 서버 요청 (ai 재추천)
  Future<List<RecommendedHobby>> _reRecommend() async {
    print('Re Recommend: ${widget.answers}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiLoadingScreen(
          category: '취미를',
        ),
      ),
    );

    try {
      final apiService = HobbyAPIService();

      final response = await apiService.recommendHobby(widget.answers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData is Map<String, dynamic>) {
          List<dynamic> recommendList = jsonData['result'];
          _recommendList.clear();
          for (dynamic data in recommendList) {
            RecommendedHobby hobby = RecommendedHobby.fromJson(data);
            _recommendList.add(hobby);
          }
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SurveyResponseScreen(
                    category: '취미',
                    recommend: _recommendList,
                    answers: widget.answers)));
        return _recommendList;
      } else if (response.statusCode == 404) {
        return _recommendList = [];
      } else {
        throw Exception('취미 추천 가져오기 실패 ${response.statusCode}');
      }
    } catch (error) {
      print("응답 실패 $error");
      return _recommendList = [];
    }
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
                            return _buildCard(hobby, textTheme, screenWidth,
                                screenHeight, isAdded, index);
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
  Widget _buildCard(RecommendedHobby hobby, TextTheme textTheme,
      double screenWidth, double screenHeight, bool isAdded, int index) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 6,
            margin: EdgeInsets.only(bottom: screenHeight * 0.023),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.095,
              ),
              decoration: BoxDecoration(
                color: isAdded ? BLUE_PURPLE : Colors.white,
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
                                color: isAdded ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            hobby.explanation,
                            style: textTheme.bodySmall?.copyWith(
                                color: isAdded ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    enableFeedback: _isAdded ? false : true,
                    onPressed: () async {
                      if (_isAdded == false) {
                        if (!_isAdded) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecommendedHobbyScreen(
                                  hobbyName: hobby.hobbyName),
                            ),
                          );

                          if (result is bool && result == true) {
                            setState(() {
                              _isAddedList[index] = true;
                            });
                          }
                        }
                      } else {
                        null;
                      }
                    },
                    icon: Image.asset(
                        isAdded
                            ? 'assets/icons/ai_minus_button_icon.png'
                            : 'assets/icons/ai_plus_button_icon.png',
                        width: screenWidth * 0.1),
                  ),
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
      onGrayPressed: _reRecommend,
      greenText: '완료',
      grayText: '다시 추천',
    );
  }
}
