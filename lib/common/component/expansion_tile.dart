import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/model/home/exercise_daily_routine.dart';
import 'package:freeing/model/home/sleep_daily_routine.dart';
import 'package:freeing/model/home/spirit_daily_routine.dart';
import 'package:freeing/screen/home/dynamic_stretching_bottom_sheet.dart';
import 'package:freeing/screen/home/static_stretching_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../screen/home/diary_bottom_sheet.dart';
import '../../screen/home/meditation_bottom_sheet.dart';
import '../../screen/home/sleep_record_bottom_sheet.dart';
import 'bottom_sheet.dart';
import 'buttons.dart';

class HomeExpansionTileBox extends StatefulWidget {
  String text;
  //List lists;
  final List<SleepDailyRoutine> sleepDailyRoutines;
  final List<SpiritRoutineDetail> spiritDailyRoutines;
  final List<ExerciseRoutineDetail> exerciseDailyRoutines;
  HomeExpansionTileBox({
    Key? key,
    required this.text,
    this.sleepDailyRoutines = const [],
    this.spiritDailyRoutines = const [],
    this.exerciseDailyRoutines = const [],
  }) : super(key: key);

  @override
  _HomeExpansionTileBoxState createState() => _HomeExpansionTileBoxState();
}

class _HomeExpansionTileBoxState extends State<HomeExpansionTileBox> {
  late List<bool> _isSleepChecked;
  late List<bool> _isSleepVisible;
  late List<bool> _isExerciseChecked;
  late List<bool> _isExerciseVisible;
  late List<bool> _isSpiritChecked;
  late List<bool> _isSpiritVisible;

  @override
  void initState() {
    super.initState();
    _initializeCheckLists();
  }

  @override
  void didUpdateWidget(covariant HomeExpansionTileBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sleepDailyRoutines != widget.sleepDailyRoutines ||
        oldWidget.exerciseDailyRoutines != widget.exerciseDailyRoutines ||
        oldWidget.spiritDailyRoutines != widget.spiritDailyRoutines) {
      _initializeCheckLists();
    }
  }

  // TODO: 각 리스트 항목에 대한 초기 체크 상태를 false로 되어있는데 받아와야함!!!
  void _initializeCheckLists() {
    _isSleepChecked = widget.sleepDailyRoutines.isNotEmpty
        ? widget.sleepDailyRoutines
            .map((routine) => routine.completed ?? false)
            .toList()
        : [];
    _isSleepVisible = widget.sleepDailyRoutines.isNotEmpty
        ? List<bool>.filled(widget.sleepDailyRoutines.length, true)
        : [];

    _isExerciseChecked = widget.exerciseDailyRoutines.isNotEmpty
        ? widget.exerciseDailyRoutines
            .map((routine) => routine.complete ?? false)
            .toList()
        : [];
    _isExerciseVisible = widget.exerciseDailyRoutines.isNotEmpty
        ? List<bool>.filled(widget.exerciseDailyRoutines.length, true)
        : [];

    _isSpiritChecked = widget.spiritDailyRoutines.isNotEmpty
        ? widget.spiritDailyRoutines
            .map((routine) => routine.complete ?? false)
            .toList()
        : [];
    _isSpiritVisible = widget.spiritDailyRoutines.isNotEmpty
        ? List<bool>.filled(widget.spiritDailyRoutines.length, true)
        : [];
  }

  Widget listsWidget() {
    List<Widget> tiles = [];

    switch (widget.text) {
      case '운동':
        if (widget.exerciseDailyRoutines.isEmpty) {
          return Center(child: SizedBox.shrink());
        }
        tiles = widget.exerciseDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          ExerciseRoutineDetail exerciseRoutine = entry.value;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exerciseRoutine.name!,
                  style: TextStyle(fontSize: 14, fontFamily: 'scdream'),
                ),
                SizedBox(width: 5.0),
                Text(getTime('운동', index),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _handleCheckboxTap(index);
                      });
                    },
                    child: Image.asset(_isSleepChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList();
        break;
      case '수면':
        if (widget.sleepDailyRoutines.isEmpty) {
          return Center(child: SizedBox.shrink());
        }
        tiles = widget.sleepDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          SleepDailyRoutine sleepRoutine = entry.value;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sleepRoutine.sleepRoutineName!,
                  style: TextStyle(fontSize: 14, fontFamily: 'scdream')),
                SizedBox(width: 5.0),
                Text(getTime('수면', index),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _handleCheckboxTap(index);
                      });
                    },
                    child: Image.asset(_isSleepChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList();
        break;
      case '마음 채우기':
        if (widget.spiritDailyRoutines.isEmpty) {
          return Center(child: SizedBox.shrink());
        }
        tiles = widget.spiritDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          SpiritRoutineDetail spiritRoutine = entry.value;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spiritRoutine.name!,
                  style: TextStyle(fontSize: 14, fontFamily: 'scdream'),
                ),
                SizedBox(width: 5.0),
                Text(getTime('마음 채우기', index),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _handleCheckboxTap(index);
                      });
                    },
                    child: Image.asset(_isSleepChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList();
        break;
    }

    return Column(children: tiles);
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

  dynamic getRoutine(String text, int index) {
    switch (text) {
      case '운동':
      return widget.exerciseDailyRoutines.isNotEmpty ? widget.exerciseDailyRoutines[index] : null;
      case '수면':
        return widget.sleepDailyRoutines.isNotEmpty ? widget.sleepDailyRoutines[index] : null;
      case '마음 채우기':
        return widget.spiritDailyRoutines.isNotEmpty ? widget.spiritDailyRoutines[index] : null;
      default:
        return null;
    }
  }

  String getTime(String text, int index) {
    final routine = getRoutine(text, index);

    if (routine == null) return '';

    if (routine.startTime != null && routine.endTime != null) {
      return '${DateFormat('HH:mm').format(routine.startTime!)} - ${DateFormat('HH:mm').format(routine.endTime!)}';
    } else if (routine.startTime != null) {
      return '${DateFormat('HH:mm').format(routine.startTime!)} -';
    } else if (routine.endTime != null) {
      return '- ${DateFormat('HH:mm').format(routine.endTime!)}';
    } else {
      return '';
    }
  }

  Widget getPerformanceButton(String text, int index) {
    final routine = getRoutine(text, index);
    if (routine == null) return SizedBox.shrink();

    switch(widget.text){
      case '운동':
        return Visibility(
          visible: _isExerciseVisible[index],
          child: _buildButton(routine, index),
        );
      case '수면':
        return Visibility(
          visible: _isSleepVisible[index],
          child: _buildButton(routine, index),
        );
      case '마음 채우기':
        return Visibility(
          visible: _isSpiritVisible[index],
          child: _buildButton(routine, index),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildButton(SleepDailyRoutine routine, int index) {
    switch (routine.sleepRoutineName) {
      case '정적 스트레칭':
        return PlayButton(
            onPressed: () {
              // TODO: 정적 스트레칭 bottom sheet로 바꾸기
              showStaticStretchingBottomSheet(context, '정적 스트레칭');
            },
            iconColor: PINK_PLAY_BUTTON);
      case '동적 스트레칭':
        return PlayButton(
            onPressed: () {
              // TODO: 동적 스트레칭 bottom sheet로 바꾸기
              showDynamicStretchingBottomSheet(context, '동적 스트레칭');
            },
            iconColor: PINK_PLAY_BUTTON);
      case '명상하기':
        return PlayButton(
            onPressed: () async {
              bool success = await showMeditationBottomSheet(context, '명상하기');
              if (success) {
                setState(() {
                  print('명상하기 성공적!!!!!');
                  _isSleepChecked[index] = true;
                  _isSleepVisible[index] = false;
                });
              }
            },
            iconColor: GREEN_PLAY_BUTTON);
      case '수면 기록하기':
        return LogButton(
          onPressed: () async {
            bool success = await showSleepBottomSheet(context, '어젯밤, 잘 잤나요?');
            if (success) {
              setState(() {
                print('sleep bottom sheet 성공적!!!!!');
                _isSleepChecked[index] = true;
                _isSleepVisible[index] = false;
              });
            }
          },
        );
      case '감정일기 작성':
        return LogButton(
          onPressed: () async {
            bool success = await showDiaryBottomSheet(
                context, '오늘 하루 어땠나요?', DateTime.now());
            print('sucess값은!!!!!!  $success');
            if (success) {
              print('감정일기 작성 성공적');
              _isSleepChecked[index] = true;
              _isSleepVisible[index] = false;
            }
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  void _handleCheckboxTap(int index) async {
    SleepDailyRoutine routine = widget.sleepDailyRoutines[index];
    bool newStatus = !_isSleepChecked[index];
    bool success = false;

    try {
      switch (widget.text) {
        case '수면':
          // TODO: 수면 루틴 완료 상태 업데이트 요청
          //success = await apiService.markSleepRoutineCompleted(routine.sleepRoutineId, newStatus);
          break;
        case '운동':
          // TODO: 운동 루틴 완료 상태 업데이트 요청
          //success = await apiService.markExerciseRoutineCompleted(routine.sleepRoutineId, newStatus);
          break;
        case '마음 채우기':
          // TODO: 마음 채우기 루틴 완료 상태 업데이트 요청
          //success = await apiService.markSpiritRoutineCompleted(routine.sleepRoutineId, newStatus);
          break;
        default:
          // 다른 경우 처리
          break;
      }

      if (success) {
        setState(() {
          _isSleepChecked[index] = newStatus;
          if (newStatus) {
            _isSleepVisible[index] = false;
          }
        });
      } else {
        // 서버 요청 실패 시 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('루틴 상태 업데이트에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('Error updating routine status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('루틴 상태 업데이트 중 오류가 발생했습니다.')),
      );
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
          initiallyExpanded: true,
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
              decoration: const BoxDecoration(
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


