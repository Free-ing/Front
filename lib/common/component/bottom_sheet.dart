import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';

//Todo: 스트레칭
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


//Todo: 기본 BottomSheet
// void showCustomModalBottomSheet({
//   required BuildContext context,
//   required Widget Function(BuildContext, TextTheme) builder,
// }) {
//   final textTheme = Theme.of(context).textTheme;
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     barrierColor: Colors.black.withOpacity(0.3),
//     builder: (BuildContext context) {
//       return builder(context, textTheme);
//     },
//   );
// }

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context, TextTheme textTheme) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      final textTheme = Theme.of(context).textTheme;
      return builder(context, textTheme);
    },
  );
}

//Todo: AnimatedContainer를 이용한 애니메이션 적용
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
