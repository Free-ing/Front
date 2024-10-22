import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/component/dialog_manager.dart';
import '../../common/component/sleep_card.dart';
import '../../common/const/colors.dart';
import '../../common/service/sleep_api_service.dart';
import '../../model/sleep/sleep_list.dart';

class SleepTabBarView extends StatefulWidget {
  const SleepTabBarView({super.key});

  @override
  State<SleepTabBarView> createState() => _SleepTabBarViewState();
}

class _SleepTabBarViewState extends State<SleepTabBarView> {
  List<SleepList> _sleepList = [];

  Future<List<SleepList>> _fetchHobbyList() async {
    print("Fetching sleep list");

    final apiService = SleepAPIService();
    final response = await apiService.getSleepList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> hobbyList = jsonData['result'];
        _sleepList.clear();
        for (dynamic data in hobbyList) {
          SleepList SleepCard = SleepList.fromJson(data);
          _sleepList.add(SleepCard);
        }
      }
      return _sleepList;
    } else if (response.statusCode == 404) {
      return _sleepList = [];
    } else {
      throw Exception('수면 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHobbyList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    List<SleepList> combinedSleepList = [...defaultSleepList, ..._sleepList];

    return Column(
      children: [
        Row(
          children: [
            Text('수면 기록하기', style: textTheme.titleLarge,),
            QuestionMark(
                title: '수면 기록하기 설명',
                description:
                    '잠을 잔 시간, 자고 일어난 후의 상태를 기록해요!\n주간(월간) 통계와 피드백을 받을 수 있어요!'),
            Spacer(),
            toggle(),
          ],
        ),
        Container(
          width: screenWidth,
          child: Divider(color: Colors.black, thickness: 1.0,),
        ),
        Row(
          children: [
            Text('수면 루틴 만들기', style: textTheme.titleLarge,),
            QuestionMark(
                title: '수면 루틴 만들기 설명',
                description:
                    '꿀잠을 위한 루틴을 만들어 보세요!\n추천해드리는걸 해도 되고, 직접 세워봐도 좋아요!'),
          ],
        ),
        Container(
          height: screenHeight * 0.4,
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: combinedSleepList.length,
            itemBuilder: (context, index) {
              final sleepList = combinedSleepList[index];
              return SleepCard(
                routineId: sleepList.routineId,
                imageUrl: sleepList.imageUrl,
                title: sleepList.sleepRoutineName,
              );
            },
          ),
        ),
      ],
    );
  }
}

class QuestionMark extends StatelessWidget {
  final String title;
  final String description;

  const QuestionMark({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DialogManager.showAlertDialog(
          context: context,
          title: title,
          content: description,
        );
      },
      icon: Image.asset(
        "assets/icons/question_icon.png",
        width: 30,
      ),
    );
  }
}

class toggle extends StatefulWidget {
  const toggle({super.key});

  @override
  State<toggle> createState() => _toggleState();
}

class _toggleState extends State<toggle> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
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
              color: isSwitched ? Colors.black : DARK_GREY,
            ),
            color: isSwitched ? PRIMARY_COLOR : MEDIUM_GREY,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumb 부분
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                left: isSwitched ? 16.0 : 2.0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSwitched ? Colors.black : DARK_GREY,
                      ),
                      boxShadow: <BoxShadow>[
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
