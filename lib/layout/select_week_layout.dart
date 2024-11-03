import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/screen/setting/setting_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class SelectWeekLayout extends StatefulWidget {
  final String title;
  final Widget routePage;
  const SelectWeekLayout(
      {super.key, required this.title, required this.routePage});

  @override
  State<SelectWeekLayout> createState() => _SelectWeekLayoutState();
}

class _SelectWeekLayoutState extends State<SelectWeekLayout> {
  DateTime selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  List<List<DateTime>> weeks = [];
  String _name = '';

  RewardedInterstitialAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _viewUserInfo();
    await _loadRewardedInterstitialAd();
    await calculateWeeks();
  }

  Future<void> _loadRewardedInterstitialAd() async {
    await RewardedInterstitialAd.load(
      adUnitId: AdMobService.rewardedInterstitialAdUnitId!,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('보상형 광고 로드 실패: $error');
          _rewardedAd = null;
          setState(() {
            _isRewardedAdReady = false;
          });
          Future.delayed(Duration(seconds: 5), _loadRewardedInterstitialAd);
        },
      ),
    );
  }

 Future<void> _showRewardedAd() async{
    if (_rewardedAd != null) {
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('보상형 광고 보상 획득: ${reward.amount} ${reward.type}');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget.routePage));
      });
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          ad.dispose();
          await _loadRewardedInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          ad.dispose();
          await _loadRewardedInterstitialAd();
        },
      );
    } else {
      print('보상형 광고가 로드되지 않음');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => widget.routePage));
    }
  }

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
      selectedYear = selectedDate.year;
      selectedMonth = selectedDate.month;
    });

    print('선택 날짜 $selectedDate');

    calculateWeeks();
  }

  //Todo: 주차별 날짜 계산
  Future<void> calculateWeeks() async {
    DateTime firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);

    // 첫 번째 월요일 찾기
    DateTime startOfWeek =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));

    List<List<DateTime>> calculatedWeeks = [];

    // 선택된 월 동안 월요일~일요일 주차로 리스트 작성
    while (true) {
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      DateTime nextMonday = endOfWeek.add(Duration(days: 1));

      // 다음 월요일이 선택된 월 이내인 경우만 리스트에 추가
      if (nextMonday.month == selectedMonth) {
        calculatedWeeks.add([startOfWeek, endOfWeek]);
      } else {
        break;
      }

      startOfWeek = nextMonday;
    }

    setState(() {
      weeks = calculatedWeeks;
    });
  }

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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChartLayout(
      title: '${widget.title} 리포트 몰아 보기',
      chartWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShowChartDate(
            selectedDate: selectedDate,
            onDateChanged: updateSelectedDate, // 콜백 함수 전달
          ),

          /// 주차 버튼들
          Container(
            height: screenHeight * 0.6,
            child: ListView.builder(
              itemCount: weeks.length,
              itemBuilder: (context, index) {
                List<DateTime> week = weeks[index];
                String start =
                    '${week.first.month.toString().padLeft(2, ' ')}월 ${week.first.day.toString().padLeft(2, ' ')}일';
                String end =
                    '${week.last.month.toString().padLeft(2, ' ')}월 ${week.last.day.toString().padLeft(2, ' ')}일';

                // 현재 날짜와 비교
                bool isFutureWeek = week.last.isAfter(DateTime.now());

                return Padding(
                  padding: EdgeInsets.all(screenHeight * 0.017),
                  child: SizedBox(
                    height: screenHeight * 0.075,
                    child: ElevatedButton(
                      onPressed: isFutureWeek
                          ? () {
                              DialogManager.showAlertDialog(
                                  context: context,
                                  title: '리포트 없음',
                                  content: '해당 주차가 마무리되지 않아\n저장된 리포트가 없습니다.');
                            }
                          : () {
                              DialogManager.showImageDialog(
                                context: context,
                                userName: _name,
                                topic: '${widget.title} 리포트',
                                image: 'assets/imgs/etc/report_mascot.png',
                                onConfirm: () async {
                                  if (_isRewardedAdReady) {
                                    Navigator.pop(context);
                                    await _showRewardedAd();
                                  } else {
                                    debugPrint('광고가 아직 로드되지 않았습니다');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                widget.routePage));
                                  }
                                },
                              );
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$start ~ $end', style: textTheme.bodyMedium),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: isFutureWeek ? DARK_GREY : Colors.black,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: YELLOW_SHADOW,
                        elevation: isFutureWeek ? 0 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isFutureWeek ? MEDIUM_GREY : ORANGE,
                            width: 2,
                          ),
                        ),
                        backgroundColor:
                            isFutureWeek ? LIGHT_GREY : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      onDateSelected: updateSelectedDate,
    );
  }
}
