import 'package:flutter/material.dart';
import 'package:freeing/screen/routine/sleep_tabbar_view.dart';
import '../../screen/member/login.dart';
import '../../screen/routine/edit_routine_screen.dart';
import '../const/colors.dart';
import '../service/sleep_api_service.dart';
import '../service/token_storage.dart';
import 'dialog_manager.dart';

class SleepCard extends StatefulWidget {
  final int routineId;
  final String imageUrl;
  final String title;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool status;

  SleepCard({
    super.key,
    required this.routineId,
    required this.imageUrl,
    required this.title,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    this.startTime,
    this.endTime,
    required this.status,
  });

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  final apiService = SleepAPIService();
  final tokenStorage = TokenStorage();

  // TODO: 수면 루틴 toggle on (활성화)
  Future<void> activateSleepRoutine(int routineId) async {
    print("Active sleep routine");

    final response = await apiService.activateSleepRoutine(routineId);

    if (response == 200) {
    } else if (response == 401) {
      //refresh 토큰 발급
      String? refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        var newAccessToken = await tokenStorage.getAccessToken();
        print('newAccessTOken: $newAccessToken');
        await tokenStorage.saveAccessTokens(newAccessToken!);
      } else {
        // refresh token이 없거나 만료된 경우
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '로그인 세션이 만료되었습니다.\n다시 로그인 해주세요.',
          onConfirm: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          },
        );
      }
    } else if (response == 404) {
      // 해당 루틴을 찾을 수 없음
      DialogManager.showAlertDialog(
          context: context, title: 'Error 404', content: '루틴을 찾을 수 없음');
    } else {
      // response == 500
      DialogManager.showAlertDialog(
          context: context, title: 'Error 500', content: '서버 오류 발생');
    }
  }

  // TODO: 수면 루틴 toggle off (비활성화)
  Future<void> deactivateSleepRoutine(int routineId) async {
    print("Deactive sleep routine");

    final response = await apiService.deactivateSleepRoutine(routineId);

    if (response == 200) {
    } else if (response == 401) {
      //refresh 토큰 발급
      String? refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        var newAccessToken = await tokenStorage.getAccessToken();
        print('newAccessTOken: $newAccessToken');
        await tokenStorage.saveAccessTokens(newAccessToken!);
      } else {
        // refresh token이 없거나 만료된 경우
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '로그인 세션이 만료되었습니다.\n다시 로그인 해주세요.',
          onConfirm: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          },
        );
      }
    } else if (response == 404) {
      // 해당 루틴을 찾을 수 없음
      DialogManager.showAlertDialog(
          context: context, title: 'Error 404', content: '루틴을 찾을 수 없음');
    } else {
      // response == 500
      DialogManager.showAlertDialog(
          context: context, title: 'Error 500', content: '서버 오류 발생');
    }
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditRoutineScreen(
            routineId: widget.routineId,
            title: widget.title,
            selectImage: widget.imageUrl,
            category: '수면',
            monday: widget.monday,
            tuesday: widget.tuesday,
            wednesday: widget.wednesday,
            thursday: widget.thursday,
            friday: widget.friday,
            saturday: widget.saturday,
            sunday: widget.sunday,
            startTime: widget.startTime,
            endTime: widget.endTime,
            status: widget.status,
          ),
        ));
      },
      child: Card(
        elevation: 6,
        shadowColor: YELLOW_SHADOW,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        margin: EdgeInsets.all(12),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Stack(
            children: [
              _routineImage(imageUrl: widget.imageUrl),
              _routineTitle(context: context, title: widget.title),
              _toggleSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      left: 15,
      right: 15,
      top: 13,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _routineTitle({required BuildContext context, required String title}) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _toggleSwitch() {
    return Positioned(
      top: 2,
      right: 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSwitched) {
              deactivateSleepRoutine(widget.routineId);
            } else {
              activateSleepRoutine(widget.routineId);
            }
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
      ),
    );
  }
}
