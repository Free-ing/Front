import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/custom_circular_progress_indicator.dart';
import 'package:freeing/common/component/loading.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/home_api_service.dart';
import 'package:freeing/model/home/exercise_daily_routine.dart';
import 'package:freeing/model/home/sleep_daily_routine.dart';
import 'package:freeing/model/home/spirit_daily_routine.dart';
import 'package:freeing/screen/home/dynamic_stretching_bottom_sheet.dart';
import 'package:freeing/screen/home/static_stretching_bottom_sheet.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';
import 'package:intl/intl.dart';

import '../../screen/home/diary_bottom_sheet.dart';
import '../../screen/home/meditation_bottom_sheet.dart';
import '../../screen/home/sleep_record_bottom_sheet.dart';
import 'buttons.dart';

class HomeExpansionTileBox extends StatefulWidget {
  final bool sleepRecordCompleted;
  String text;
  final List<SleepDailyRoutine> sleepDailyRoutines;
  final List<SpiritRoutineDetail> spiritDailyRoutines;
  final List<ExerciseRoutineDetail> exerciseDailyRoutines;
  String completeDay;

  HomeExpansionTileBox({
    Key? key,
    this.sleepRecordCompleted = false,
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
  Offset? _tapPosition;
  bool _isLoading = true;

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

  Future<void> _initializeCheckLists() async {
    setState(() => _isLoading = true);

    _isSleepChecked = [];
    _isSleepVisible = [];

    for (var routine in widget.sleepDailyRoutines) {
      if (routine.sleepRoutineName == '수면 기록하기') {
        // Fetch the sleep record if it's "수면 기록하기"
        final response = await homeApiService.getSleepTimeRecord(widget.completeDay);
        //bool completed = sleepRecord['completed'] ?? false;


        if (response.statusCode == 200) {
          final sleepRecord = json.decode(response.body); // JSON 형식으로 변환
          //print('수면 기록 출력!!!! $sleepRecord');

          // completed 값을 할당
          bool completed = sleepRecord['completed'];
          _isSleepChecked.add(completed);
          _isSleepVisible.add(!completed);

        } else {
          print("Error: Failed to load sleep record. Status code: ${response.statusCode}");
        }

      } else {
        _isSleepChecked.add(routine.completed ?? false);
        _isSleepVisible.add(!(routine.completed ?? false));
      }
    }

    _isExerciseChecked = widget.exerciseDailyRoutines
        .map((routine) => routine.complete ?? false)
        .toList();
    _isExerciseVisible = _isExerciseChecked.map((checked) => !checked).toList();

    _isSpiritChecked = widget.spiritDailyRoutines
        .map((routine) => routine.complete ?? false)
        .toList();
    _isSpiritVisible = _isSpiritChecked.map((checked) => !checked).toList();

    setState(() => _isLoading = false); // Update the state once initialization is complete
  }

  // void _initializeCheckLists() {
  //   _isSleepChecked = widget.sleepDailyRoutines.isNotEmpty
  //       ? widget.sleepDailyRoutines
  //           .map((routine) => routine.completed ?? false)
  //           .toList()
  //       : [];
  //   _isSleepVisible = _isSleepChecked.isNotEmpty
  //       ? _isSleepChecked.map((checked) => !checked).toList()
  //       : [];
  //
  //   _isExerciseChecked = widget.exerciseDailyRoutines.isNotEmpty
  //       ? widget.exerciseDailyRoutines
  //           .map((routine) => routine.complete ?? false)
  //           .toList()
  //       : [];
  //   _isExerciseVisible = _isExerciseChecked.isNotEmpty
  //       ? _isExerciseChecked.map((checked) => !checked).toList()
  //       : [];
  //
  //   _isSpiritChecked = widget.spiritDailyRoutines.isNotEmpty
  //       ? widget.spiritDailyRoutines
  //           .map((routine) => routine.complete ?? false)
  //           .toList()
  //       : [];
  //   _isSpiritVisible = _isSpiritChecked.isNotEmpty
  //       ? _isSpiritChecked.map((checked) => !checked).toList()
  //       : [];
  // }

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
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _tapPosition = details.globalPosition;
                  },
                  onLongPress: () {
                    if (_tapPosition != null) {
                      showExercisePopUpMenu(
                          context, _tapPosition!, exerciseRoutine);
                    }
                  },
                  child: Text(
                    exerciseRoutine.name!,
                    style: const TextStyle(fontSize: 14, fontFamily: 'scdream'),
                  ),
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
                      if (index < _isExerciseChecked.length) {
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(index < _isExerciseChecked.length &&
                            _isExerciseChecked[index]
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
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _tapPosition = details.globalPosition;
                  },
                  onLongPress: () {
                    if (_tapPosition != null) {
                      showSleepPopUpMenu(context, _tapPosition!, sleepRoutine);
                    }
                  },
                  child: Text(sleepRoutine.sleepRoutineName!,
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'scdream')),
                ),
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
                      if (index < _isSleepChecked.length) {
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(
                        index < _isSleepChecked.length && _isSleepChecked[index]
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
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _tapPosition = details.globalPosition;
                  },
                  onLongPress: () {
                    if (_tapPosition != null) {
                      showSpiritPopUpMenu(
                          context, _tapPosition!, spiritRoutine);
                    }
                  },
                  child: Text(
                    spiritRoutine.name!,
                    style: const TextStyle(fontSize: 14, fontFamily: 'scdream'),
                  ),
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
                      if (index < _isSpiritChecked.length) {
                        setState(() {
                          _handleCheckboxTap(index);
                        });
                      }
                    },
                    child: Image.asset(index < _isSpiritChecked.length &&
                            _isSpiritChecked[index]
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

  void showExercisePopUpMenu(BuildContext context, Offset position,
      ExerciseRoutineDetail exerciseRoutine) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.of(context).size.width - position.dx,
        MediaQuery.of(context).size.height - position.dy,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'rest',
          height: 2.5,
          child: Container(
            width: 115,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_rest.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '오늘은 쉬어가기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        //const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 0.5,
          child: Container(
            margin: EdgeInsets.zero,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'explain',
          height: 2.5,
          child: Container(
            width: 110,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_explain.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '설명 보기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        //const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 0.5,
          child: Container(
            margin: EdgeInsets.zero,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          height: 2.5,
          child: Container(
            width: 110,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_edit.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black, width: 1), // 검정 테두리
      ),
    ).then((value) async {
      // Handle the selection of the popup menu item
      if (value != null) {
        switch (value) {
          case 'rest':
            //print('${exerciseRoutine.name} 루틴은 오늘 쉬어가기');
            // 운동 오늘 쉬어가기 서버 요청
            final response = await homeApiService.restExerciseRoutine(exerciseRoutine.recordId!);
            if(response.statusCode == 200){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                const ToastBarWidget(
                  title: '다음에는 꼭 지켜보세요.',
                ).showToast(context);
              });
              setState(() {
                widget.exerciseDailyRoutines.remove(exerciseRoutine);
              });
            } else{
              print(response.statusCode);
            }
            break;
          case 'explain':
            print('${exerciseRoutine.name} 설명 보기');
            DialogManager.showAlertDialog(
                context: context,
                title: exerciseRoutine.name!,
                content: exerciseRoutine.explanation!);
            break;
          case 'edit':
            print('${exerciseRoutine.name} 수정 하기');

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                    routineId: exerciseRoutine.routineId!,
                    title: exerciseRoutine.name!,
                    selectImage: exerciseRoutine.imageUrl!,
                    monday: exerciseRoutine.monday,
                    tuesday: exerciseRoutine.tuesday,
                    wednesday: exerciseRoutine.wednesday,
                    thursday: exerciseRoutine.thursday,
                    friday: exerciseRoutine.friday,
                    saturday: exerciseRoutine.saturday,
                    sunday: exerciseRoutine.sunday,
                    startTime: exerciseRoutine.startTime,
                    endTime: exerciseRoutine.endTime,
                    explanation: exerciseRoutine.explanation,
                    status: exerciseRoutine.status,
                    category: '운동')));
            break;
        }
      }
    });
  }

  void showSleepPopUpMenu(
      BuildContext context, Offset position, SleepDailyRoutine sleepRoutine) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.of(context).size.width - position.dx,
        MediaQuery.of(context).size.height - position.dy,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'rest',
          height: 2.5,
          child: Container(
            width: 115,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_rest.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '오늘은 쉬어가기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        //const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 0.5,
          child: Container(
            margin: EdgeInsets.zero,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          height: 2.5,
          child: Container(
            width: 110,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_edit.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black, width: 1), // 검정 테두리
      ),
    ).then((value) async{
      // Handle the selection of the popup menu item
      if (value != null) {
        switch (value) {
          case 'rest':
            //print('${sleepRoutine.sleepRoutineName} 루틴은 오늘 쉬어가기');
            // 수면 오늘 쉬어가기 서버 요청
            final response = await homeApiService.restSleepRoutine(widget.completeDay, sleepRoutine.sleepRoutineId!);
            if(response.statusCode == 201){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                const ToastBarWidget(
                  title: '다음에는 꼭 지켜보세요.',
                ).showToast(context);
              });
              setState(() {
                widget.sleepDailyRoutines.remove(sleepRoutine);
              });
            }
            break;
          case 'edit':
            print('${sleepRoutine.sleepRoutineName} 수정 하기');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                    routineId: sleepRoutine.sleepRoutineId!,
                    title: sleepRoutine.sleepRoutineName!,
                    selectImage: sleepRoutine.url!,
                    monday: sleepRoutine.monday,
                    tuesday: sleepRoutine.tuesday,
                    wednesday: sleepRoutine.wednesday,
                    thursday: sleepRoutine.thursday,
                    friday: sleepRoutine.friday,
                    saturday: sleepRoutine.saturday,
                    sunday: sleepRoutine.sunday,
                    startTime: sleepRoutine.startTime,
                    endTime: sleepRoutine.endTime,
                    status: sleepRoutine.status,
                    category: '수면')));
            break;
        }
      }
    });
  }

  void showSpiritPopUpMenu(BuildContext context, Offset position,
      SpiritRoutineDetail spiritRoutine) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.of(context).size.width - position.dx,
        MediaQuery.of(context).size.height - position.dy,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'rest',
          height: 2.5,
          child: Container(
            width: 115,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_rest.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '오늘은 쉬어가기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        //const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 0.5,
          child: Container(
            margin: EdgeInsets.zero,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'explain',
          height: 2.5,
          child: Container(
            width: 110,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_explain.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '설명 보기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        //const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 0.5,
          child: Container(
            margin: EdgeInsets.zero,
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          height: 2.5,
          child: Container(
            width: 110,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/home_edit.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black, width: 1), // 검정 테두리
      ),
    ).then((value) async{
      // Handle the selection of the popup menu item
      if (value != null) {
        switch (value) {
          case 'rest':
            //print('${spiritRoutine.name} 루틴은 오늘 쉬어가기');
            // 마음 채우기 오늘 쉬어가기 서버 요청
            final response = await homeApiService.restSpiritRoutine(spiritRoutine.recordId!);
            if(response.statusCode == 200){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                const ToastBarWidget(
                  title: '다음에는 꼭 지켜보세요.',
                ).showToast(context);
              });
              setState(() {
                widget.spiritDailyRoutines.remove(spiritRoutine);
              });
            } else{
              print(response.statusCode);
            }
            break;
          case 'explain':
            print('${spiritRoutine.name} 설명 보기');
            DialogManager.showAlertDialog(
                context: context,
                title: spiritRoutine.name!,
                content: spiritRoutine.explanation!);
            break;
          case 'edit':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                    routineId: spiritRoutine.routineId!,
                    title: spiritRoutine.name!,
                    selectImage: spiritRoutine.imageUrl!,
                    monday: spiritRoutine.monday,
                    tuesday: spiritRoutine.tuesday,
                    wednesday: spiritRoutine.wednesday,
                    thursday: spiritRoutine.thursday,
                    friday: spiritRoutine.friday,
                    saturday: spiritRoutine.saturday,
                    sunday: spiritRoutine.sunday,
                    startTime: spiritRoutine.startTime,
                    endTime: spiritRoutine.endTime,
                    explanation: spiritRoutine.explanation,
                    status: spiritRoutine.status,
                    category: '마음 채우기')));
            break;
        }
      }
    });
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
        return widget.exerciseDailyRoutines.isNotEmpty
            ? widget.exerciseDailyRoutines[index]
            : null;
      case '수면':
        return widget.sleepDailyRoutines.isNotEmpty
            ? widget.sleepDailyRoutines[index]
            : null;
      case '마음 채우기':
        return widget.spiritDailyRoutines.isNotEmpty
            ? widget.spiritDailyRoutines[index]
            : null;
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

    switch (widget.text) {
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
              bool success =
                  await showStaticStretchingBottomSheet(context, '정적 스트레칭');
              if (success) {
                _handleCheckboxTap(index);
              }
            },
            iconColor: PINK_PLAY_BUTTON);
      case '동적 스트레칭':
        return PlayButton(
            onPressed: () async {
              bool success =
                  await showDynamicStretchingBottomSheet(context, '동적 스트레칭');
              if (success) {
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
            bool success = await showSleepBottomSheet(context, '어젯밤, 잘 잤나요?', widget.completeDay);
            if (success) {
              _handleCheckboxTap(index);
            }
          },
        );
      case '감정일기 작성':
        return LogButton(
          onPressed: () async {
            bool success = await showDiaryBottomSheet(
              context: context,
              title: '오늘 하루 어땠나요?',
              selectedDate: DateTime.now(),
              recordId: widget.spiritDailyRoutines[index].recordId!,
            );
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
  //         //  수면 루틴 완료 상태 업데이트 요청
  //         success = await homeApiService.checkSleepRoutine(newStatus, widget.completeDay, sleepRoutine.sleepRoutineId);
  //         break;
  //       case '운동':
  //         //  운동 루틴 완료 상태 업데이트 요청
  //         //success = await apiService.markExerciseRoutineCompleted(routine.sleepRoutineId, newStatus);
  //         break;
  //       case '마음 채우기':
  //         //  마음 채우기 루틴 완료 상태 업데이트 요청
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
          if (index < _isSleepChecked.length &&
              index < widget.sleepDailyRoutines.length) {
            SleepDailyRoutine sleepRoutine = widget.sleepDailyRoutines[index];
            newStatus = !_isSleepChecked[index];
            if(widget.sleepDailyRoutines[index].sleepRoutineName == '수면 기록하기'){
              setState(() {
                _isSleepChecked[index] = newStatus;
                _isSleepVisible[index] = !newStatus;
              });
            } else {
              success = await homeApiService.checkSleepRoutine(
                  newStatus, widget.completeDay, sleepRoutine.sleepRoutineId);
              if (success && mounted) {
                setState(() {
                  _isSleepChecked[index] = newStatus;
                  _isSleepVisible[index] = !newStatus;
                });
              }
            }
          }
          break;
        case '운동':
          if (index < _isExerciseChecked.length &&
              index < widget.exerciseDailyRoutines.length) {
            print('운동 루틴 체크 안!!!!!');
            ExerciseRoutineDetail exerciseRoutine =
                widget.exerciseDailyRoutines[index];
            newStatus = !_isExerciseChecked[index];
            success = await homeApiService.checkExerciseRoutine(
                newStatus, exerciseRoutine.recordId);
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
          if (index < _isSpiritChecked.length &&
              index < widget.spiritDailyRoutines.length) {
            //print('마음 채우기 루틴 체크 안!!!!!');
            SpiritRoutineDetail spiritRoutine =
                widget.spiritDailyRoutines[index];
            newStatus = !_isSpiritChecked[index];
            success = await homeApiService.checkSpiritRoutine(
                newStatus, spiritRoutine.recordId);
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
        print('루틴 상태 업데이트에 실패!!!!!!!!!!!');
        // const ToastBarWidget(
        //   title: '루틴 상태 업데이트에 실패했습니다.',
        // ).showToast(context);
      }
    } catch (e) {
      print('Error updating routine status: $e');
      // const ToastBarWidget(
      //   title: '루틴 상태 업데이트 중 오류가 발생했습니다.',
      // ).showToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return const Center(child: CustomCircularProgressIndicator());
    }
    //final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //var size = MediaQuery.of(context).size;

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
                  border: widget.text == '운동' &&
                              widget.exerciseDailyRoutines.isNotEmpty ||
                          widget.text == '수면' &&
                              widget.sleepDailyRoutines.isNotEmpty ||
                          widget.text == '마음 채우기' &&
                              widget.spiritDailyRoutines.isNotEmpty
                      ? const Border(
                          top: BorderSide(color: Colors.black, width: 1.0))
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
