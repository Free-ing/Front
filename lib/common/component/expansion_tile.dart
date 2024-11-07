import 'package:flutter/material.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/home_api_service.dart';
import 'package:freeing/model/home/exercise_daily_routine.dart';
import 'package:freeing/model/home/sleep_daily_routine.dart';
import 'package:freeing/model/home/spirit_daily_routine.dart';
import 'package:freeing/screen/home/dynamic_stretching_bottom_sheet.dart';
import 'package:freeing/screen/home/static_stretching_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../screen/home/diary_bottom_sheet.dart';
import '../../screen/home/meditation_bottom_sheet.dart';
import '../../screen/home/sleep_record_bottom_sheet.dart';
import 'buttons.dart';

class HomeExpansionTileBox extends StatefulWidget {
  String text;
  final List<SleepDailyRoutine> sleepDailyRoutines;
  final List<SpiritRoutineDetail> spiritDailyRoutines;
  final List<ExerciseRoutineDetail> exerciseDailyRoutines;
  String completeDay;

  HomeExpansionTileBox({
    Key? key,
    required this.text,
    this.sleepDailyRoutines = const [],
    this.spiritDailyRoutines = const [],
    this.exerciseDailyRoutines = const [],
    required this.completeDay,
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
  final homeApiService = HomeApiService();

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

  void _initializeCheckLists() {
    _isSleepChecked = widget.sleepDailyRoutines.isNotEmpty
        ? widget.sleepDailyRoutines
            .map((routine) => routine.completed ?? false)
            .toList()
        : [];
    _isSleepVisible = _isSleepChecked.isNotEmpty
        ? _isSleepChecked.map((checked) => !checked).toList()
        : [];


    _isExerciseChecked = widget.exerciseDailyRoutines.isNotEmpty
        ? widget.exerciseDailyRoutines
            .map((routine) => routine.complete ?? false)
            .toList()
        : [];
    _isExerciseVisible = _isExerciseChecked.isNotEmpty
        ? _isExerciseChecked.map((checked) => !checked).toList()
        : [];


    _isSpiritChecked = widget.spiritDailyRoutines.isNotEmpty
        ? widget.spiritDailyRoutines
            .map((routine) => routine.complete ?? false)
            .toList()
        : [];
    _isSpiritVisible = _isSpiritChecked.isNotEmpty
        ? _isSpiritChecked.map((checked) => !checked).toList()
        : [];



  }

  Widget listsWidget() {
    List<Widget> tiles = [];

    switch (widget.text) {
      case '운동':
        if (widget.exerciseDailyRoutines.isEmpty) {
          return const Center(child: SizedBox.shrink());
        }
        tiles = widget.exerciseDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          ExerciseRoutineDetail exerciseRoutine = entry.value;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exerciseRoutine.name!,
                  style: const TextStyle(fontSize: 14, fontFamily: 'scdream'),
                ),
                const SizedBox(width: 5.0),
                Text(getTime('운동', index),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                const SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      if(index < _isExerciseChecked.length){
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(index < _isExerciseChecked.length && _isExerciseChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList();
        break;
      case '수면':
        if (widget.sleepDailyRoutines.isEmpty) {
          return const Center(child: SizedBox.shrink());
        }
        tiles = widget.sleepDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          SleepDailyRoutine sleepRoutine = entry.value;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sleepRoutine.sleepRoutineName!,
                  style: const TextStyle(fontSize: 14, fontFamily: 'scdream')),
                const SizedBox(width: 5.0),
                Text(getTime('수면', index),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                const SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      if(index < _isSleepChecked.length){
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(index < _isSleepChecked.length && _isSleepChecked[index]
                        ? 'assets/icons/after_checkbox.png'
                        : 'assets/icons/before_checkbox.png')),
              ],
            ),
          );
        }).toList();
        break;
      case '마음 채우기':
        if (widget.spiritDailyRoutines.isEmpty) {
          return const Center(child: SizedBox.shrink());
        }
        tiles = widget.spiritDailyRoutines.asMap().entries.map((entry) {
          int index = entry.key;
          SpiritRoutineDetail spiritRoutine = entry.value;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            minLeadingWidth: 0.0,
            leading: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spiritRoutine.name!,
                  style: const TextStyle(fontSize: 14, fontFamily: 'scdream'),
                ),
                const SizedBox(width: 5.0),
                Text(getTime('마음 채우기', index),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: TEXT_PURPLE))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getPerformanceButton(widget.text, index),
                const SizedBox(width: 15.0),
                GestureDetector(
                    onTap: () {
                      if(index < _isSpiritChecked.length){
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(index < _isSpiritChecked.length && _isSpiritChecked[index]
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
    if (routine == null) return const SizedBox.shrink();

    switch(widget.text){
      case '운동':
        return Visibility(
          visible: _isExerciseVisible[index],
          child: _buildButton(routine.name, index),
        );
      case '수면':
        return Visibility(
          visible: _isSleepVisible[index],
          child: _buildButton(routine.sleepRoutineName, index),
        );
      case '마음 채우기':
        return Visibility(
          visible: _isSpiritVisible[index],
          child: _buildButton(routine.name, index),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildButton(String routineName, int index) {
    switch (routineName) {
      case '정적 스트레칭':
        return PlayButton(
            onPressed: () async {
              bool success = await showStaticStretchingBottomSheet(context, '정적 스트레칭');
              if(success){
                _handleCheckboxTap(index);
              }
            },
            iconColor: PINK_PLAY_BUTTON);
      case '동적 스트레칭':
        return PlayButton(
            onPressed: () async {
              bool success = await showDynamicStretchingBottomSheet(context, '동적 스트레칭');
              if(success){
                _handleCheckboxTap(index);
              }
            },
            iconColor: PINK_PLAY_BUTTON);
      case '명상하기':
        return PlayButton(
            onPressed: () async {
              bool success = await showMeditationBottomSheet(context, '명상하기');
              if (success) {
                _handleCheckboxTap(index);
              }
            },
            iconColor: GREEN_PLAY_BUTTON);
      case '수면 기록하기':
        return LogButton(
          onPressed: () async {
            bool success = await showSleepBottomSheet(context, '어젯밤, 잘 잤나요?');
            if (success) {
              _handleCheckboxTap(index);
            }
          },
        );
      case '감정일기 작성':
        return LogButton(
          onPressed: () async {
            bool success = await showDiaryBottomSheet(
                context, '오늘 하루 어땠나요?', DateTime.now(), widget.spiritDailyRoutines[index].recordId! );
            print('감정일기 sucess값은!!!!!!  $success');
            if (success) {
              print('감정일기 작성 성공적');
              _handleCheckboxTap(index);
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // void _handleCheckboxTap(int index) async {
  //   SleepDailyRoutine sleepRoutine = widget.sleepDailyRoutines[index];
  //   ExerciseRoutineDetail exerciseRoutine = widget.exerciseDailyRoutines[index];
  //   SpiritRoutineDetail spiritRoutine = widget.spiritDailyRoutines[index];
  //
  //   bool newStatus = !_isSleepChecked[index];
  //   bool success = false;
  //
  //
  //   try {
  //     switch (widget.text) {
  //       case '수면':
  //         // TODO: 수면 루틴 완료 상태 업데이트 요청
  //         success = await homeApiService.checkSleepRoutine(newStatus, widget.completeDay, sleepRoutine.sleepRoutineId);
  //         break;
  //       case '운동':
  //         // TODO: 운동 루틴 완료 상태 업데이트 요청
  //         //success = await apiService.markExerciseRoutineCompleted(routine.sleepRoutineId, newStatus);
  //         break;
  //       case '마음 채우기':
  //         // TODO: 마음 채우기 루틴 완료 상태 업데이트 요청
  //         //success = await apiService.markSpiritRoutineCompleted(routine.sleepRoutineId, newStatus);
  //         break;
  //       default:
  //         // 다른 경우 처리
  //         break;
  //     }
  //
  //     if (success) {
  //       setState(() {
  //         _isSleepChecked[index] = newStatus;
  //         if (newStatus) {
  //           _isSleepVisible[index] = false;
  //         }
  //       });
  //     } else {
  //       // 서버 요청 실패 시 사용자에게 알림
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('루틴 상태 업데이트에 실패했습니다.')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error updating routine status: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('루틴 상태 업데이트 중 오류가 발생했습니다.')),
  //     );
  //   }
  // }

  void _handleCheckboxTap(int index) async {
    bool newStatus = false;
    bool success = false;

    try {
      switch (widget.text) {
        case '수면':
          if (index < _isSleepChecked.length && index < widget.sleepDailyRoutines.length) {
            SleepDailyRoutine sleepRoutine = widget.sleepDailyRoutines[index];
            newStatus = !_isSleepChecked[index];
            success = await homeApiService.checkSleepRoutine(newStatus, widget.completeDay, sleepRoutine.sleepRoutineId);
            if (success && mounted) {
              setState(() {
                _isSleepChecked[index] = newStatus;
                _isSleepVisible[index] = !newStatus;
              });
            }
          }
          break;
        case '운동':
          if (index < _isExerciseChecked.length && index < widget.exerciseDailyRoutines.length) {
            print('운동 루틴 체크 안!!!!!');
            ExerciseRoutineDetail exerciseRoutine = widget.exerciseDailyRoutines[index];
            newStatus = !_isExerciseChecked[index];
            success = await homeApiService.checkExerciseRoutine(newStatus, exerciseRoutine.recordId);
            if (success && mounted) {
              setState(() {
                print('운동 루틴 체크 성공적');
                _isExerciseChecked[index] = newStatus;
                _isExerciseVisible[index] = !newStatus;
              });
            }
          }
          break;
        case '마음 채우기':
          if (index < _isSpiritChecked.length && index < widget.spiritDailyRoutines.length) {
            //print('마음 채우기 루틴 체크 안!!!!!');
            SpiritRoutineDetail spiritRoutine = widget.spiritDailyRoutines[index];
            newStatus = !_isSpiritChecked[index];
            success = await homeApiService.checkSpiritRoutine(newStatus, spiritRoutine.recordId);
            if (success && mounted) {
              setState(() {
                //print('마음 채우기 루틴 체크 성공적');
                _isSpiritChecked[index] = newStatus;
                _isSpiritVisible[index] = !newStatus;
              });
            }
          }
          break;
        default:
          break;
      }
      if (!success) {
        // 서버 요청 실패 시 사용자에게 알림
        const ToastBarWidget(
          title: '루틴 상태 업데이트에 실패했습니다.',
        ).showToast(context);
      }
    } catch (e) {
      print('Error updating routine status: $e');
      const ToastBarWidget(
        title: '루틴 상태 업데이트 중 오류가 발생했습니다.',
      ).showToast(context);
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
          borderRadius: const BorderRadius.all(Radius.circular(15)),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: widget.text == '운동' && widget.exerciseDailyRoutines.isNotEmpty ||
                      widget.text == '수면' && widget.sleepDailyRoutines.isNotEmpty ||
                      widget.text == '마음 채우기' && widget.spiritDailyRoutines.isNotEmpty
                      ? const Border(top: BorderSide(color: Colors.black, width: 1.0))
                      : const Border(),
                  borderRadius: const BorderRadius.only(
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


