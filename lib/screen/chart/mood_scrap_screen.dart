import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/emotion_diary_card.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/spirit/emotion_diary.dart';
import 'package:freeing/screen/chart/mood_calendar_screen.dart';

class MoodScrap extends StatefulWidget {
  const MoodScrap({super.key});

  @override
  State<MoodScrap> createState() => _MoodScrapState();
}

class _MoodScrapState extends State<MoodScrap> {
  final apiService = SpiritAPIService();
  List<EmotionDiary> _scrapDiaryList = [];

  //Todo: 서버 요청 (스크랩한 감정 일기 / AI 편지 조회)
  Future<List<EmotionDiary>> _fetchScrapDiaryList() async {
    print('Fetching scrap diary list');

    final response = await apiService.getScrapList();

    print(response);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> scrapList = jsonData['result'];
        _scrapDiaryList.clear();
        for (dynamic data in scrapList) {
          // Map<String, dynamic> 타입인 data를 EmotionDiary 객체로 변환
          EmotionDiary emotionDiary =
              EmotionDiary.fromJson(data as Map<String, dynamic>);
          _scrapDiaryList.add(emotionDiary);
        }
      }
      print(_scrapDiaryList);
      return _scrapDiaryList;
    } else {
      throw Exception('스크랩 감정 일기 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchScrapDiaryList().then((diaries) {
      setState(() {
        _scrapDiaryList = diaries;
      });
    });
  }

  //Todo: 감정 별 이미지 경로
  String getEmotionImagePath(String emotion) {
    switch (emotion) {
      case 'HAPPY':
        return 'assets/imgs/mind/emotion_happy.png';
      case 'CALM':
        return 'assets/imgs/mind/emotion_calm.png';
      case 'ANXIETY':
        return 'assets/imgs/mind/emotion_anxiety.png';
      case 'ANGRY':
        return 'assets/imgs/mind/emotion_angry.png';
      case 'SAD':
        return 'assets/imgs/mind/emotion_sad.png';
      default:
        return 'assets/imgs/mind/emotion_none.png';
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
      setState(() {
        _scrapDiaryList.removeWhere((diary) => diary.diaryId == diaryId);
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('감정 일기가 삭제되지 않았습니다 ${responseCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChartLayout(
      title: '스크랩',
      backToPage: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MoodCalendar()),
        );
      },
      chartWidget: ListView.builder(
        itemCount: _scrapDiaryList.length,
        itemBuilder: (BuildContext context, int index) {
          final scrapDiaryList = _scrapDiaryList[index];
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: EmotionDiaryCard(
              diaryId: scrapDiaryList.diaryId,
              date: scrapDiaryList.date,
              letterId: scrapDiaryList.letterId,
              scrap: scrapDiaryList.scrap,
              emotionImage: getEmotionImagePath(scrapDiaryList.emotion),
              wellDone: scrapDiaryList.wellDone,
              hardWork: scrapDiaryList.hardWork,
              deleteDiary: () {
                _deleteEmotionDiary(scrapDiaryList.diaryId);
              },
              from: 'scrap',
            ),
          );
        },
      ),
      selectMonth: false,
      onDateSelected: (date) {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const MoodCalendar()),
                  );
                },
                icon: Icon(Icons.arrow_back_ios_rounded),
                iconSize: 30.0,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Expanded(
                  child: Text(
                '스크랩',
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )),
              SizedBox(width: 45),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _scrapDiaryList.length,
        itemBuilder: (BuildContext context, int index) {
          final scrapDiaryList = _scrapDiaryList[index];
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: EmotionDiaryCard(
              diaryId: scrapDiaryList.diaryId,
              date: scrapDiaryList.date,
              letterId: scrapDiaryList.letterId,
              scrap: scrapDiaryList.scrap,
              emotionImage: getEmotionImagePath(scrapDiaryList.emotion),
              wellDone: scrapDiaryList.wellDone,
              hardWork: scrapDiaryList.hardWork,
              deleteDiary: () {
                _deleteEmotionDiary(scrapDiaryList.diaryId);
              },
              from: 'scrap',
            ),
          );
        },
      ),
    );
  }
}
