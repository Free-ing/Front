import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/home_time_picker.dart' as custom;
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/const/colors.dart';

void showExerciseBottomSheet(BuildContext context, String title) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('?')],
        ),
      );
    },
  );
}

void showSleepBottomSheet(BuildContext context, String title) {
  final TextEditingController sleepTimeController = TextEditingController();
  final TextEditingController wakeUpTimeController = TextEditingController();
  final TextEditingController _sleepMemoController = TextEditingController();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                    controller: sleepTimeController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text('오늘 몇 시에 일어났나요?', style: textTheme.bodyMedium),
                  ),
                  TimePickerButton(
                    controller: wakeUpTimeController,
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
                          afterImage: 'assets/imgs/home/after_refreshed.png',
                          text: '개운해요'),
                      CustomClickedContainer(
                          beforeImage: 'assets/imgs/home/before_sore.png',
                          afterImage: 'assets/imgs/home/after_sore.png',
                          text: '뻐근해요'),
                      CustomClickedContainer(
                          beforeImage: 'assets/imgs/home/before_unrested.png',
                          afterImage: 'assets/imgs/home/after_unrested.png',
                          text: '잔 것 같지 않아요'),
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

// 수면 기록하기에서 클릭되는 효과!
class CustomClickedContainer extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final String text;

  CustomClickedContainer({
    required this.beforeImage,
    required this.afterImage,
    required this.text,
  });

  @override
  _CustomClickedContainerState createState() => _CustomClickedContainerState();
}

class _CustomClickedContainerState extends State<CustomClickedContainer> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
      },
      child: Container(
        width: screenWidth * 0.25,
        height: screenHeight * 0.13,
        decoration: BoxDecoration(
          color: isClicked ? Colors.white : Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isClicked ? Colors.black : Color(0xFF929292), width: 1),
          boxShadow: [
            BoxShadow(
              color: isClicked
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
                      color: isClicked
                          ? Color(0xFFFFD477).withOpacity(0.4)
                          : Colors.black.withOpacity(0.1),
                      offset: Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(
                  isClicked ? widget.afterImage : widget.beforeImage,
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
