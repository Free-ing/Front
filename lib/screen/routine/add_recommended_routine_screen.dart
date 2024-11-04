import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/layout/screen_layout.dart';
import 'package:freeing/screen/routine/select_routine_image_screen.dart';

import '../../common/const/colors.dart';
import '../../common/service/hobby_api_service.dart';

class AddRecommendedRoutineScreen extends StatefulWidget {
  final String category;
  final String routineName;
  final String? explanation;

  const AddRecommendedRoutineScreen({
    super.key,
    required this.category,
    required this.routineName,
    this.explanation,
  });

  @override
  State<AddRecommendedRoutineScreen> createState() =>
      _AddRecommendedRoutineScreenState();
}

class _AddRecommendedRoutineScreenState
    extends State<AddRecommendedRoutineScreen> {
  String selectedValue = '취미';
  final List<String> options = ['취미', '운동'];

  String imageUrl =
      'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_hobby.png';

  TextEditingController _explanationController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();


  //Todo: 취미 루틴 추가 요청
  Future<void> _submitHobbyRoutine() async {
    FocusScope.of(context).unfocus();

    final apiService = HobbyAPIService();

    final response =
        await apiService.postHobbyRoutine(widget.routineName, imageUrl);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ToastBarWidget(
        title: '취미 루틴이 수정되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      DialogManager.showAlertDialog(
          context: context,
          title: '취미 루틴 추가 실패',
          content: '${errorData['message']}\n(오류 코드: ${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool _selectHobby = widget.category == '취미' ? true : false;

    return ScreenLayout(
      title: 'AI추천 취미 추가하기',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
        child: Column(
          children: [
            // 제목과 이미지 입력
            _routineImageTitle(textTheme, screenWidth),
            SizedBox(height: screenHeight * 0.03),
            // 카테고리 선택
            _selectCategory(textTheme, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.02),
            Expanded(child: Container()),



            GreenButton(
                width: screenWidth * 0.6, onPressed: _submitHobbyRoutine),
            SizedBox(height: screenHeight * 0.033),
          ],
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
                Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Text(
                      widget.routineName,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )),
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
                          imageUrl = result;
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
                value: widget.category,
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
                onChanged: null,
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
}