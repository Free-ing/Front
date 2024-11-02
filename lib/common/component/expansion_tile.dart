import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

import '../../screen/home/diary_bottom_sheet.dart';
import '../../screen/home/meditation_bottom_sheet.dart';
import '../../screen/home/sleep_record_bottom_sheet.dart';
import 'bottom_sheet.dart';
import 'buttons.dart';

class HomeExpansionTileBox extends StatefulWidget {
  String text;
  //double width;
  List lists;
  HomeExpansionTileBox({Key? key, required this.text, required this.lists})
      : super(key: key);

  @override
  _HomeExpansionTileBoxState createState() => _HomeExpansionTileBoxState();
}

class _HomeExpansionTileBoxState extends State<HomeExpansionTileBox> {
  late List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    // 각 리스트 항목에 대한 초기 체크 상태를 false로 설정
    _isChecked = List<bool>.filled(widget.lists.length, false);
  }

  Widget listsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: widget.lists.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 14, fontFamily: 'scdream'),
                  ),
                ),
                SizedBox(width: 5.0),
                Text('11:00',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(item),
                // PlayButton(
                //     onPressed: () {
                //       showExerciseBottomSheet(context, '정적 스트레칭');
                //     },
                //     iconColor: PINK_PLAY_BUTTON),
                SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _isChecked[index] = !_isChecked[index];
                      });
                    },
                    child: Image.asset(_isChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getTextColor() {
    switch (widget.text) {
      case '운동':
        return HOME_PINK_TEXT; // 운동 색상 설정
      case '수면':
        return HOME_BLUE_TEXT; // 수면 색상 설정
      case '마음 채우기':
        return HOME_GREEN_TEXT; // 마음 채우기 색상 설정
      default:
        return Colors.black; // 기본 색상 설정
    }
  }

  Widget getPerformanceButton(String item) {
    switch (item) {
      case '정적 스트레칭':
        return PlayButton(
            onPressed: () {
              // TODO: 정적 스트레칭 bottom sheet로 바꾸기
              showExerciseBottomSheet(context, '정적 스트레칭');
            },
            iconColor: PINK_PLAY_BUTTON);
      case '동적 스트레칭':
        return PlayButton(
            onPressed: () {
              // TODO: 동적 스트레칭 bottom sheet로 바꾸기
              showExerciseBottomSheet(context, '동적 스트레칭');
            },
            iconColor: PINK_PLAY_BUTTON);
      case '명상하기':
        return PlayButton(
            onPressed: () {
              showMeditationBottomSheet(context, '명상하기');
            },
            iconColor: GREEN_PLAY_BUTTON);
      case '수면 기록하기':
        return LogButton(
          onPressed: () {
            showSleepBottomSheet(context, '어젯밤, 잘 잤나요?');
          },
        );
      case '감정일기 작성':
        return LogButton(
          onPressed: () {
            showDiaryBottomSheet(context, '오늘 하루 어땠나요?', DateTime.now());
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          color: LIGHT_IVORY,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black)),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            listTileTheme: ListTileTheme.of(context)
                .copyWith(dense: true, minTileHeight: screenHeight * 0.03)),
        child: ExpansionTile(
          iconColor: Colors.black,
          tilePadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 0.0),
          childrenPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: 16.0,
                  color: getTextColor(),
                  fontWeight: FontWeight.w600),
            ),
          ),
          children: <Widget>[
            //Divider(thickness: 1, color: Colors.black,),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(top: BorderSide(color: Colors.black, width: 1.0)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: listsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
