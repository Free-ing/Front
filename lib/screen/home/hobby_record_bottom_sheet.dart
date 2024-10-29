import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/screen/home/select_hobby_name.dart';
import 'package:image_picker/image_picker.dart';

//Todo: 취미 기록
void showHobbyBottomSheet(BuildContext context, String title) {
  final TextEditingController hobbyMemoController = TextEditingController();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  DateTime selectedDate = DateTime.now();

  final ValueNotifier<String> selectedHobbyNotifier = ValueNotifier('취미 선택');
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  final ImagePicker picker = ImagePicker();

  //Todo: 서버 요청 (취미 기록 하기)
  Future<void> submitHobbyRecord() async {
    final apiService = HobbyAPIService();

    // 이미지 파일 객체가 있는지 확인
    if (imageNotifier.value != null) {
      // 취미 기록 요청
      final int response = await apiService.postHobbyRecord(
          selectedHobbyNotifier.value,
          imageNotifier.value!,
          hobbyMemoController.text // 취미 내용
          );

      // 응답 처리
      if (response == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('취미 기록이 추가되었습니다')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('취미 기록 추가에 실패했습니다.')));
        print(response); // 에러 코드 출력
      }
    } else {
      // 이미지 파일이 없는 경우 사용자에게 알림
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이미지를 선택해 주세요.')));
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
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: image == null
                              ? Center(child: Text('사진을 입력해주세요.'))
                              : Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 30,
                            ),
                            onPressed: () {
                              showPicker(context);
                            },
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

//
// //Todo: 취미 이름
// class SelectHobbyButton extends StatelessWidget {
//   final ValueNotifier<String> selectedHobbyNotifier = ValueNotifier('취미 선택');
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return GestureDetector(
//       onTap: () async {
//         final result = await Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => SelectHobbyName(),
//           ),
//         );
//         // setState(() {
//         //   selectedHobby = result ?? selectedHobby;
//         // });
//         selectedHobbyNotifier.value = result ?? selectedHobbyNotifier.value;
//       },
//       child: Container(
//         width: screenWidth * 0.3,
//         height: screenHeight * 0.045,
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(width: 1),
//         ),
//         child: ValueListenableBuilder<String>(
//             valueListenable: selectedHobbyNotifier,
//             builder: (context, selectedHobby, _) {
//               return Stack(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       selectedHobby,
//                       style: selectedHobby == '취미 선택'
//                           ? textTheme.bodyMedium?.copyWith(color: TEXT_GREY)
//                           : textTheme.bodyMedium,
//                     ),
//                   ),
//                   Align(
//                       alignment: Alignment.centerRight,
//                       child: Icon(Icons.arrow_right_rounded))
//                 ],
//               );
//             }),
//       ),
//     );
//   }
// }
//
// //Todo: 사진 입력
// class InsertPhoto extends StatefulWidget {
//   InsertPhoto({super.key});
//
//   @override
//   State<InsertPhoto> createState() => _InsertPhotoState();
// }
//
// class _InsertPhotoState extends State<InsertPhoto> {
//   File? image;
//   final ImagePicker _picker = ImagePicker();
//   final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
//
//   //Todo: 사진 선택 함수
//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedImage = await _picker.pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         //image = File(pickedImage.path);
//         imageNotifier.value = File(pickedImage.path);
//       });
//     }
//     Navigator.of(context).pop();
//   }
//
//   //Todo: 모달 바텀 시트: 사진 선택 옵션
//   void _showPicker(context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('갤러리에서 선택'),
//                 onTap: () {
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('카메라로 촬영'),
//                 onTap: () {
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: 200,
//           height: 200,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//           ),
//           child: image == null
//               ? Center(child: Text('사진을 입력해주세요.'))
//               : Image.file(
//                   image!,
//                   fit: BoxFit.cover,
//                 ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: IconButton(
//             icon: Icon(
//               Icons.camera_alt,
//               size: 30,
//             ),
//             onPressed: () {
//               _showPicker(context);
//             },
//           ),
//         )
//       ],
//     );
//   }
// }
