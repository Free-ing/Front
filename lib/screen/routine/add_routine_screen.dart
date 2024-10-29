import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/common/service/sleep_api_service.dart';
import 'package:freeing/common/service/spirit_api_sevice.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/screen/routine/routine_page.dart';
import 'package:freeing/screen/routine/select_routine_image_screen.dart';
import 'package:freeing/screen/routine/sleep_tabbar_view.dart';
import 'package:intl/intl.dart';

//Todo: 날짜 선택 유뮤
class WeekDay {
  String day;
  bool isSelected;

  WeekDay(this.day, this.isSelected);
}

List<WeekDay> weekDays = [
  WeekDay("월", true),
  WeekDay("화", true),
  WeekDay("수", true),
  WeekDay("목", true),
  WeekDay("금", true),
  WeekDay("토", false),
  WeekDay("일", false),
];

class AddRoutineScreen extends StatefulWidget {
  const AddRoutineScreen({super.key});

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> options = ['운동', '수면', '취미', '마음 채우기'];
  String selectedValue = '운동';

  DateTime? _startTime;
  DateTime? _endTime;
  bool _timePickerOpen = false;
  bool _selectHobby = true;
  bool _selectSleep = true;

  String imageUrl =
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_hobby.png';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _explanationController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  //Todo: 서버 요청 (운동 루틴 추가)
  Future<void> _submitExerciseRoutine() async {
    // if (_formKey.currentState!.validate()) {
    //   FocusScope.of(context).unfocus();
    //   final String spiritName = _nameController.text;
    //   final String explanation = _boddyController.text;
    //
    //   final startTime =
    //       _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
    //   final endTime =
    //       _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;
    //
    //   final apiService = ExerciseAPIService();
    //   final int response = await apiService.postExerciseRoutine(
    //     spiritName,
    //     imageUrl,
    //     weekDays[0].isSelected,
    //     weekDays[1].isSelected,
    //     weekDays[2].isSelected,
    //     weekDays[3].isSelected,
    //     weekDays[4].isSelected,
    //     weekDays[5].isSelected,
    //     weekDays[6].isSelected,
    //     startTime,
    //     endTime,
    //     explanation,
    //   );
    //
    //   if (response == 200) {
    //     Navigator.pop(context);
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(const SnackBar(content: Text('운동 루틴이 추가되었습니다')));
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('운동 채우기 루틴 추가에 실패했습니다.')));
    //     print(response);
    //   }
    // }
  }

  //Todo: 서버 요청 (수면 루틴 추가)
  Future<void> _submitSleepRoutine() async {
    print('수면 루틴 추가');
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final String sleepName = _nameController.text;
      final String explanation = _explanationController.text;

      final startTime =
          _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
      final endTime =
          _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;

      final apiService = SleepAPIService();
      final int response = await apiService.postSleepRoutine(
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
        explanation,
        imageUrl,
      );

      if (response == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 1)),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('수면 루틴이 추가되었습니다')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('수면 루틴 추가에 실패했습니다.')));
        print(response);
      }
    }
  }

  //Todo: 서버 요청 (취미 루틴 추가)
  Future<void> _submitHobbyRoutine() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final String hobbyName = _nameController.text;

      final apiService = HobbyAPIService();
      final int response =
          await apiService.postHobbyRoutine(hobbyName, imageUrl);

      if (response == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 2)),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('취미 루틴이 추가되었습니다')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('취미 루틴 추가에 실패했습니다.')));
        print(response);
      }
    }
  }

  //Todo: 서버 요청 (마음 채우기 루틴 추가)
  Future<void> _submitSpiritRoutine() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final String spiritName = _nameController.text;
      final String explanation = _explanationController.text;

      final startTime =
          _startTime != null ? DateFormat('HH:mm').format(_startTime!) : null;
      final endTime =
          _endTime != null ? DateFormat('HH:mm').format(_endTime!) : null;

      final apiService = SpiritAPIService();
      final int response = await apiService.postSpiritRoutine(
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
      );

      if (response == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutinePage(index: 3)),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('마음 채우기 루틴이 추가되었습니다')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('마음 채우기 루틴 추가에 실패했습니다. $response}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScreenLayout(
      title: "루틴 추가하기",
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 제목과 이미지 입력
                _routineImageTitle(textTheme, screenWidth),
                SizedBox(height: screenHeight * 0.03),
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
                      SizedBox(height: screenHeight * 0.02),
                      // 설명 입력
                      Visibility(
                          visible: _selectSleep,
                          child: _routineDescribe(
                              textTheme, screenWidth, screenHeight)),
                      SizedBox(
                          height: _timePickerOpen
                              ? screenWidth * 0.06
                              : screenWidth * 0.2),
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
                        ? screenHeight * 0.012
                        : screenHeight * 0.469),
                GreenButton(
                  width: screenWidth * 0.6,
                  text: '추가하기',
                  onPressed: () {
                    switch (selectedValue) {
                      case '운동':
                        _submitExerciseRoutine();
                        break;
                      case '수면':
                        _submitSleepRoutine();
                        break;
                      case '취미':
                        _submitHobbyRoutine();
                        break;
                      case '마음 채우기':
                        _submitSpiritRoutine();
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
    );
  }

  //Todo: 루틴 이미지, 제목 입력
  Widget _routineImageTitle(textTheme, screenWidth) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          elevation: 6,
          shadowColor: YELLOW_SHADOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.all(12),
          child: Container(
            width: screenWidth * 0.38,
            height: screenWidth * 0.38,
            padding: EdgeInsets.all(2),
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
                    margin: EdgeInsets.all(12),
                    child: Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      padding: EdgeInsets.all(2),
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
                          builder: (context) =>
                              SelectRoutineImageScreen(selectImage: imageUrl),
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
              Text("그림 변경"),
            ],
          ),
        ),
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
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    print('카테고리 선택한 카테고리 $newValue');

                    selectedValue == '취미'
                        ? _selectHobby = false
                        : _selectHobby = true;

                    selectedValue == '수면'
                        ? _selectSleep = false
                        : _selectSleep = true;
                  });
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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
        Text("반복 요일 설정", style: textTheme.bodyMedium),
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
                        print(
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
          child: TextField(
            controller: _explanationController,
            style: textTheme.bodyMedium,
            keyboardType: TextInputType.text,
            maxLength: 50,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "루틴에 대한 설명",
              hintStyle: textTheme.bodyMedium?.copyWith(color: TEXT_DARK),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // 모서리를 둥글게
                borderSide: BorderSide(
                  width: 1, // 테두리 두께
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
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
                print('시간 선택 눌림');
              });
            },
            icon: Icon(Icons.arrow_forward_ios),
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
        height: screenHeight * 0.13,
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
                title: '시작 시간',
                controller: _startTimeController,
                onTimeChanged: (DateTime selectTime) {
                  setState(
                    () => _startTime = selectTime,
                  );
                  print('시작시간 바뀜~~~ $_startTime');
                },
                resetTime: () {
                  _startTime = null;
                }),
            SizedBox(height: screenHeight * 0.01),
            _buildSelectTimeField(
              textTheme: textTheme,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              title: '종료 시간',
              controller: _endTimeController,
              onTimeChanged: (DateTime selectTime) {
                setState(() => _endTime = selectTime);
              },
              resetTime: () {
                _endTime = null;
              },
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
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // 모서리를 둥글게
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0, // 테두리 두께
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              )),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '루틴의 제목을 입력해주세요.';
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
        Container(
          //color: Colors.pink,
          child: IconButton(
            onPressed: () {
              setState(() {
                resetTime();
                controller.clear();
              });
            },
            icon: Icon(Icons.restart_alt_rounded),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            visualDensity: VisualDensity.compact,
            iconSize: 24,
            color: DARK_GREY,
          ),
        )
      ],
    );
  }
}
