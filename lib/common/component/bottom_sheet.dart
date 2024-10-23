import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/home_time_picker.dart' as custom;
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/const/colors.dart';

//Todo: 스트레칭
void showExerciseBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        child: Column(
          children: [Text('?')],
        ),
      );
    },
  );
}

//Todo: 명상
void showMeditationBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        child: Column(
          children: [Text('?')],
        ),
      );
    },
  );
}

//Todo: 수면 기록
void showSleepBottomSheet(BuildContext context, String title) {
  final TextEditingController _sleepMemoController = TextEditingController();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
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
                onPressed: () {
                  custom.showTimePicker(context);
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Text('오늘 몇 시에 일어났나요?', style: textTheme.bodyMedium),
              ),
              TimePickerButton(
                onPressed: () {
                  custom.showTimePicker(context);
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child:
                    Text('자고 일어난 후의 상태를 알려주세요.', style: textTheme.bodyMedium),
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
              ),
            ],
          ),
        ),
      );
    },
  );
}

//Todo: 감정 일기
void showDiaryBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return BaseAnimatedBottomSheetContent(
        title: title,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Text('몇 시쯤 잠자리에 들었나요?', style: textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//Todo: 취미 기록
void showHobbyBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      final TextEditingController _hobbyNameController = TextEditingController();
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return BaseAnimatedBottomSheetContent(
        title: title,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: TextField(
                  controller: _hobbyNameController,
                  decoration: InputDecoration(
                    hintText: '취미 선택',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: TEXT_GREY),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16), // 텍스트 필드 내부 패딩
                    filled: true,
                    fillColor: Colors.white, // 배경색
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리를 둥글게
                      borderSide: BorderSide(
                        color: Colors.black, // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                  readOnly: true, // 읽기 전용
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Text('오늘 몇 시에 일어났나요?', style: textTheme.bodyMedium),
              ),
              TimePickerButton(
                onPressed: () {
                  custom.showTimePicker(context);
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child:
                    Text('자고 일어난 후의 상태를 알려주세요.', style: textTheme.bodyMedium),
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
              // YellowTextFormField(
              //   controller: _sleepMemoController,
              //   maxLength: 50,
              //   // height: screenHeight * 0.06,
              //   height: screenHeight * 0.1,
              // ),
            ],
          ),
        ),
      );
    },
  );
}

//Todo: 기본 BottomSheet
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

//Todo: AnimatedContainer를 이용한 애니메이션 적용
class BaseAnimatedBottomSheetContent extends StatefulWidget {
  final String title;
  final Widget child;
  BaseAnimatedBottomSheetContent({
    required this.title,
    required this.child,
  });

  @override
  _BaseAnimatedBottomSheetContentState createState() =>
      _BaseAnimatedBottomSheetContentState();
}

class _BaseAnimatedBottomSheetContentState
    extends State<BaseAnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // 애니메이션 지속 시간
      reverseDuration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    _controller.dispose();
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
            child: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          height: screenHeight * 0.049,
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
                    widget.child,
                    Padding(
                      padding: EdgeInsets.all(screenHeight * 0.05),
                      child: GreenButton(
                        width: screenWidth * 0.6,
                        onPressed: () async {
                          await _controller.reverse(); // 애니메이션 역방향 실행
                          Navigator.pop(context); // 애니메이션 완료 후 BottomSheet 닫기
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
