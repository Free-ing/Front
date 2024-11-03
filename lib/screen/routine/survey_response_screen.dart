import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/model/exercise/recommended_exercise.dart';
import 'package:freeing/model/hobby/recommend_hobby.dart';
import 'package:freeing/screen/routine/add_recommended_hobby_screen.dart';
import 'package:freeing/screen/setting/setting_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ai_loading_screen.dart';
import 'routine_page.dart';

class SurveyResponseScreen extends StatefulWidget {
  final String category;
  final List<dynamic> recommend;
  final List<String?> answers;
  final int remain;

  const SurveyResponseScreen({
    super.key,
    required this.category,
    required this.recommend,
    required this.answers,
    required this.remain,
  });

  @override
  State<SurveyResponseScreen> createState() => _SurveyResponseScreenState();
}

class _SurveyResponseScreenState extends State<SurveyResponseScreen> {
  String _name = '';
  bool _isAdded = false;
  late List<bool> _isAddedList;
  List<RecommendedHobby> _recommendHobbyList = [];
  List<RecommendedExercise> _recommendExerciseList = [];
  InterstitialAd? _interstitialAd;

  // Todo: 서버 요청 (사용자 이름 받아오기)
  Future<void> _viewUserInfo() async {
    final response = await SettingAPIService().getUserInfo();

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final userData = User.fromJson(json.decode(decodedBody));
      setState(() {
        _name = userData.name;
      });
    } else {
      throw Exception('사용자 정보 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _viewUserInfo();
    _isAddedList = List<bool>.filled(widget.recommend.length, false);
  }

  //Todo: 전면 광고 로드
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        _interstitialAd = ad;
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();

            // 광고가 닫히면 로딩 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AiLoadingScreen(category: '취미를'),
              ),
            );
          },
        );

        /// 광고가 로드되면 표시
        _interstitialAd!.show();
      }, onAdFailedToLoad: (error) {
        _interstitialAd = null;
        // 광고 로드 실패 시 로딩 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiLoadingScreen(category: widget.category),
          ),
        );
      }),
    );
  }

  //Todo: 서버 요청 (취미 AI 재추천)
  Future<List<RecommendedHobby>> _reRecommendHobby() async {
    print('${widget.category} Re Recommend: ${widget.answers}');

    _loadInterstitialAd();

    try {
      final apiService = HobbyAPIService();

      final response = await apiService.recommendHobby(widget.answers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData is Map<String, dynamic>) {
          List<dynamic> recommendList = jsonData['result'];
          _recommendHobbyList.clear();
          for (dynamic data in recommendList) {
            RecommendedHobby hobby = RecommendedHobby.fromJson(data);
            _recommendHobbyList.add(hobby);
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyResponseScreen(
              category: widget.category,
              recommend: _recommendHobbyList,
              answers: widget.answers,
              remain: widget.remain - 1,
            ),
          ),
        );
        return _recommendHobbyList;
      } else if (response.statusCode == 404) {
        return _recommendHobbyList = [];
      } else {
        throw Exception('취미 추천 가져오기 실패 ${response.statusCode}');
      }
    } catch (error) {
      print("응답 실패 $error");
      return _recommendHobbyList = [];
    }
  }

  //Todo: 서버 요청 (운동 ai 재추천)
  Future<List<RecommendedExercise>> _reRecommendExercise() async {
    print('${widget.category} Re Recommend: ${widget.answers}');

    _loadInterstitialAd();

    try {
      final apiService = ExerciseAPIService();

      final response = await apiService.recommendExercise(widget.answers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData is Map<String, dynamic>) {
          List<dynamic> recommendList = jsonData['result'];
          _recommendExerciseList.clear();
          for (dynamic data in recommendList) {
            RecommendedExercise exercise = RecommendedExercise.fromJson(data);
            _recommendExerciseList.add(exercise);
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyResponseScreen(
              category: widget.category,
              recommend: _recommendHobbyList,
              answers: widget.answers,
              remain: widget.remain - 1,
            ),
          ),
        );
        return _recommendExerciseList;
      } else if (response.statusCode == 404) {
        return _recommendExerciseList = [];
      } else {
        throw Exception('운동 루틴 추천 가져오기 실패 ${response.statusCode}');
      }
    } catch (error) {
      print("응답 실패 $error");
      return _recommendExerciseList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
            Row(
              children: [
                SizedBox(width: screenWidth * 0.15),
                Text('남은 기회 (${widget.remain})',
                    style: textTheme.bodySmall?.copyWith(
                      color: widget.remain == 0 ? Colors.red : Colors.black,
                    )),
              ],
            ),
            SizedBox(height: screenHeight * 0.005),
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
            Text(_name,
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
                    onPressed: isAdded
                        ? null
                        : () async {
                            if (!_isAdded) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddRecommendedHobbyScreen(
                                          hobbyName: hobby.hobbyName),
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 2)),
        );
      },
      onGrayPressed: () {
        widget.remain == 0
            ? null
            : widget.category == '취미'
                ? _reRecommendHobby()
                : _reRecommendExercise();
      },
      greenText: '완료',
      grayText: '다시 추천',
    );
  }
}
