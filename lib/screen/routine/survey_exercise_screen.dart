import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/survey_buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/layout/survey_layout.dart';
import 'package:freeing/model/exercise/recommended_exercise.dart';
import 'package:freeing/screen/routine/ai_loading_screen.dart';
import 'package:freeing/screen/routine/survey_response_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SurveyExerciseScreen extends StatefulWidget {
  const SurveyExerciseScreen({super.key});

  @override
  State<SurveyExerciseScreen> createState() => _SurveyExerciseScreenState();
}

class _SurveyExerciseScreenState extends State<SurveyExerciseScreen> {
  int? selectedIndex;
  List<String?> answers = List.filled(4, null);
  List<int?> selectedIndices = List.filled(4, null);
  int currentQuestionIndex = 0;

  final PageController _pageController = PageController();
  final int _totalPages = 5; // 총 페이지 수
  double _progress = 1 / (5 - 1); // 초기 진행 상태

  List<RecommendedExercise> _recommendList = [];
  InterstitialAd? _interstitialAd;

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
                builder: (context) => const AiLoadingScreen(category: '운동'),
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
            builder: (context) => const AiLoadingScreen(category: '운동'),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _progress = (_pageController.page! + 1) / (_totalPages - 1);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //Todo: 서버 요청 (ai 운동 추천)
  Future<List<RecommendedExercise>> _submitAnswers() async {
    print('Submitting Answers: ${answers}');

    _loadInterstitialAd();

    try {
      final apiService = ExerciseAPIService();

      final response = await apiService.recommendExercise(answers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData is Map<String, dynamic>) {
          List<dynamic> recommendList = jsonData['result'];
          _recommendList.clear();
          for (dynamic data in recommendList) {
            RecommendedExercise exercise = RecommendedExercise.fromJson(data);
            _recommendList.add(exercise);
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyResponseScreen(
              category: '운동',
              recommend: _recommendList,
              answers: answers,
              remain: 2,
            ),
          ),
        );
        return _recommendList;
      }
      else if (response.statusCode == 404) {
        return _recommendList = [];
      }
      else {
        throw Exception('운동 루틴 추천 가져오기 실패 ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('응답 실패 $error');
      return _recommendList = [];
    }
  }

  //Todo: 다음 질문
  void _nextQuestion(String answer, int index) {
    setState(() {
      answers[index] = answer; // 현재 질문에 대한 답변 저장
      selectedIndices[index] = selectedIndex;
      selectedIndex = null;
    });

    // 페이지 전환
    if (index < answers.length - 1) {
      _pageController.animateToPage(
        index + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _submitAnswers(); // 마지막 질문 후 제출
    }
  }

  //Todo: 이전 질문
  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex -= 1;
        selectedIndex = selectedIndices[currentQuestionIndex];
      });

      _pageController.animateToPage(
        currentQuestionIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  //Todo: 뒤로가기 버튼
  void _greyPressed() {
    if (currentQuestionIndex == 0) {
      Navigator.of(context).pop();
    } else {
      _previousQuestion();
    }
  }

  //Todo: 선택된 버튼 인덱스 업데이트
  void handleButtonSelected(int index) {
    setState(() {
      selectedIndex = index; // 선택된 버튼의 인덱스를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> questions = [
      _buildFavorExercise(textTheme, screenWidth, screenHeight),
      _buildTimeZone(textTheme, screenWidth, screenHeight),
      _buildPlace(textTheme, screenWidth, screenHeight),
      _buildGoal(textTheme, screenWidth, screenHeight),
    ];

    return SurveyLayout(
      title: PreferredSize(
        preferredSize: const Size(double.infinity, 4.0),
        child: Container(
          width: screenWidth * 0.51,
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: BASIC_GREY,
            valueColor: const AlwaysStoppedAnimation<Color>(ORANGE),
          ),
        ),
      ),
      body: Expanded(
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            currentQuestionIndex = index;
            return questions[index];
          },
        ),
      ),
      onIconPressed: _greyPressed,
    );
  }

  //Todo: 1. 어떤 종류의 운동을 선호 하시나요?
  Widget _buildFavorExercise(textTheme, screenWidth, screenHeight) {
    final labels = ['유산소', '근력', '유연성', '균형', '고강도 인터벌', '코어'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text('어떤 종류의 운동을 선호하세요?', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.04),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.076,
                mainAxisSpacing: screenWidth * 0.076,
                children: List.generate(labels.length, (index) {
                  final imageUrls = [
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/aerobic.png',
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/muscle.png',
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/flexiblility.png',
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/balance.png',
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/interval.png',
                    'https://freeingimage.s3.ap-northeast-2.amazonaws.com/core.png',
                  ];

                  return SquareSurveyButton(
                    imageUrl: imageUrls[index],
                    label: labels[index],
                    onSelected: () => handleButtonSelected(index),
                    isSelected: selectedIndex == index,
                  );
                }),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        _pageControlButton(labels: labels),
        SizedBox(height: screenHeight * 0.04),
      ],
    );
  }

//Todo: 2. 어떤 시간대 에 운동 하세요?
  Widget _buildTimeZone(textTheme, screenWidth, screenHeight) {
    final labels = ['아침', '점심', '저녁'];
    final imageUrls = [
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/morning.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/afternoon.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/night.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text(
          '주로 어떤 시간대 에 운동 하세요?\n',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                labels.length,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    child: RectangleSurveyButton(
                      imageUrl: imageUrls[index],
                      label: labels[index],
                      onSelected: () => handleButtonSelected(index),
                      isSelected: selectedIndex == index,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        _pageControlButton(labels: labels),
        SizedBox(height: screenHeight * 0.053),
      ],
    );
  }

//Todo: 3. 선호 하는 운동 장소는 어디 인가요?
  Widget _buildPlace(textTheme, screenWidth, screenHeight) {
    final labels = ['실내', '야외'];
    final imageUrls = [
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/inside.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/outside.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text('선호 하는 운동 장소는 어디 인가요?', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.15),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: labels.length,
                crossAxisSpacing: screenWidth * 0.076,
                mainAxisSpacing: screenWidth * 0.076,
                children: List.generate(
                  labels.length,
                  (index) {
                    return SquareSurveyButton(
                      imageUrl: imageUrls[index],
                      label: labels[index],
                      onSelected: () => handleButtonSelected(index),
                      isSelected: selectedIndex == index,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        _pageControlButton(labels: labels),
        SizedBox(height: screenHeight * 0.053),
      ],
    );
  }

//Todo: 4. 주로 어떤 목적으로 운동하세요?
  Widget _buildGoal(textTheme, screenWidth, screenHeight) {
    final labels = ['체력 증진', '재활', '다이어트'];
    final imageUrls = [
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/stamina.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/rehabilitation.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/diet.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text(
          '주로 어떤 시간대 에 운동 하세요?\n',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                labels.length,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    child: RectangleSurveyButton(
                      imageUrl: imageUrls[index],
                      label: labels[index],
                      onSelected: () => handleButtonSelected(index),
                      isSelected: selectedIndex == index,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        _pageControlButton(labels: labels),
        SizedBox(height: screenHeight * 0.053),
      ],
    );
  }

//Todo: page control button
  Widget _pageControlButton({required List labels}) {
    return PairedButtons(
      greenText: currentQuestionIndex == answers.length - 1 ? '추천받기' : '다음',
      onGreenPressed: () {
        if (selectedIndex != null) {
          if (currentQuestionIndex == answers.length - 1) {
            answers[currentQuestionIndex] = labels[selectedIndex!]; // 마지막 답변 저장
            _submitAnswers(); // 서버로 답변 전송
          } else {
            _nextQuestion(labels[selectedIndex!], currentQuestionIndex);
          }
        }
      },
      onGrayPressed: () {
        _greyPressed();
      },
    );
  }
}
