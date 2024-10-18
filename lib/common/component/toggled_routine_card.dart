import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/const/colors.dart';

class ToggledRoutineCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;

  const ToggledRoutineCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description});

  @override
  State<ToggledRoutineCard> createState() => _ToggledRoutineCardState();
}

class _ToggledRoutineCardState extends State<ToggledRoutineCard> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSwitched ? 4 : 0,
      shadowColor: YELLOW_SHADOW,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: EdgeInsets.all(12),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSwitched ? Colors.white : LIGHT_GREY,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Stack(
          children: [
            // 이미지 중앙 배치
            _routineImage(imageUrl: widget.imageUrl),
            // 상단 왼쪽 물음표 버튼
            _questionMark(title: widget.title, description: widget.description),
            // 상단 오른쪽 토글 버튼
            _toggleSwitch(),
            // 하단 중앙 텍스트
            _routineTitle(title: widget.title),
          ],
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl}) {
    return Center(
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _questionMark({required String title,required String description}) {
    return Positioned(
      top: 2,
      left: 2,
      child: IconButton(
        onPressed: (){DialogManager.showAlertDialog(
          context: context,
          title: title,
          content:description,
        );},
        icon: Image.asset(
          "assets/icons/question_icon.png",
          width: 30,
        ),
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

  Widget _routineTitle({required String title}) {
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
}
