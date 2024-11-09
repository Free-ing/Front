import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/component/bottom_sheet.dart';
import '../../common/component/buttons.dart';
import '../../common/component/dialog_manager.dart';
import '../../common/component/text_form_fields.dart';
import '../../common/component/toast_bar.dart';
import '../../common/service/home_bottom_sheet_api_service.dart';
import '../../common/service/token_storage.dart';
import '../member/login.dart';

//Todo: 수면 기록
Future<bool> showSleepBottomSheet(BuildContext context, String title) async{
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
  bool isSuccess = false;

  Future<void> _sleepTimeRecord(AnimationController controller) async {
    final sleepTime = _sleepTimeController.text;
    final wakeUpTime = _wakeUpTimeController.text;
    final memo = _sleepMemoController.text;
    String sleepStatus = 'default';

    DateTime now = DateTime.now();
    final String recordDay = DateFormat("yyyy-MM-dd").format(now);
    print('sleep Time : $sleepTime');

    if( selectedIndex >= 0){
      sleepStatus = sleepStatusList[selectedIndex];
    } else {
      print('Invalid index: $selectedIndex');
    }

    if (_sleepTimeController.text.isNotEmpty &&
        _wakeUpTimeController.text.isNotEmpty &&
        sleepStatus != 'default' &&
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
        isSuccess = true;
        await controller.reverse();
        Navigator.pop(context, isSuccess);
        Future.microtask(()=> ToastBarWidget(
          title: '수면 기록이 저장되었습니다.',
          leadingImagePath: "assets/imgs/home/sleep_record_success.png",
        ).showToast(context));

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

  isSuccess = await showCustomModalBottomSheet(
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
  ) ?? false;

  print('수면 바텀 시트: $isSuccess');
  return isSuccess;
}
