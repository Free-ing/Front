import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/model/home/stress_level_response.dart';
import 'package:freeing/screen/home/home_page.dart';
import 'package:freeing/screen/home/stress_survey_loading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../common/component/buttons.dart';
import '../../common/component/loading.dart';
import '../../common/component/toast_bar.dart';
import '../../common/const/colors.dart';
import '../../common/service/ad_mob_service.dart';
import '../../common/service/home_api_service.dart';
import '../chart/stress_result_screen.dart';

class AdStressSurveyPage extends StatefulWidget {
  final StressLevelResponse? stressLevelResponse;

  const AdStressSurveyPage({super.key, this.stressLevelResponse});

  @override
  State<AdStressSurveyPage> createState() => _AdStressSurveyPageState();
}

class _AdStressSurveyPageState extends State<AdStressSurveyPage> {
  final homeApiService = HomeApiService();
  final List<int?> _selectedOptions = List<int?>.filled(11, null);

  final List<Map<String, dynamic>> questions = [
    {"questionNumber": 1, "questionText": '스트레스를 많이 받는다.'},
    {"questionNumber": 2, "questionText": '변화에 적응하기 어렵다.'},
    {"questionNumber": 3, "questionText": '문제가 생기면 직접 처리할 자신이 없다.'},
    {"questionNumber": 4, "questionText": '머리가 아프다.'},
    {"questionNumber": 5, "questionText": '어지럽다.'},
    {"questionNumber": 6, "questionText": '소화가 안된다.'},
    {"questionNumber": 7, "questionText": '가슴이 답답하다.'},
    {"questionNumber": 8, "questionText": '불안하고 초조하다.'},
    {"questionNumber": 9, "questionText": '쉽게 화가 난다.'},
    {"questionNumber": 10, "questionText": '쉽게 짜증이 난다.'},
    {"questionNumber": 11, "questionText": '뭘 자꾸 먹게 된다.'},
  ];

  final List<int> options = [0, 1, 2, 3];
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void dispose() {
    // dispose가 호출될 때 플래그 업데이트
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final stressLevelResponse = widget.stressLevelResponse;

    if (_isLoading) {
      return const StressSurveyLoading();
    }

    return ScreenLayout(
        color: Colors.white,
        title: '스트레스 검사',
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildSurveyIntroContainer(screenWidth, screenHeight, textTheme),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              _buildQuestions(screenWidth, screenHeight, textTheme),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              GreenButton(
                text: '측정 하기',
                width: screenWidth * 0.6,
                onPressed: () {
                  _submitSurvey(stressLevelResponse);
                },
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
            ],
          ),
        ));
  }

  Widget _buildSurveyIntroContainer(
      double screenWidth, double screenHeight, TextTheme textTheme) {
    return Container(
      width: screenWidth,
      //height: screenHeight * 0.45,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Freeing과 함께 스트레스를 점검하세요!스트레스는 우리 삶의 균형에 큰 영향을 미칩니다. Freeing에서는 국립정신건강센터(National Center for Mental Health)와 대한신경정신의학회(Korean Neuropsychiatric Association)가 한국인의 정서와 생활 방식을 반영해 개발한 \'한국인 스트레스 척도(National Stress Scale)\'를 제공합니다. 이 검사는 한국인에게 특화된 과학적 평가 도구로, 기존의 해외 검사와 차별화된 신뢰성을 자랑합니다. 지금, Freeing과 함께 더 건강한 삶을 시작해 보세요!\n\n최근 2주간 각 문항에 해당하는 증상을 얼마나 자주 경험하였는지 확인하고 해당하는 번호에 체크하기 바랍니다.',
                style: textTheme.bodyMedium,
              ),
              Text('(0: 없음, 1: 2일 이상, 2: 1주일 이상, 3: 거의 2주)',
                  style: textTheme.bodySmall)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestions(
      double screenWidth, double screenHeight, TextTheme textTheme) {
    return Column(
      children: questions.map((question) {
        int index = question['questionNumber'] - 1;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: BLUE_PURPLE,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                            child: Text(
                              question['questionNumber'].toString(),
                              style: textTheme.titleSmall
                                  ?.copyWith(color: Colors.white),
                            ))),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Text(
                      question['questionText'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                _buildRadioOptions(options, index),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRadioOptions(List<int> options, int questionIndex) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      children: List<Widget>.generate(options.length, (index) {
        return _buildRadioOption(index, options[index], questionIndex);
      }),
    );
  }

  Widget _buildRadioOption(int value, int label, int questionIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _selectedOptions[questionIndex],
          activeColor: PRIMARY_COLOR,
          onChanged: (int? newValue) {
            setState(() {
              _selectedOptions[questionIndex] = newValue!;
            });
          },
        ),
        Text(label.toString()),
      ],
    );
  }

  Future<void> _submitSurvey(StressLevelResponse? stressLevelResponse) async {
    // 모든 질문에 응답했는지 확인
    if (_selectedOptions.contains(null)) {
      setState(() {
        _isLoading = false;
      });
      if (!_isDisposed) {
        const ToastBarWidget(
          title: '모든 질문에 답변해 주세요.',
        ).showToast(context);
      }
      return;
    }

    // 서버로 전송할 데이터 구성
    List<Map<String, int>> questionResponses = [];
    for (int i = 0; i < questions.length; i++) {
      questionResponses.add({
        "questionNumber": questions[i]['questionNumber'] as int,
        "answer": _selectedOptions[i]!,
      });
    }

    // 광고 로드 및 표시 함수 호출
    _loadInterstitialAd(questionResponses);
  }

  void _loadInterstitialAd(List<Map<String, int>> questionResponses) {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) async {
              ad.dispose();

              // 광고가 닫힌 후 서버 요청 실행
              await _handleServerRequest(questionResponses);
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          // 광고 로드 실패 시 서버 요청 실행
          _handleAdFailedToLoad(questionResponses);
        },
      ),
    );
  }

  Future<void> _handleServerRequest(List<Map<String, int>> questionResponses) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 서버 요청 실행
      final response = await homeApiService.testStress(questionResponses);
      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final surveyId = responseBody['surveyId'];
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => StressResultScreen(
                surveyId: surveyId,
                replacementScreen: HomePage(),
              ),
            ),
          );
        }
      } else if (response.statusCode == 400 &&
          response.body.contains("이미 오늘의 피드백이 생성되었습니다. 새로운 피드백은 내일 생성할 수 있습니다.")) {
        if (!_isDisposed) {
          const ToastBarWidget(
            title: '스트레스 검사는 하루에\n한번만 가능합니다.',
          ).showToast(context);
        }
      }
    } catch (e) {
      if (!_isDisposed) {
        // 예외 처리
        const ToastBarWidget(
          title: '서버 요청 중 오류가 발생했습니다.',
        ).showToast(context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _handleAdFailedToLoad(List<Map<String, int>> questionResponses) async {
    // 광고 로드 실패 시 서버 요청 실행
    await _handleServerRequest(questionResponses);
  }







// Future<void> _submitSurvey(StressLevelResponse? stressLevelResponse) async {
  //   InterstitialAd? _interstitialAd;
  //
  //   // 모든 질문에 응답했는지 확인
  //   if (_selectedOptions.contains(null)) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (!_isDisposed) {
  //       const ToastBarWidget(
  //         title: '모든 질문에 답변해 주세요.',
  //       ).showToast(context);
  //     }
  //     return;
  //   }
  //
  //   // 서버로 전송할 데이터 구성
  //   List<Map<String, int>> questionResponses = [];
  //   for (int i = 0; i < questions.length; i++) {
  //     questionResponses.add({
  //       "questionNumber": questions[i]['questionNumber'] as int,
  //       "answer": _selectedOptions[i]!,
  //     });
  //   }
  //
  //   // 광고 로드 및 표시
  //
  //
  //
  //   // 광고 로드 및 표시
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _loadInterstitialAd();
  // }



// 설문조사 값 서버에 전송
  // Future<void> _submitSurvey(StressLevelResponse? stressLevelResponse) async {
  //   InterstitialAd? _interstitialAd;
  //   // 모든 질문에 응답했는지 확인
  //   if (_selectedOptions.contains(null)) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (!_isDisposed) {
  //       const ToastBarWidget(
  //         title: '모든 질문에 답변해 주세요.',
  //       ).showToast(context);
  //     }
  //     return;
  //   }
  //
  //   // 서버로 전송할 데이터 구성
  //   List<Map<String, int>> questionResponses = [];
  //   for (int i = 0; i < questions.length; i++) {
  //     questionResponses.add({
  //       "questionNumber": questions[i]['questionNumber'] as int,
  //       "answer": _selectedOptions[i]!,
  //     });
  //   }
  //
  //   // void _loadInterstitialAd() {
  //   //   InterstitialAd.load(
  //   //     adUnitId: AdMobService.interstitialAdUnitId!,
  //   //     request: const AdRequest(),
  //   //     adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
  //   //       _interstitialAd = ad;
  //   //       _interstitialAd!.fullScreenContentCallback =
  //   //           FullScreenContentCallback(
  //   //             onAdDismissedFullScreenContent: (ad) {
  //   //               ad.dispose();
  //   //
  //   //               // 광고가 닫히면 로딩 화면으로 이동
  //   //               Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => const StressSurveyLoading(),
  //   //                 ),
  //   //               );
  //   //             },
  //   //           );
  //   //
  //   //       /// 광고가 로드되면 표시
  //   //       _interstitialAd!.show();
  //   //     }, onAdFailedToLoad: (error) {
  //   //       _interstitialAd = null;
  //   //       // 광고 로드 실패 시 로딩 화면으로 이동
  //   //       Navigator.push(
  //   //         context,
  //   //         MaterialPageRoute(
  //   //           builder: (context) => const StressSurveyLoading(),
  //   //         ),
  //   //       );
  //   //     }),
  //   //   );
  //   // }
  //
  //   void _loadInterstitialAd() {
  //     InterstitialAd.load(
  //       adUnitId: AdMobService.interstitialAdUnitId!,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (ad) {
  //           _interstitialAd = ad;
  //           _interstitialAd!.fullScreenContentCallback =
  //               FullScreenContentCallback(
  //                 onAdDismissedFullScreenContent: (ad) async {
  //                   ad.dispose();
  //
  //                   // 광고가 닫히면 서버 요청 실행
  //                   try {
  //                     // 서버 요청 실행
  //                     final response = await homeApiService.testStress(questionResponses);
  //                     if (response.statusCode == 201) {
  //                       final responseBody = jsonDecode(response.body); // JSON 디코딩
  //                       final surveyId = responseBody['surveyId'];
  //                       if (mounted) {
  //                         Navigator.of(context).pushReplacement(
  //                           MaterialPageRoute(
  //                             builder: (context) => StressResultScreen(
  //                               surveyId: surveyId,
  //                               replacementScreen: HomePage(),
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                     } else if (response.statusCode == 400 &&
  //                         response.body.contains("이미 오늘의 피드백이 생성되었습니다. 새로운 피드백은 내일 생성할 수 있습니다.")) {
  //                       if (!_isDisposed) {
  //                         const ToastBarWidget(
  //                           title: '스트레스 검사는 하루에\n한번만 가능합니다.',
  //                         ).showToast(context);
  //                       }
  //                     }
  //                   } catch (e) {
  //                     if (!_isDisposed) {
  //                       //print('설문조사 전송 실패: $e');
  //                     }
  //                   } finally {
  //                     setState(() {
  //                       _isLoading = false;
  //                     });
  //                   }
  //                 },
  //               );
  //
  //           // 광고 표시
  //           _interstitialAd!.show();
  //         },
  //         onAdFailedToLoad: (error) {
  //           _interstitialAd = null;
  //
  //           // 광고 로드 실패 시 로딩 화면으로 이동
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const StressSurveyLoading(),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  //
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _loadInterstitialAd();
  //
  //
  //   // try {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   // 서버에 POST 요청 보내기 (예제에서 testStress 함수를 호출하는 방식으로 가정)
  //   //   final response = await homeApiService.testStress(questionResponses);
  //   //   //print('상태 코드 출려어어어ㅓㄱ ${response.statusCode}');
  //   //   if (response.statusCode == 201) {
  //   //     final responseBody = jsonDecode(response.body); // JSON 디코딩
  //   //     final surveyId = responseBody['surveyId'];
  //   //     if (mounted) {
  //   //       Navigator.of(context)
  //   //           .pushReplacement(
  //   //         MaterialPageRoute(
  //   //           builder: (context) => StressResultScreen(
  //   //             surveyId: surveyId,
  //   //             replacementScreen: HomePage(),
  //   //           ),
  //   //         ),
  //   //       )
  //   //           .then((_) {
  //   //         if (mounted) {
  //   //           Navigator.of(context).pushReplacement(
  //   //               MaterialPageRoute(builder: (context) => HomePage()));
  //   //         }
  //   //       });
  //   //     }
  //   //   } else if (response.statusCode == 400 &&
  //   //       response.body
  //   //           .contains("이미 오늘의 피드백이 생성되었습니다. 새로운 피드백은 내일 생성할 수 있습니다.")) {
  //   //     if (!_isDisposed) {
  //   //       const ToastBarWidget(
  //   //         title: '스트레스 검사는 하루에\n한번만 가능합니다.',
  //   //       ).showToast(context);
  //   //     }
  //   //   }
  //   // } catch (e) {
  //   //   if (!_isDisposed) {
  //   //     //print('설문조사 전송 실패: $e');
  //   //   }
  //   // } finally {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // }
  //   //
  //   // try {
  //   //   _loadInterstitialAd();
  //   //
  //   //   // 서버에 POST 요청 보내기 (예제에서 testStress 함수를 호출하는 방식으로 가정)
  //   //   final response = await homeApiService.testStress(questionResponses);
  //   //   //print('상태 코드 출려어어어ㅓㄱ ${response.statusCode}');
  //   //   if (response.statusCode == 201) {
  //   //     final responseBody = jsonDecode(response.body); // JSON 디코딩
  //   //     final surveyId = responseBody['surveyId'];
  //   //     if (mounted) {
  //   //       Navigator.of(context)
  //   //           .pushReplacement(
  //   //         MaterialPageRoute(
  //   //           builder: (context) => StressResultScreen(
  //   //             surveyId: surveyId,
  //   //             replacementScreen: HomePage(),
  //   //           ),
  //   //         ),
  //   //       )
  //   //           .then((_) {
  //   //         if (mounted) {
  //   //           Navigator.of(context).pushReplacement(
  //   //               MaterialPageRoute(builder: (context) => HomePage()));
  //   //         }
  //   //       });
  //   //     }
  //   //   } else if (response.statusCode == 400 &&
  //   //       response.body
  //   //           .contains("이미 오늘의 피드백이 생성되었습니다. 새로운 피드백은 내일 생성할 수 있습니다.")) {
  //   //     if (!_isDisposed) {
  //   //       const ToastBarWidget(
  //   //         title: '스트레스 검사는 하루에\n한번만 가능합니다.',
  //   //       ).showToast(context);
  //   //     }
  //   //   }
  //   // } catch (e) {
  //   //   if (!_isDisposed) {
  //   //     //print('설문조사 전송 실패: $e');
  //   //   }
  //   // } finally {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // }
  // }


}
