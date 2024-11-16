import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/question_mark.dart';
import '../../common/component/dialog_manager.dart';
import '../../common/component/sleep_card.dart';
import '../../common/const/colors.dart';
import '../../common/service/sleep_api_service.dart';
import '../../common/service/token_storage.dart';
import '../../model/sleep/sleep_list.dart';

class SleepTabBarView extends StatefulWidget {
  const SleepTabBarView({super.key});

  @override
  State<SleepTabBarView> createState() => SleepTabBarViewState();
}

class SleepTabBarViewState extends State<SleepTabBarView> {
  final apiService = SleepAPIService();
  final tokenStorage = TokenStorage();
  List<SleepList> _sleepList = [];
  bool isSwitched = false;
  bool? isRecordOn;

  // TODO: 수면 루틴 리스트 받아오는 서버 요청
  Future<List<SleepList>> fetchSleepList() async {
    print("Fetching sleep list");

    final response = await apiService.getSleepList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is List) {
        setState(() {
          _sleepList =
              jsonData.map((data) => SleepList.fromJson(data)).toList();

          _sleepList.sort((a, b) => a.routineId.compareTo(b.routineId));
        });
      } else {
        print('Unexpected JSON format');
      }
      return _sleepList;
    } else if (response.statusCode == 204) {
      print("status Code 204안!!");
      return _sleepList = [];
    } else if (response.statusCode == 404) {
      print("status Code 404안!!");
      return _sleepList = [];
    } else {
      throw Exception('Failed to fetch sleep list ${response.statusCode}');
    }
  }

  // 수면 기록 on/off 상태 불러오는 서버 요청
  Future<void> getRecordSleepStatus() async {
    try {
      bool recordStatus = await apiService.getRecordSleepStatus();

      // setState() 안에서 상태를 갱신
      setState(() {
        isRecordOn = recordStatus;
      });
    } catch (e) {
      print('Error ${isRecordOn == true ? '켜기' : '끄기'} 실패 $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print('fetch sleep list');
    fetchSleepList();
    getRecordSleepStatus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Text(
              '수면 기록하기',
              style: textTheme.titleLarge,
            ),
            const QuestionMark(
                title: '수면 기록하기 설명',
                content:
                    '잠을 잔 시간, 자고 일어난 후의\n 상태를 기록해요!\n\n주간(월간) 통계와 피드백을 받을 수 있어요!'),
            const Spacer(),
            toggle(isRecordOn: (isRecordOn == true ? true : false)),
          ],
        ),
        Container(
          width: screenWidth,
          child: const Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
        Row(
          children: [
            Text(
              '수면 루틴 만들기',
              style: textTheme.titleLarge,
            ),
            const QuestionMark(
                title: '수면 루틴 만들기 설명',
                content: '꿀잠을 위한 루틴을 만들어 보세요!\n\n추천해드리는걸 해도 되고,\n직접 세워봐도 좋아요!'),
          ],
        ),
        Container(
          height: screenHeight * 0.529,
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _sleepList.length,
            itemBuilder: (context, index) {
              final sleepList = _sleepList[index];
              return SleepCard(
                routineId: sleepList.routineId,
                imageUrl: sleepList.imageUrl,
                title: sleepList.sleepRoutineName,
                monday: sleepList.monday,
                tuesday: sleepList.tuesday,
                wednesday: sleepList.wednesday,
                thursday: sleepList.thursday,
                friday: sleepList.friday,
                saturday: sleepList.saturday,
                sunday: sleepList.sunday,
                startTime: sleepList.startTime,
                endTime: sleepList.endTime,
                status: sleepList.status,
              );
            },
          ),
        ),
      ],
    );
  }
}

class toggle extends StatefulWidget {
  bool isRecordOn;

  toggle({super.key, required this.isRecordOn});

  @override
  State<toggle> createState() => _toggleState();
}

class _toggleState extends State<toggle> {
  final sleepApiService = SleepAPIService();

  // 수면 기록 on/off 서버 요청
  Future<void> recordSleepOnOff(bool isRecordOn) async {
    try {
      await sleepApiService.sleepRecord(isRecordOn);
    } catch (e) {
      print('Error ${isRecordOn ? '켜기' : '끄기'} 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isRecordOn = !widget.isRecordOn;
          recordSleepOnOff(widget.isRecordOn);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isRecordOn ? Colors.black : DARK_GREY,
            ),
            color: widget.isRecordOn ? PRIMARY_COLOR : MEDIUM_GREY,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumb 부분
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                left: widget.isRecordOn ? 16.0 : 2.0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isRecordOn ? Colors.black : DARK_GREY,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 2.0,
                          spreadRadius: 0.2,
                          offset: Offset(0.0, 2.0),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
