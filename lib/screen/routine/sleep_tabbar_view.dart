import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/component/dialog_manager.dart';
import '../../common/component/sleep_card.dart';
import '../../common/const/colors.dart';
import '../../common/service/sleep_api_service.dart';
import '../../common/service/token_storage.dart';
import '../../model/sleep/sleep_list.dart';
import '../member/login.dart';

class SleepTabBarView extends StatefulWidget {
  const SleepTabBarView({super.key});

  @override
  State<SleepTabBarView> createState() => SleepTabBarViewState();
}

class SleepTabBarViewState extends State<SleepTabBarView> {
  final apiService = SleepAPIService();
  final tokenStorage = TokenStorage();
  List<SleepList> _sleepList = [];

  // TODO: 서버 요청
  Future<List<SleepList>> fetchSleepList() async {
    print("Fetching sleep list");

    final response = await apiService.getSleepList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is List) {
        setState(() {
          _sleepList =
              jsonData.map((data) => SleepList.fromJson(data)).toList();
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

  // // TODO: 수면 루틴 toggle on (활성화)
  // Future<void> activeSleepRoutine(int routineId) async {
  //   print("Active sleep routine");
  //
  //   //final int routineId = _sleepList[sleepListIndex].routineId;
  //
  //   final response = await apiService.activeSleepRoutine(routineId);
  //
  //   if (response == 200) {
  //   } else if (response == 401) {
  //     //refresh 토큰 발급
  //     String? refreshToken = await tokenStorage.getRefreshToken();
  //     if (refreshToken != null) {
  //       var newAccessToken = await tokenStorage.getAccessToken();
  //       print('newAccessTOken: $newAccessToken');
  //       await tokenStorage.saveAccessTokens(newAccessToken!);
  //     } else {
  //       // refresh token이 없거나 만료된 경우
  //       DialogManager.showAlertDialog(
  //         context: context,
  //         title: '알림',
  //         content: '로그인 세션이 만료되었습니다.\n다시 로그인 해주세요.',
  //         onConfirm: () {
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (context) => Login(),
  //           ));
  //         },
  //       );
  //     }
  //   } else if (response == 404) {
  //     // 해당 루틴을 찾을 수 없음
  //     DialogManager.showAlertDialog(
  //         context: context, title: 'Error 404', content: '루틴을 찾을 수 없음');
  //   } else {
  //     // response == 500
  //     DialogManager.showAlertDialog(
  //         context: context, title: 'Error 500', content: '서버 오류 발생');
  //   }
  // }
  //
  // // TODO: 수면 루틴 toggle off (비활성화)
  // Future<void> deactiveSleepRoutine(int routineId) async {
  //   print("Deactive sleep routine");
  //
  //   //final int routineId = _sleepList[sleepListIndex].routineId;
  //
  //   final response = await apiService.deactiveSleepRoutine(routineId);
  //
  //   if (response == 200) {
  //   } else if (response == 401) {
  //     //refresh 토큰 발급
  //     String? refreshToken = await tokenStorage.getRefreshToken();
  //     if (refreshToken != null) {
  //       var newAccessToken = await tokenStorage.getAccessToken();
  //       print('newAccessTOken: $newAccessToken');
  //       await tokenStorage.saveAccessTokens(newAccessToken!);
  //     } else {
  //       // refresh token이 없거나 만료된 경우
  //       DialogManager.showAlertDialog(
  //         context: context,
  //         title: '알림',
  //         content: '로그인 세션이 만료되었습니다.\n다시 로그인 해주세요.',
  //         onConfirm: () {
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (context) => Login(),
  //           ));
  //         },
  //       );
  //     }
  //   } else if (response == 404) {
  //     // 해당 루틴을 찾을 수 없음
  //     DialogManager.showAlertDialog(
  //         context: context, title: 'Error 404', content: '루틴을 찾을 수 없음');
  //   } else {
  //     // response == 500
  //     DialogManager.showAlertDialog(
  //         context: context, title: 'Error 500', content: '서버 오류 발생');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print('fetch sleep list');
    fetchSleepList();
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
            QuestionMark(
                title: '수면 기록하기 설명',
                description:
                    '잠을 잔 시간, 자고 일어난 후의\n 상태를 기록해요!\n\n주간(월간) 통계와 피드백을 받을 수 있어요!'),
            Spacer(),
            toggle(),
          ],
        ),
        Container(
          width: screenWidth,
          child: Divider(
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
            QuestionMark(
                title: '수면 루틴 만들기 설명',
                description:
                    '꿀잠을 위한 루틴을 만들어 보세요!\n\n추천해드리는걸 해도 되고,\n직접 세워봐도 좋아요!'),
          ],
        ),
        Container(
          height: screenHeight * 0.5,
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
