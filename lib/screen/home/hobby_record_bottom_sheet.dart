import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/screen/home/select_hobby_name.dart';
import 'package:image_picker/image_picker.dart';

//Todo: 취미 기록
void showHobbyBottomSheet(
    BuildContext context, String title, DateTime selectedDate) {
  final TextEditingController hobbyMemoController = TextEditingController();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final ValueNotifier<String> selectedHobbyNotifier = ValueNotifier('취미 선택');
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  final ImagePicker picker = ImagePicker();

  //Todo: 서버 요청 (취미 기록 하기)
  Future<void> submitHobbyRecord() async {
    final apiService = HobbyAPIService();

    // 이미지 파일 객체가 있는지 확인
    if (selectedHobbyNotifier.value != '취미 선택' &&
        imageNotifier.value != null &&
        hobbyMemoController.text.isNotEmpty) {
      // 취미 기록 요청
      final int response = await apiService.postHobbyRecord(
        selectedHobbyNotifier.value,
        imageNotifier.value!,
        hobbyMemoController.text, // 취미 내용
        selectedDate,
      );

      // 응답 처리
      if (response == 200) {
        Navigator.pop(context);
        ToastBarWidget(
          title: '취미 기록이 추가되었습니다.',
          leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
        ).showToast(context);
      } else {
        ToastBarWidget(
          title: '취미 기록 추가에 실패했습니다. $response',
        ).showToast(context);
      }
    } else {
      DialogManager.showAlertDialog(
        context: context,
        title: '알림',
        content: '모두 입력 해주세요.',
      );
    }
  }

  //Todo: 사진 선택 함수
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      imageNotifier.value = File(pickedImage.path);
    }
    Navigator.of(context).pop();
  }

  //Todo: 모달 바텀 시트: 사진 선택 옵션
  void showPicker(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return BaseAnimatedBottomSheetContent(
        title: title,
        onButtonPressed: (AnimationController) async {
          submitHobbyRecord();
        }, // 완료 버튼 눌렀을 때 수행 하는 함수
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                style: textTheme.titleSmall,
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectHobbyName(),
                    ),
                  );
                  selectedHobbyNotifier.value =
                      result ?? selectedHobbyNotifier.value;
                },
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.045,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1),
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: selectedHobbyNotifier,
                    builder: (context, selectedHobby, _) {
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedHobby,
                              style: selectedHobby == '취미 선택'
                                  ? textTheme.bodyMedium
                                      ?.copyWith(color: TEXT_GREY)
                                  : textTheme.bodyMedium,
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_right_rounded))
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ValueListenableBuilder<File?>(
                  valueListenable: imageNotifier,
                  builder: (context, image, _) {
                    return Stack(
                      children: [
                        image == null
                            ? Container(
                                height: screenHeight * 0.22,
                                child: Center(child: Text('사진을 입력해주세요.')))
                            : SizedBox(
                                height: screenHeight * 0.22,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            width: screenWidth * 0.1,
                            child: OutlinedButton(
                              onPressed: () {
                                showPicker(context);
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                //side: BorderSide(width: 1),
                              ), // child: IconButton(
                            ),
                          ),
                        )
                      ],
                    );
                  }),
              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text('오늘 했던 취미 활동에 대해서 알려주세요.',
                      style: textTheme.bodyMedium),
                ),
              ),
              YellowTextFormField(
                controller: hobbyMemoController,
                maxLength: 100,
                // height: screenHeight * 0.06,
                height: screenHeight * 0.1,
                width: screenWidth,
              ),
            ],
          ),
        ),
      );
    },
  );
}
