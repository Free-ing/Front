import 'package:flutter/material.dart';

class MoodScrap extends StatefulWidget {
  const MoodScrap({super.key});

  @override
  State<MoodScrap> createState() => _MoodScrapState();
}

class _MoodScrapState extends State<MoodScrap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('무드 스크랩'),),
      body: Center(
        child: Text('스크랩한 일기와 편지')
      )
    );
  }
}
