import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/screen/chart/ai_letter.dart';
import 'package:freeing/screen/setting/setting_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EmotionDiaryCard extends StatefulWidget {
  final int diaryId;
  final DateTime date;
  final int letterId;
  final bool scrap;
  final String emotionImage;
  final String wellDone;
  final String hardWork;
  final VoidCallback deleteDiary;
  final String from;
  final VoidCallback onScrapToggle;

  const EmotionDiaryCard({
    super.key,
    required this.diaryId,
    required this.date,
    required this.letterId,
    required this.scrap,
    required this.emotionImage,
    required this.wellDone,
    required this.hardWork,
    required this.deleteDiary,
    required this.from,
    required this.onScrapToggle,
  });

  @override
  State<EmotionDiaryCard> createState() => _EmotionDiaryCardState();
}

class _EmotionDiaryCardState extends State<EmotionDiaryCard> {
  late bool _isScrap;
  final apiService = SpiritAPIService();
  String _name = '';

  RewardedInterstitialAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewUserInfo();
    _loadRewardedInterstitialAd();
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

  //Todo: 모달 바텀 시트: 감정 일기 편집 옵션
  void showMenu(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // ListTile(
              //   leading: Icon(Icons.edit_note_rounded),
              //   title: const Text('일기 수정하기'),
              //   onTap: () {},
              // ),
              ListTile(
                  leading: Icon(Icons.delete_forever_outlined),
                  title: const Text('일기 삭제하기'),
                  onTap: () {
                    DialogManager.showConfirmDialog(
                      context: context,
                      title: '감정일기 삭제',
                      content: '삭제된 감정 일기는 복구할 수 없습니다.\n삭제하시겠습니까?',
                      onConfirm: widget.deleteDiary,
                    );
                  })
            ],
          ),
        );
      },
    );
  }

  //Todo: 보상형 전면 광고 로드
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

  //Todo: 보상형 전면 광고 보여줌
  Future<void> _showRewardedAd() async {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('보상형 광고 보상 획득: ${reward.amount} ${reward.type}');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AiLetter(
              diaryId: widget.diaryId,
              date: widget.date,
              letterId: widget.letterId,
              from: widget.from,
            ),
          ),
        );
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AiLetter(
            diaryId: widget.diaryId,
            date: widget.date,
            letterId: widget.letterId,
            from: widget.from,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      _isScrap = widget.scrap;
    });
    return Column(
      children: [
        /// 날짜 표시, 편지 보기 버튼, 스크랩 버튼
        _dateViewLetterScrap(textTheme, screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.008),

        /// 감정 일기 조회
        _viewRecordContent(textTheme, screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }

  //Todo: 날짜 표시, 편지 보기 버튼, 스크랩 버튼
  Widget _dateViewLetterScrap(textTheme, screenWidth, screenHeight) {
    return SizedBox(
      height: screenHeight * 0.035,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                /// 날짜 표시
                Text(
                  '${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일',
                  style: textTheme.titleSmall,
                ),
                SizedBox(width: screenWidth * 0.02),

                /// 편지 보기 버튼
                Visibility(
                  visible: widget.letterId == -1 ? false : true,
                  child: SizedBox(
                    width: screenWidth * 0.19,
                    height: screenHeight * 0.027,
                    child: OutlinedButton(
                      onPressed: () {
                        print('페이지 넘어가는 편지 아이디 ${widget.letterId}');
                        DialogManager.showImageDialog(
                          context: context,
                          userName: _name,
                          topic: '편지',
                          image: 'assets/imgs/etc/letter_mascot.png',
                          onConfirm: () async {
                            if (_isRewardedAdReady) {
                              Navigator.pop(context);
                              await _showRewardedAd();
                            } else {
                              debugPrint('광고가 아직 로드되지 않았습니다');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AiLetter(
                                    diaryId: widget.diaryId,
                                    date: widget.date,
                                    letterId: widget.letterId,
                                    from: widget.from,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                      child: Text('편지 보기', style: textTheme.labelMedium),
                      style: OutlinedButton.styleFrom(
                        fixedSize:
                            Size(screenWidth * 0.18, screenHeight * 0.02),
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: LIGHT_GREY,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 스크랩 버튼
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: widget.onScrapToggle,
              icon: Image.asset(
                _isScrap
                    ? 'assets/icons/bookmark_icon_on.png'
                    : 'assets/icons/bookmark_icon_off.png',
                width: screenWidth * 0.07,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  //Todo: 감정 일기 조회
  Widget _viewRecordContent(textTheme, screenWidth, screenHeight) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.033, vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          color: LIGHT_GREY,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            /// 감정 얼굴
            Positioned(
              top: screenHeight * 0.023,
              child:
                  Image.asset(widget.emotionImage, width: screenWidth * 0.15),
            ),

            /// 기록한 내용
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: screenWidth * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('칭찬하고 싶은 일'),

                        /// 감정 일기 삭제 버튼
                        Container(
                          width: screenWidth * 0.07,
                          height: screenHeight * 0.035,
                          child: IconButton(
                            onPressed: () {
                              showMenu(context);
                            },
                            icon: Icon(Icons.more_horiz),
                            padding: EdgeInsets.zero,
                            iconSize: screenWidth * 0.06,
                            color: DARK_GREY,
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.05,
                        maxHeight: screenHeight * 0.135,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _buildRecordText(widget.wellDone, textTheme);
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text('슬펐던 일'),
                        SizedBox(height: screenHeight * 0.04)
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.05,
                        maxHeight: screenHeight * 0.135,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _buildRecordText(widget.hardWork, textTheme);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Todo: 기록 내용
  Widget _buildRecordText(text, textTheme) {
    return SingleChildScrollView(
      child: Text(
        text,
        style: textTheme.bodySmall,
        maxLines: null,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
