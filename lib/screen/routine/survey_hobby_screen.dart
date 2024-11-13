import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/survey_buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/layout/survey_layout.dart';
import 'package:freeing/model/hobby/recommend_hobby.dart';
import 'package:freeing/screen/routine/ai_loading_screen.dart';
import 'package:freeing/screen/routine/survey_response_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SurveyHobbyScreen extends StatefulWidget {
  const SurveyHobbyScreen({super.key});

  @override
  State<SurveyHobbyScreen> createState() => _SurveyHobbyScreenState();
}

class _SurveyHobbyScreenState extends State<SurveyHobbyScreen> {
  int? selectedIndex;
  List<String?> answers = List.filled(7, null);
  List<int?> selectedIndices = List.filled(7, null);
  int currentQuestionIndex = 0;

  final PageController _pageController = PageController();
  final int _totalPages = 8; // 총 페이지 수
  double _progress = 1 / (8 - 1); // 초기 진행 상태

  List<RecommendedHobby> _recommendList = [];
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
                builder: (context) => AiLoadingScreen(category: '취미'),
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
            builder: (context) => AiLoadingScreen(category: '취미'),
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

  //Todo: 서버 요청 (ai 취미 추천)
  Future<List<RecommendedHobby>> _submitAnswers() async {
    print('Submitting Answers: ${answers}');

    _loadInterstitialAd();

    try {
      final apiService = HobbyAPIService();

      final response = await apiService.recommendHobby(answers);

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
              answers: answers,
              remain: 2,
            ),
          ),
        );
        return _recommendList;
      } else if (response.statusCode == 404) {
        return _recommendList = [];
      } else {
        throw Exception('취미 추천 가져오기 실패 ${response.statusCode}');
      }

      /// 서버 응답 후 답변 화면으로 이동
    } catch (error) {
      print("응답 실패 $error");
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
        duration: Duration(milliseconds: 300),
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
        duration: Duration(milliseconds: 300),
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
      _buildUsualSpareTime(textTheme, screenWidth, screenHeight),
      _buildMostHelpful(textTheme, screenWidth, screenHeight),
      _buildAloneTogether(textTheme, screenWidth, screenHeight),
      _buildInsideOutside(textTheme, screenWidth, screenHeight),
      _buildEnergy(textTheme, screenWidth, screenHeight),
      _buildNewThings(textTheme, screenWidth, screenHeight),
      _buildBudget(textTheme, screenWidth, screenHeight),
    ];

    return SurveyLayout(
      title: PreferredSize(
        preferredSize: Size(double.infinity, 4.0),
        child: Container(
          width: screenWidth * 0.51,
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: BASIC_GREY,
            valueColor: AlwaysStoppedAnimation<Color>(ORANGE),
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

  //Todo: 1. 평소에 여가시간을 어떻게 보내나요?
  Widget _buildUsualSpareTime(textTheme, screenWidth, screenHeight) {
    final labels = ['독서하기', '영상 시청', '산책', '레저', '혼자만의 시간', '모임']; // 라벨 목록

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text('평소에 여가시간을 어떻게 보내나요?', style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.04),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.076,
                mainAxisSpacing: screenWidth * 0.076,
                children: List.generate(
                  labels.length,
                  (index) {
                    final imageUrls = [
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/reading.png',
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/watching_tv.png',
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/stroll.png',
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/leisure_activity.png',
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/alone.png',
                      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/group.png'
                    ]; // 이미지 파일 경로

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

  //Todo: 2. 어떤 활동이 스트레스를 줄이는 데 가장 도움이 된다고 느끼나요?
  Widget _buildMostHelpful(textTheme, screenWidth, screenHeight) {
    final labels = ['신체활동', '창의적인 작업', '감각적 즐거움 (음악/예술)']; // 라벨 목록
    final imageUrls = [
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/physical_activity.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/watching_tv.png',
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/stroll.png',
    ]; // 이미지 파일 경로

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text(
          '어떤 활동이 스트레스를 줄이는 데\n가장 도움이 된다고 느끼나요?',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        // SizedBox(height: screenHeight * 0.08),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
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
                      ));
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

  //Todo: 3. 혼자하는 취미, 함께하는 취미
  Widget _buildAloneTogether(textTheme, screenWidth, screenHeight) {
    return _circleButtons(
      text: '혼자 하는 취미와 함께 하는 취미 중\n어느 쪽을 선호하나요?',
      label: ['혼자하기', '상관 없음', '함께하기'],
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }

  //Todo: 4. 실내 활동, 야외 활동
  Widget _buildInsideOutside(textTheme, screenWidth, screenHeight) {
    return _circleButtons(
        text: '실내 활동과 야외 활동 중\n어느 쪽이 끌리나요?',
        label: ['실내 활동', '상관 없음', '야외 활동'],
        textTheme: textTheme,
        screenWidth: screenWidth,
        screenHeight: screenHeight);
  }

  //Todo: 5. 에너지
  Widget _buildEnergy(textTheme, screenWidth, screenHeight) {
    return _circleButtons(
        text: '스트레스 받을 때\n무기력해지나요 격양되나요?',
        label: ['무기력함', '매번 다름', '격양됨'],
        textTheme: textTheme,
        screenWidth: screenWidth,
        screenHeight: screenHeight);
  }

  //Todo: 6. 새로운 것 배우기
  Widget _buildNewThings(textTheme, screenWidth, screenHeight) {
    return _circleButtons(
      text: '새로운 것을 배우거나 시도하는 것에\n대해 어떻게 생각하시나요?',
      label: [' 싫어함 ', '상관 없음', ' 좋아함 '],
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }

  //Todo: 7. 예산
  Widget _buildBudget(textTheme, screenWidth, screenHeight) {
    final labels = ['~1만원', '1만원~5만원', '5만원~10만원', '비용 상관 없음'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text(
          '취미 활동에 한 번에 투자할 수 있는\n예산은 어느 정도 인가요?',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        //SizedBox(height: screenHeight * 0.08),
        Expanded(
          child: SizedBox(
            width: screenWidth,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                4,
                (index) {
                  return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                      child: OnlyTextButton(
                        label: labels[index],
                        onSelected: () => handleButtonSelected(index),
                        isSelected: selectedIndex == index,
                      ));
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

  //Todo: circle buttons
  Widget _circleButtons(
      {required String text,
      required List label,
      required TextTheme textTheme,
      required double screenWidth,
      required double screenHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text(
          text,
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.15),
        Expanded(
          child: SizedBox(
            width: screenWidth,
            child: Center(
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  3,
                  (index) {
                    final labels = label;
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                        child: CircleSurveyButton(
                          label: labels[index],
                          onSelected: () => handleButtonSelected(index),
                          isSelected: selectedIndex == index,
                        ));
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        _pageControlButton(labels: label),
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
            // 마지막 질문이면 답변을 제출
            answers[currentQuestionIndex] = labels[selectedIndex!]; // 마지막 답변 저장
            _submitAnswers(); // 서버로 답변 전송
          } else {
            // 마지막 질문이 아니면 다음 질문으로 넘어가기
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
