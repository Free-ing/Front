import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/screen/chart/mood_calendar_screen.dart';
import 'package:freeing/screen/chart/mood_scrap_screen.dart';

class Letter {
  final String content;

  Letter({
    required this.content,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      content: json['content'],
    );
  }
}

class AiLetter extends StatefulWidget {
  final int diaryId;
  final DateTime date;
  final int letterId;
  final String from;

  const AiLetter(
      {super.key,
      required this.diaryId,
      required this.date,
      required this.letterId,
      required this.from});

  @override
  State<AiLetter> createState() => _AiLetterState();
}

class _AiLetterState extends State<AiLetter> {
  String letterText = '';
  final apiService = SpiritAPIService();

  // Todo: 서버 요청 (AI 편지 조회)
  Future<void> _fetchAiLetter(int letterId) async {
    print('조회 요청 보내는 편지 아이디 $letterId');
    final response = await apiService.getAiLetter(letterId);

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(data);
      final content = jsonData['result']['content'];

      setState(() {
        letterText = content;
      });
    } else {
      throw Exception('편지 가져오기 실패 ${response.statusCode}');
    }
  }


  // Todo: 서버 요청 (AI 편지 삭제)
  Future<void> _deleteAiLetter(int letterId) async {
    final responseCode = await apiService.deleteAiLetter(letterId);

    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => widget.from == 'scrap'
                ? const MoodScrap()
                : const MoodCalendar()),
      );
      ToastBarWidget(title: '편지가 삭제되었습니다.').showToast(context);
    } else {
      ToastBarWidget(
        title: '편지가 삭제되지 않았습니다. $responseCode',
      ).showToast(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAiLetter(widget.letterId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _backgroundImageTop(),
          _backgroundImageMiddle(),
          _backgroundImageBottom(),
          _popButton(context, screenWidth, screenHeight),
          _dear(screenWidth, screenHeight),
          _content(screenWidth, screenHeight),
          _deleteLetter(screenWidth, screenHeight),
        ],
      ),
    );
  }

  /// 배경 이미지
  Widget _backgroundImageTop() {
    return Align(
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/imgs/background/letter_top.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _backgroundImageMiddle() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/imgs/background/letter_middle.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _backgroundImageBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/imgs/background/letter_bottom.png',
        fit: BoxFit.cover,
      ),
    );
  }

  /// 뒤로 가기 버튼
  Widget _popButton(context, screenWidth, screenHeight) {
    return Positioned(
      top: screenHeight * 0.063,
      left: screenWidth * 0.04,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => widget.from == 'scrap'
                      ? const MoodScrap()
                      : const MoodCalendar()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 30,
        ),
      ),
    );
  }

  /// 나의 파트너에게
  Widget _dear(screenWidth, screenHeight) {
    return Positioned(
      top: screenHeight * 0.06,
      left: screenWidth * 0.3,
      child: Text(
        '나의 파트너',
        style: TextStyle(fontSize: 28, fontFamily: 'nadeuri'),
      ),
    );
  }

  Widget _content(screenWidth, screenHeight) {
    return Positioned(
      top: screenHeight * 0.15,
      right: screenWidth * 0.15,
      left: screenWidth * 0.15,
      //alignment: Alignment.center,
      child: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                letterText,
                style: TextStyle(fontSize: 22, fontFamily: 'nadeuri'),
              ),
              SizedBox(height: screenHeight * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일',
                    style: TextStyle(fontSize: 24, fontFamily: 'nadeuri'),
                  ),
                  Text(
                    'From. 후링이',
                    style: TextStyle(fontSize: 24, fontFamily: 'nadeuri'),
                  ),
                  SizedBox(height: screenHeight*0.05),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 편지 삭제 버튼
  Widget _deleteLetter(screenWidth, screenHeight) {
    return Positioned(
      top: screenHeight * 0.063,
      right: screenWidth * 0.08,
      child: IconButton(
        onPressed: () {
          DialogManager.showConfirmDialog(
            context: context,
            title: '편지 삭제',
            content: '삭제된 편지는 복구할 수 없으며\n'
                '다시 받아볼 수 없어요.\n'
                '편지를 삭제 할까요?',
            onConfirm: () {
              _deleteAiLetter(widget.letterId);
            },
          );
        },
        icon: Icon(Icons.delete_forever_outlined),
        iconSize: 35,
      ),
    );
  }
}
