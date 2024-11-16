import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/common/service/sleep_api_service.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/screen/routine/routine_page.dart';
import 'package:freeing/screen/routine/select_routine_image_screen.dart';
import 'package:intl/intl.dart';

//Todo: 날짜 선택 유뮤
class WeekDay {
  String day;
  bool isSelected;

  WeekDay(this.day, this.isSelected);
}

class EditRoutineScreen extends StatefulWidget {
  final int routineId;
  final String title;
  final String selectImage;
  final String category;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;
  final bool? sunday;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? explanation;
  final bool? status;

  const EditRoutineScreen(
      {super.key,
      required this.routineId,
      required this.title,
      required this.selectImage,
      required this.category,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday,
      this.startTime,
      this.endTime,
      this.explanation,
      this.status});

  @override
  State<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  String? nameErrorText;
  String? timeErrorText;
  String? repeatDayErrorText;

  List<WeekDay> weekDays = [];
  final _formKey = GlobalKey<FormState>();

  final List<String> options = ['운동', '수면', '취미', '마음 채우기'];
  String selectedValue = '운동';

  DateTime? _startTime = DateTime.now();
  DateTime? _endTime = DateTime.now();
  bool _timePickerOpen = false;
  bool _selectExercise = true;
  bool _selectHobby = true;
  bool _selectSleep = true;

  String imageUrl =
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_exercise.png';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _explanationController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.title);
    imageUrl = widget.selectImage;
    selectedValue = widget.category;
    selectedValue == '취미' ? _selectHobby = false : _selectHobby = true;
    selectedValue == '수면' ? _selectSleep = false : _selectSleep = true;
    selectedValue == '운동' ? _selectExercise = true : _selectExercise = false;
    weekDays = [
      WeekDay("월", widget.monday ?? true),
      WeekDay("화", widget.tuesday ?? true),
      WeekDay("수", widget.wednesday ?? true),
      WeekDay("목", widget.thursday ?? true),
      WeekDay("금", widget.friday ?? true),
      WeekDay("토", widget.saturday ?? false),
      WeekDay("일", widget.sunday ?? false),
    ];
    _explanationController = TextEditingController(text: widget.explanation);

    _startTime = widget.startTime;
    _endTime = widget.endTime;
    // 시작 및 종료 시간을 컨트롤러에 설정
    if (_startTime != null) {
      _startTimeController.text = _formatTime(_startTime!);
    }

    if (_endTime != null) {
      _endTimeController.text = _formatTime(_endTime!);
    }
  }

  //Todo: 시간 포맷
  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String formattedHour = hour.toString();
    String formattedMinute = time.minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  //Todo: 반복 요일 설정 검사
  void checkAndSetName(List<WeekDay> weekDays) {
    bool allFalse = weekDays.every((weekday) => !weekday.isSelected);

    if (allFalse) {
      repeatDayErrorText = '반복 요일을 설정해주세요.';
    } else {
      print('Not all isSelected are false');
    }
  }


  //Todo: 서버 요청 (운동 루틴 수정)
  Future<void> _editExerciseRoutine() async {
    checkAndSetName(weekDays);

    if (_formKey.currentState!.validate() &&
        _nameController.text.isNotEmpty &&
        timeErrorText == null &&
        repeatDayErrorText == null) {
      FocusScope.of(context).unfocus();
      final String exerciseName = _nameController.text;
      final String explanation = _explanationController.text;

      final startTime =
          _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
      final endTime =
          _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;

      print("루틴 켜졌니 ${widget.status}");

      final apiService = ExerciseAPIService();
      final response = await apiService.patchExerciseRoutine(
        exerciseName,
        imageUrl,
        weekDays[0].isSelected,
        weekDays[1].isSelected,
        weekDays[2].isSelected,
        weekDays[3].isSelected,
        weekDays[4].isSelected,
        weekDays[5].isSelected,
        weekDays[6].isSelected,
        startTime,
        endTime,
        explanation,
        widget.status ?? true,
        widget.routineId,
      );

      if (response.statusCode == 200) {
        if(mounted){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RoutinePage(index: 0)),
          );
          const ToastBarWidget(
            title: '운동 루틴이 수정되었습니다.',
            leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
          ).showToast(context);
        }
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        DialogManager.showAlertDialog(
          context: context,
          title: '운동 루틴 수정 실패',
          content: '${errorData}\n(오류 코드: ${response.statusCode})',
        );
      }
    }
  }

  //Todo: 서버 요청 (운동 루틴 삭제)
  Future<void> _deleteExerciseRoutine() async {
    final responseCode =
        await ExerciseAPIService().deleteExerciseRoutine(widget.routineId);
    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RoutinePage(index: 0)),
      );
      const ToastBarWidget(
        title: '운동 루틴이 삭제되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    } else {
      ToastBarWidget(
        title: '운동 루틴이 삭제되지 않았습니다. $responseCode',
      ).showToast(context);
    }
  }

  //Todo: 서버 요청 (수면 루틴 수정)
  Future<void> _editSleepRoutine() async {
    checkAndSetName(weekDays);

    if (_formKey.currentState!.validate() &&
        _nameController.text.isNotEmpty &&
        timeErrorText == null &&
        repeatDayErrorText == null) {
      FocusScope.of(context).unfocus();
      final String sleepName = _nameController.text;

      final startTime =
          _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
      final endTime =
          _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;

      final apiService = SleepAPIService();

      final response = await apiService.patchSleepRoutine(
        sleepName,
        startTime,
        endTime,
        weekDays[0].isSelected,
        weekDays[1].isSelected,
        weekDays[2].isSelected,
        weekDays[3].isSelected,
        weekDays[4].isSelected,
        weekDays[5].isSelected,
        weekDays[6].isSelected,
        widget.status ?? true,
        imageUrl,
        widget.routineId,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 1)),
        );
        const ToastBarWidget(
          title: '수면 루틴이 수정되었습니다.',
          leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
        ).showToast(context);
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        DialogManager.showAlertDialog(
          context: context,
          title: '수면 루틴 수정 실패',
          content: '${errorData['message']}\n(오류 코드: ${response.statusCode})',
        );
      }
    }
  }

  //Todo: 서버 요청 (수면 루틴 삭제)
  Future<void> _deleteSleepRoutine() async {
    final responseCode =
        await SleepAPIService().deleteSleepRoutine(widget.routineId);
    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RoutinePage(index: 1)),
      );
      const ToastBarWidget(
        title: '수면 루틴이 삭제되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    } else {
      ToastBarWidget(
        title: '수면 루틴이 삭제되지 않았습니다. $responseCode',
      ).showToast(context);
    }
  }

  //Todo: 서버 요청 (취미 루틴 수정)
  Future<void> _editHobbyRoutine() async {
    if (_formKey.currentState!.validate() && _nameController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();

      final String hobbyName = _nameController.text;

      final apiService = HobbyAPIService();
      final response = await apiService.patchHobbyRoutine(
          hobbyName, imageUrl, widget.routineId);

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 2)),
        );
        const ToastBarWidget(
          title: '취미 루틴이 수정되었습니다.',
          leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
        ).showToast(context);
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        DialogManager.showAlertDialog(
          context: context,
          title: '취미 수정 실패',
          content: '${errorData['message']}\n(오류 코드: ${response.statusCode})',
        );
      }
    }
  }

  //Todo: 서버 요청 (취미 루틴 삭제)
  Future<void> _deleteHobbyRoutine() async {
    final responseCode =
        await HobbyAPIService().deleteHobbyRoutine(widget.routineId);
    if (responseCode == 200) {
      const ToastBarWidget(
        title: '취미 루틴이 삭제되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RoutinePage(index: 2)),
      );
    } else {
      ToastBarWidget(
        title: '취미 루틴이 삭제되지 않았습니다. $responseCode',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    }
  }

  //Todo: 서버 요청 (마음 채우기 루틴 수정)
  Future<void> _editSpiritRoutine() async {
    checkAndSetName(weekDays);

    if (_formKey.currentState!.validate() &&
        _nameController.text.isNotEmpty &&
        timeErrorText == null&&
        repeatDayErrorText == null) {
      FocusScope.of(context).unfocus();
      final String spiritName = _nameController.text;
      final String explanation = _explanationController.text;

      final startTime =
          _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
      final endTime =
          _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;

      print("루틴 켜졌니 ${widget.status}");

      final apiService = SpiritAPIService();
      final response = await apiService.patchSpiritRoutine(
        spiritName,
        imageUrl,
        weekDays[0].isSelected,
        weekDays[1].isSelected,
        weekDays[2].isSelected,
        weekDays[3].isSelected,
        weekDays[4].isSelected,
        weekDays[5].isSelected,
        weekDays[6].isSelected,
        startTime,
        endTime,
        explanation,
        widget.status ?? true,
        widget.routineId,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 3)),
        );
        const ToastBarWidget(
          title: '마음채우기 루틴이 수정되었습니다.',
          leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
        ).showToast(context);
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        DialogManager.showAlertDialog(
          context: context,
          title: '마음 채우기 루틴 수정 실패',
          content: '${errorData['message']}\n(오류 코드: ${response.statusCode})',
        );
      }
    }
  }

  //Todo: 서버 요청 (마음 채우기 루틴 삭제)
  Future<void> _deleteSpiritRoutine() async {
    final responseCode =
        await SpiritAPIService().deleteSpiritRoutine(widget.routineId);
    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RoutinePage(index: 3)),
      );
      const ToastBarWidget(
        title: '마음채우기 루틴이 삭제되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    } else {
      ToastBarWidget(
        title: '마음채우기 루틴이 삭제되지 않았습니다. $responseCode',
      ).showToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      showIconButton: true,
      title: "루틴 수정하기",
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 제목과 이미지 입력
                _routineImageTitle(textTheme, screenWidth, screenHeight),

                // 카테고리 선택
                _selectCategory(textTheme, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),

                /// 취미 선택 시 가려짐
                Visibility(
                  visible: _selectHobby,
                  child: Column(
                    children: [
                      // 반복 요일 설정
                      _selectRoutineDay(textTheme, screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.02),
                      // 시간 선택
                      _selectTime(textTheme, screenWidth, screenHeight),
                      SizedBox(
                          height: _timePickerOpen ? screenHeight * 0.01 : 0),
                      // 시간 설정
                      _startEndTime(textTheme, screenWidth, screenHeight),
                      // 운동 선택 시 시간 설정 알림 텍스트
                      Visibility(
                        visible: _selectExercise,
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              '* 시간 선택 시 더 좋은 ai의 피드백을 받을 수 있어요!\n  제목에 시간을 입력하는 것도 좋아요. (예, 10분 걷기)',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // 설명 입력
                      Visibility(
                          visible: _selectSleep,
                          child: _routineDescribe(
                              textTheme, screenWidth, screenHeight)),
                      SizedBox(
                          height: _timePickerOpen
                              ? screenWidth * 0.06
                              : _selectExercise
                              ? screenHeight * 0.043
                              : screenHeight * 0.095),
                      // 수면 선택 시 추가 공백 높이
                      SizedBox(
                          height: _selectSleep
                              ? 0
                              : _timePickerOpen
                                  ? screenWidth * 0.167
                                  : screenWidth * 0.33),
                    ],
                  ),
                ),
                // 추가하기 버튼
                SizedBox(
                    height: _selectHobby
                        ? 0
                        : screenHeight * 0.477),
                GreenButton(
                  width: screenWidth * 0.6,
                  text: '수정하기',
                  onPressed: () {
                    switch (selectedValue) {
                      case '운동':
                        _editExerciseRoutine();
                        break;
                      case '수면':
                        _editSleepRoutine();
                        break;
                      case '취미':
                        _editHobbyRoutine();
                        break;
                      case '마음 채우기':
                        _editSpiritRoutine();
                        break;
                    }
                  },
                ),
                SizedBox(height: _timePickerOpen ? screenHeight * 0.053 : 0),
              ],
            ),
          ),
        ),
      ),
      onDeletePressed: () {
        switch (selectedValue) {
          case '운동':
            _deleteExerciseRoutine();
            break;
          case '수면':
            _deleteSleepRoutine();
            break;
          case '취미':
            _deleteHobbyRoutine();
            break;
          case '마음 채우기':
            _deleteSpiritRoutine();
            break;
        }
      },
    );
  }

  //Todo: 루틴 이미지, 제목 입력
  Widget _routineImageTitle(textTheme, screenWidth, screenHeight) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Card(
              elevation: 6,
              shadowColor: YELLOW_SHADOW,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              margin: const EdgeInsets.all(12),
              child: Container(
                width: screenWidth * 0.38,
                height: screenWidth * 0.38,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Stack(
                  children: [
                    _routineImage(imageUrl: imageUrl),
                    _routineTitle(textTheme: textTheme, title: "제목 입력"),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Card(
                        shadowColor: YELLOW_SHADOW,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        margin: const EdgeInsets.all(12),
                        child: Container(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SelectRoutineImageScreen(
                                  selectImage: imageUrl),
                            ),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              imageUrl = result; // 선택된 이미지를 imageUrl에 저장
                            });
                          }
                        },
                        icon: Image.network(imageUrl,
                            width: screenWidth * 0.14,
                            height: screenWidth * 0.14,
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  const Text("그림 변경"),
                ],
              ),
            ),
          ],
        ),
        if (nameErrorText != null)
          Text(
            nameErrorText!,
            style: textTheme.bodySmall?.copyWith(color: Colors.red),
          ),
        SizedBox(
            height: nameErrorText != null
                ? screenHeight * 0.004
                : screenHeight * 0.03),
      ],
    );
  }

  //Todo: 루틴 카테고리 선택
  Widget _selectCategory(textTheme, screenWidth, screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('루틴 카테고리 선택', style: textTheme.bodyMedium),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: screenWidth * 0.15),
            height: screenHeight * 0.038,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: null,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                iconSize: 24,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: textTheme.bodyMedium,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        )
      ],
    );
  }

  //Todo: 루틴 반복 요일 설정
  Widget _selectRoutineDay(textTheme, screenWidth, screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("반복 요일 설정", style: textTheme.bodyMedium),
            if (repeatDayErrorText != null)
              Text(
                repeatDayErrorText!,
                style: textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Container(
          width: screenWidth,
          height: screenHeight * 0.091,
          decoration: BoxDecoration(
            color: IVORY,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < weekDays.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        weekDays[i].isSelected = !weekDays[i].isSelected;
                        debugPrint(
                            '이미지 눌림 ${weekDays[i].day} ${weekDays[i].isSelected}');
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset(
                          weekDays[i].isSelected
                              ? 'assets/imgs/etc/routine_day_true.png'
                              : 'assets/imgs/etc/routine_day_false.png',
                          width: screenWidth * 0.1,
                        ),
                        Positioned(
                          left: screenWidth * 0.038,
                          bottom: screenWidth * 0.01,
                          child: Text(
                            weekDays[i].day,
                            style: textTheme.labelMedium!.copyWith(
                              color: weekDays[i].isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Todo: 루틴 설명 입력
  Widget _routineDescribe(textTheme, screenWidth, screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' 설명', style: textTheme.bodyMedium),
        SizedBox(height: screenHeight * 0.01),
        Container(
          constraints: BoxConstraints(
            minHeight: screenHeight * 0.045,
          ),
          child: SingleChildScrollView(
            child: TextField(
              controller: _explanationController,
              style: textTheme.bodyMedium,
              keyboardType: TextInputType.text,
              maxLength: 150,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "루틴에 대한 설명",
                hintStyle: textTheme.bodyMedium?.copyWith(color: TEXT_DARK),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // 모서리를 둥글게
                  borderSide: const BorderSide(
                    width: 1, // 테두리 두께
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    width: 1,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  //Todo: 시간 설정 미리보기
  Widget _selectTime(textTheme, screenWidth, screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.045, //40
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      // 선택한 시간 보기와 닫고 펼치는 버튼
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: screenWidth * 0.02),
          Text(' 시간 선택', style: textTheme.bodyMedium),
          SizedBox(width: screenWidth * 0.10),
          Text(
              _startTime == null
                  ? '시작: 미설정,'
                  : '시작: ${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}',
              style: textTheme.bodySmall!.copyWith(color: TEXT_PURPLE)),
          Text(
              _endTime == null
                  ? ' 종료: 미설정'
                  : ' 종료: ${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}',
              style: textTheme.bodySmall!.copyWith(color: TEXT_PURPLE)),
          IconButton(
            onPressed: () {
              setState(() {
                _timePickerOpen = !_timePickerOpen;
              });
            },
            icon: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }

  //Todo: 시간 설정하기
  Widget _startEndTime(textTheme, screenWidth, screenHeight) {
    return Visibility(
      visible: _timePickerOpen,
      child: Container(
        width: screenWidth,
        height:
            timeErrorText != null ? screenHeight * 0.17 : screenHeight * 0.13,
        decoration: BoxDecoration(
          color: IVORY,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectTimeField(
                textTheme: textTheme,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: '시작 시각',
                controller: _startTimeController,
                onTimeChanged: (DateTime selectTime) {
                  setState(() => _startTime = selectTime);
                },
                resetTime: () {
                  _startTime = null;
                }),
            SizedBox(height: screenHeight * 0.01),
            _buildSelectTimeField(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              title: '종료 시각',
              controller: _endTimeController,
              onTimeChanged: (DateTime selectTime) {
                setState(() {
                  if (_startTime != null && selectTime.isBefore(_startTime!)) {
                    timeErrorText = '종료 시각이 시작 시각 보다 빠릅니다.';
                  } else {
                    _endTime = selectTime;
                    timeErrorText = null;
                  }
                });
              },
              resetTime: () {
                _endTime = null;
                timeErrorText = null;
              },
            ),
            if (timeErrorText != null)
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    height: screenHeight * 0.03,
                    child: Center(
                      child: Text(
                        timeErrorText!,
                        style:
                            textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  //Todo: 루틴 이미지
  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      left: 15,
      right: 15,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
      ),
    );
  }

  //Todo: 루틴 제목
  Widget _routineTitle({required TextTheme textTheme, required String title}) {
    return Positioned(
        bottom: -5,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 50,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _nameController,
            style: textTheme.bodyMedium,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "제목 입력",
              hintStyle: textTheme.bodyMedium?.copyWith(color: TEXT_DARK),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // 모서리를 둥글게
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0, // 테두리 두께
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              )),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                setState(() {
                  nameErrorText = '제목을 입력 해주세요';
                });
              } else {
                setState(() {
                  nameErrorText = null;
                });
              }
              return null;
            },
          ),
        )
        // child: Text(
        //   title,
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context).textTheme.bodyMedium,
        // ),
        );
  }

  //Todo: 시간 선택 필드
  Widget _buildSelectTimeField({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required String title,
    required TextEditingController controller,
    required Function(DateTime) onTimeChanged,
    required Function() resetTime,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: screenWidth * 0.05),
        Text(title, style: textTheme.bodySmall),
        SizedBox(width: screenWidth * 0.05),
        SizedBox(
          width: screenWidth * 0.46,
          height: screenHeight * 0.047,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '미설정',
              hintStyle: textTheme.bodyMedium?.copyWith(color: TEXT_GREY),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            style: textTheme.bodyMedium
                ?.copyWith(color: _startTime == null ? TEXT_GREY : TEXT_PURPLE),
            textAlign: TextAlign.center, // 텍스트를 가운데 정렬
            readOnly: true, // 읽기 전용
            onTap: () async {
              await showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    color: CupertinoColors.white,
                    height: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: CupertinoButton(
                            child: Text(
                              "확인",
                              style: textTheme.bodyMedium,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 230,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (DateTime selectTime) {
                              setState(
                                () {
                                  onTimeChanged(selectTime);
                                  int hour = selectTime.hour;
                                  String period = hour >= 12 ? 'PM' : 'AM';
                                  hour = hour > 12
                                      ? hour - 12
                                      : (hour == 0 ? 12 : hour);

                                  String formattedHour = hour.toString();
                                  String formattedMinute = selectTime.minute
                                      .toString()
                                      .padLeft(2, '0');

                                  controller.text =
                                      '$formattedHour:$formattedMinute $period';
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              resetTime();
              controller.clear();
            });
          },
          icon: const Icon(Icons.restart_alt_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          iconSize: 24,
          color: DARK_GREY,
        )
      ],
    );
  }
}
