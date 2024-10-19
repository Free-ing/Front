import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/routine/routine_page.dart';

const List<String> list = <String>['운동', '수면', '취미', '마음채우기'];

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
  String dropdownValue = list.first;
  String selectedValue = '운동';
  final List<String> options = ['운동', '수면', '취미', '마음 채우기'];
  DateTime? _startTime;
  bool _timePickerOpen = false;

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.chevron_left),
                iconSize: 35.0,
              ),
              Text('루틴 추가하기', style: textTheme.headlineLarge),
              SizedBox(width: 35)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.076, vertical: screenHeight * 0.02),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // 제목과 이미지 입력
              _routineImageTitle(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              // 카테고리 선택
              _selectCategory(textTheme, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              // 반복 요일 선택
              _selectRoutineDay(textTheme, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              Container(
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
                    Text('시작: 8:00, 종료: 12:00',
                        style:
                            textTheme.bodySmall!.copyWith(color: TEXT_PURPLE)),
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
              ),
              // 시간을 설정할 수 있는 위젯
              Visibility(
                visible: _timePickerOpen,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    Container(
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
                            Row(
                              children: [
                                Text("시작 시간", style: textTheme.bodySmall),
                                SizedBox(
                                  width: screenWidth*0.3,
                                  height: screenHeight*0.05,
                                  child: TextField(
                                    controller: _startTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(screenWidth*0.01),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: Icon(Icons.access_time),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final selectedTime = await showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: CupertinoColors.white,
                                            height: 300.0,
                                            child: CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.time,
                                              onDateTimeChanged: (DateTime selectTime) {
                                                setState(() {
                                                  _startTime = selectTime;
                                                });
                                                _startTimeController.text =
                                                    '${selectTime.hour}:${selectTime.minute}';
                                              },
                                            )
                                          );
                                        }
                                      );
                                    }
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // 설명 입력
              _routieDescirbe(
                  textTheme, screenWidth, screenHeight),
              SizedBox(
                  height: _timePickerOpen
                      ? screenHeight * 0.04
                      : screenHeight * 0.18),
              // 추가하기 버튼
              //GreenButton(width: screenWidth * 0.6, onPressed: () {}),
              SizedBox(
                width: screenWidth * 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          width: 1,
                        ),
                      )),
                  onPressed: () {},
                  child: Text('완료', style: textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Todo: 루틴 이미지, 제목 입력
  Widget _routineImageTitle(screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: screenWidth * 0.2,
        ),
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
                _routineImage(imageUrl: 'assets/imgs/hobby/select_hobby.png'),
                _routineTitle(context: context, title: "제목 입력"),
              ],
            ),
          ),
        ),
        Column(
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
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RoutinePage()));
                  },
                  icon: Image.asset('assets/imgs/hobby/select_hobby.png',
                      width: screenWidth * 0.14, fit: BoxFit.cover),
                ),
              ],
            ),
            Text("그림 변경"),
          ],
        )
      ],
    );
  }

  //Todo: 루틴 카테고리 선택
  Widget _selectCategory(textTheme, screenWidth, screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(' 루틴 카테고리 선택', style: textTheme.bodyMedium),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: screenWidth * 0.1),
            height: screenHeight * 0.035,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
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
  Widget _routieDescirbe(textTheme, screenWidth, screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' 설명', style: textTheme.bodyMedium),
        SizedBox(height: screenHeight * 0.01),
        GrayTextFormField(
          hintText: "루틴에 대한 설명",
          width: screenWidth,
          controller: _descriptionController,
        )
      ],
    );
  }

  //Todo: 루틴 이미지
  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      left: 15,
      right: 15,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
      ),
    );
  }

  //Todo: 루틴 제목
  Widget _routineTitle({required BuildContext context, required String title}) {
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
