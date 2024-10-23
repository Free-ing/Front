import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/home_bottom_sheet_api_service.dart';
import 'package:freeing/common/service/token_storage.dart';
import 'package:intl/intl.dart';

import '../../screen/member/login.dart';
import 'dialog_manager.dart';

void showExerciseBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('?')],
        ),
      );
    },
  );
}

void showMeditationBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('?')],
        ),
      );
    },
  );
}

void showSleepBottomSheet(BuildContext context, String title) {
  final TextEditingController _sleepTimeController = TextEditingController();
  final TextEditingController _wakeUpTimeController = TextEditingController();
  final TextEditingController _sleepMemoController = TextEditingController();
  final HomeBottomSheetApiService _homeButtonSheetApiService =
      HomeBottomSheetApiService();
  final tokenStorage = TokenStorage();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  int selectedIndex = -1;
  List<String> sleepStatusList = ['REFRESHED', 'STIFF', 'UNRESTED'];

  Future<void> _sleepTimeRecord(AnimationController controller) async {
    final sleepTime = _sleepTimeController.text;
    final wakeUpTime = _wakeUpTimeController.text;
    final memo = _sleepMemoController.text;
    final sleepStatus = sleepStatusList[selectedIndex];
    DateTime now = DateTime.now();
    final String recordDay = DateFormat("yyyy-MM-dd").format(now);
    print('sleep Time : $sleepTime');

    print('sleepTImeRecord 안!!!!!!!!!!!!!!!!!!!!!!!');
    // bool validateInputs() {
    //   return _sleepTimeController.text.isNotEmpty &&
    //       _wakeUpTimeController.text.isNotEmpty &&
    //       sleepStatus.isNotEmpty &&
    //       recordDay.isNotEmpty;
    // }

    if (_sleepTimeController.text.isNotEmpty &&
        _wakeUpTimeController.text.isNotEmpty &&
        sleepStatus.isNotEmpty &&
        recordDay.isNotEmpty) {
      final response = await _homeButtonSheetApiService.sleepTimeRecord(
          wakeUpTime: wakeUpTime,
          sleepTime: sleepTime,
          recordDay: recordDay,
          memo: memo,
          sleepStatus: sleepStatus);

      if (response.statusCode == 200) {
        // 성공 되었다는 메시지 띄우기
        print('성공');
        await controller.reverse();
        Navigator.pop(context);
        ToastBarWidget(
          title: '수면 기록이 저장되었습니다.',
          leadingImagePath: "assets/imgs/home/sleep_record_success.png",
        ).showToast(context);
      } else if (response.statusCode == 400) {
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '모두 입력해주세요.',
        );
      } else if (response.statusCode == 401) {
        // access 토큰 유효하지 않거나 누락된 경우 - 권한 없음
        //refresh 토큰 발급!
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
      } else {
        // statusCode == 500
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '서버에서 오류가 발생하였습니다.\n다시 시도해주세요.',
        );
      }
    } else {
      DialogManager.showAlertDialog(
        context: context,
        title: '알림',
        content: '모두 입력해주세요.',
      );
    }
  }

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return BaseAnimatedBottomSheetContent(
            title: title,
            onButtonPressed: (AnimationController controller) async{
              await _sleepTimeRecord(controller);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text('몇 시쯤 잠자리에 들었나요?', style: textTheme.bodyMedium),
                  ),
                  TimePickerButton(
                    controller: _sleepTimeController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text('오늘 몇 시에 일어났나요?', style: textTheme.bodyMedium),
                  ),
                  TimePickerButton(
                    controller: _wakeUpTimeController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text('자고 일어난 후의 상태를 알려주세요.',
                        style: textTheme.bodyMedium),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomClickedContainer(
                        beforeImage: 'assets/imgs/home/before_refreshed.png',
                        selected: selectedIndex == 0,
                        afterImage: 'assets/imgs/home/after_refreshed.png',
                        text: '개운해요',
                        onTap: () {
                          setState(() {
                            // selectedIndex == -1인 경우 그냥 selectIndex isClicked
                            selectedIndex = 0;
                            // selectedIndex != -1인 경우 selectedIndex의 isClick = false,
                            // 한 후 selectedIndex 의 값 변경
                          });
                        },
                      ),
                      CustomClickedContainer(
                        beforeImage: 'assets/imgs/home/before_stiff.png',
                        afterImage: 'assets/imgs/home/after_stiff.png',
                        text: '뻐근해요',
                        selected: selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                      ),
                      CustomClickedContainer(
                        beforeImage: 'assets/imgs/home/before_unrested.png',
                        afterImage: 'assets/imgs/home/after_unrested.png',
                        text: '잔 것 같지 않아요',
                        selected: selectedIndex == 2,
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Text('메모를 남길 수 있어요.', style: textTheme.bodyMedium),
                    ),
                  ),
                  YellowTextFormField(
                    controller: _sleepMemoController,
                    maxLength: 50,
                    // height: screenHeight * 0.06,
                    height: screenHeight * 0.1,
                    width: screenWidth,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showDiaryBottomSheet(BuildContext context, String title) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            children: [
              Text('?'),
            ],
          ),
        ),
      );
    },
  );
}

void showHobbyBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        // 완료 버튼 눌렸을때 실행되는 함수 호출
        onButtonPressed: (AnimationController) async{
        },
        child: Column(
          children: [Text('?')],
        ),
      );
    },
  );
}

void showCustomModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext, TextTheme) builder,
}) {
  final textTheme = Theme.of(context).textTheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return builder(context, textTheme);
    },
  );
}

// AnimatedContainer를 이용한 애니메이션 적용
class BaseAnimatedBottomSheetContent extends StatefulWidget {
  final String title;
  final Widget child;
  final void Function(AnimationController controller) onButtonPressed;
  BaseAnimatedBottomSheetContent({
    required this.title,
    required this.child,
    required this.onButtonPressed,
  });

  @override
  _BaseAnimatedBottomSheetContentState createState() =>
      _BaseAnimatedBottomSheetContentState();
}

class _BaseAnimatedBottomSheetContentState
    extends State<BaseAnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 800), // 애니메이션 지속 시간
      reverseDuration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1), // 아래에서 위로 이동하는 애니메이션
            end: Offset(0, 0),
          ).animate(_animation),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.005),
                      child: Container(
                        width: screenWidth * 0.28,
                        height: screenHeight * 0.008,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.035,
                          bottom: screenHeight * 0.045),
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          width: screenWidth * 0.77,
                          height: screenHeight * 0.045,
                          decoration: BoxDecoration(
                            color: BLUE_PURPLE,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              widget.title,
                              style: textTheme.headlineLarge
                                  ?.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Container(width: screenWidth, child: widget.child),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: screenHeight * 0.05,
                          top: screenHeight * 0.03),
                      child: GreenButton(
                        width: screenWidth * 0.6,
                        onPressed: () async {
                          widget.onButtonPressed(controller);
                          print('GreenButton의 onButtonPresssed 밑!!');
                          //await _controller.reverse(); // 애니메이션 역방향 실행
                          //Navigator.pop(context); // 애니메이션 완료 후 BottomSheet 닫기
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// 수면 기록하기에서 클릭되는 효과!
class CustomClickedContainer extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  CustomClickedContainer({
    required this.beforeImage,
    required this.afterImage,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  _CustomClickedContainerState createState() => _CustomClickedContainerState();
}

class _CustomClickedContainerState extends State<CustomClickedContainer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: screenWidth * 0.25,
        height: screenHeight * 0.13,
        decoration: BoxDecoration(
          color: widget.selected ? Colors.white : Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: widget.selected ? Colors.black : Color(0xFF929292),
              width: 1),
          boxShadow: [
            BoxShadow(
              color: widget.selected
                  ? Color(0xFFFFD477).withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              offset: Offset(2, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: widget.selected
                          ? Color(0xFFFFD477).withOpacity(0.4)
                          : Colors.black.withOpacity(0.1),
                      offset: Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(
                  widget.selected ? widget.afterImage : widget.beforeImage,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.text,
                style:
                    textTheme.labelMedium?.copyWith(color: Color(0xFF2C2C2C)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
