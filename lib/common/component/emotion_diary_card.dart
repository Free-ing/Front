import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/spirit_api_sevice.dart';
import 'package:freeing/screen/chart/ai_letter.dart';

class EmotionDiaryCard extends StatefulWidget {
  final int diaryId;
  final int year;
  final int month;
  final int selectedDate;
  final int letterId;
  final bool scrap;
  final String emotionImage;
  final String wellDone;
  final String hardWork;
  final VoidCallback deleteDiary;

  const EmotionDiaryCard({
    super.key,
    required this.diaryId,
    required this.year,
    required this.month,
    required this.selectedDate,
    required this.letterId,
    required this.scrap,
    required this.emotionImage,
    required this.wellDone,
    required this.hardWork,
    required this.deleteDiary,
  });

  @override
  State<EmotionDiaryCard> createState() => _EmotionDiaryCardState();
}

class _EmotionDiaryCardState extends State<EmotionDiaryCard> {
  late bool _isScrap;
  final apiService = SpiritAPIService();

  //Todo: 서버 요청 (감정 일기 스크랩 하기)
  Future<void> _scrapEmotionDiary(int diaryId) async {
    print('감정 일기 스크랩 하기');
    final responseCode = await apiService.scrapEmotionDiary(diaryId);
    if (responseCode == 200) {
      print('감정일기 스크랩 성공');
    } else {
      print('감정일기 스크랩 실패(${responseCode})');
    }
  }

  //Todo: 서버 요청 (감정 일기 스크랩 취소 하기)
  Future<void> _scrapCancelEmotionDiary(int diaryId) async {
    print('감정 일기 스크랩 취소 하기');
    final responseCode = await apiService.scrapCancelEmotionDiary(diaryId);
    if (responseCode == 200) {
      print('감정일기 스크랩 취소 성공');
    } else {
      print('감정일기 스크랩 취소 실패($responseCode');
    }
  }

  //Todo: 서버 요청 (감정 일기 삭제)
  Future<void> _deleteEmotionDiary(int diaryId) async {
    final responseCode = await apiService.deleteEmotionDiary(diaryId);

    print(diaryId);

    print(responseCode);
    if (responseCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('감정일기가 삭제되었습니다.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('감정 일기가 삭제되지 않았습니다 ${responseCode}')),
      );
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
              ListTile(
                leading: Icon(Icons.edit_note_rounded),
                title: const Text('일기 수정하기'),
                onTap: () {},
              ),
              ListTile(
                  leading: Icon(Icons.delete_forever_outlined),
                  title: const Text('일기 삭제하기'),
                  onTap: (){widget.deleteDiary;}),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _isScrap = widget.scrap;

    print('초기 스크랩 상태: $_isScrap'); // 초기 상태 출력
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        /// 날짜 표시, 편지 보기 버튼, 스크랩 버튼
        SizedBox(
          height: screenHeight * 0.035,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    /// 날짜 표시
                    Text(
                      '${widget.year}년 ${widget.month}월 ${widget.selectedDate}일',
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AiLetter(),
                              ),
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
                    onPressed: () {
                      setState(() {
                        _isScrap = !_isScrap;
                        print('스크랩 상태 변경: $_isScrap'); // 상태 변경 출력

                        _isScrap
                            ? _scrapEmotionDiary(widget.diaryId)
                            : _scrapCancelEmotionDiary(widget.diaryId);
                      });
                    },
                    icon: Image.asset(
                      _isScrap
                          ? 'assets/icons/bookmark_icon_on.png'
                          : 'assets/icons/bookmark_icon_off.png',
                      width: screenWidth * 0.07,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ))
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.008),

        /// 감정 일기 조회
        Card(
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
                  child: Image.asset(widget.emotionImage,
                      width: screenWidth * 0.15),
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

                            /// 감정 일기 편집 버튼
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
                              return Text(
                                widget.wellDone,
                                // '딱 백자. 딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.'
                                // '딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자',
                                style: textTheme.bodySmall,
                                maxLines: null, // 텍스트가 줄바꿈 되도록 설정
                                overflow: TextOverflow.clip,
                              );
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
                              return Text(
                                widget.hardWork,
                                //'딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자.딱 백자',
                                style: textTheme.bodySmall,
                                maxLines: null, // 텍스트가 줄바꿈 되도록 설정
                                overflow: TextOverflow.clip,
                              );
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
        ),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }
}
