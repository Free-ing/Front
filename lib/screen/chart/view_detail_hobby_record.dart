import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/screen/chart/hobby_gallery_screen.dart';
import 'package:image_picker/image_picker.dart';

class ViewDetailHobbyRecord extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;
  final int recordId;
  final DateTime date;
  const ViewDetailHobbyRecord(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.description,
      required this.recordId,
      required this.date});

  @override
  State<ViewDetailHobbyRecord> createState() => _ViewDetailHobbyRecordState();
}

class _ViewDetailHobbyRecordState extends State<ViewDetailHobbyRecord> {
  bool _editMode = false;
  File? image;
  final ImagePicker picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  late String content;
  late DateTime date;

  //Todo: 서버 요청(취미 기록 수정)
  Future<void> _editHobbyRecord(recordId, title, image, content, date) async {
    final apiService = HobbyAPIService();

    if (controller.text.isNotEmpty) {
      final int response = await apiService.putHobbyRecord(
        recordId,
        title,
        image,
        content,
      );
      if (response == 200) {
        _editMode = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HobbyGalleryScreen()),
        );
        ToastBarWidget(
          title: '취미 기록이 수정되었습니다.',
          leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
        ).showToast(context);
      } else {
        ToastBarWidget(
          title: '취미 기록 수정에 실패했습니다. $response',
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

  //Todo: 서버 요청(취미 기록 삭제)
  Future<void> _deleteHobbyRecord(int recordId) async {
    final responseCode = await HobbyAPIService().deleteHobbyRecord(recordId);
    if (responseCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => HobbyGalleryScreen(selectTime: date)),
      );
      ToastBarWidget(
        title: '취미 기록이 삭제되었습니다.',
        leadingImagePath: 'assets/imgs/mind/emotion_happy.png',
      ).showToast(context);
    } else {
      ToastBarWidget(
        title: '취미 기록이 삭제되지 않았습니다. ${responseCode}',
      ).showToast(context);
      print(responseCode);
    }
  }

  //Todo: 취미 기록 수정, 삭제 메뉴
  void showMenu(context, recordId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit_note_rounded),
                title: const Text('취미 기록 수정하기'),
                onTap: () {
                  Navigator.pop(context);
                  _editMode = true;
                  setState(() {});
                },
              ),
              ListTile(
                  leading: Icon(Icons.delete_forever_outlined),
                  title: const Text('취미 기록 삭제하기'),
                  onTap: () {
                    Navigator.pop(context);
                    DialogManager.showConfirmDialog(
                        context: context,
                        title: '취미 기록 삭제',
                        content: '삭제된 취미 기록은 복구할 수 없습니다.\n삭제하시겠습니까?',
                        onConfirm: () {
                          _deleteHobbyRecord(recordId);
                        });
                  })
            ],
          ),
        );
      },
    );
  }

  //Todo: 사진 선택 함수
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
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

  @override
  void initState() {
    super.initState();
    content = widget.description;
    controller = TextEditingController(text: widget.description);
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: IVORY,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.all(screenHeight * 0.02),
        width: screenWidth * 0.9,
        height: screenHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 상단 타이틀
            _title(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.015),
            _date(textTheme),
            SizedBox(height: screenHeight * 0.015),
            _image(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.015),
            _description(textTheme, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.015),
            _button(textTheme)
          ],
        ),
      ),
    );
  }

  //Todo: 타이틀
  Widget _title(screenWidth, screenHeight) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        decoration: BoxDecoration(
          color: BLUE_PURPLE,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        height: screenHeight * 0.045,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),

            /// 취미 기록 수정, 삭제
            Container(
              width: screenWidth * 0.07,
              child: _editMode
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _editMode = false;
                          image = null;
                          content = widget.description;
                        });
                      },
                      icon: Icon(
                        Icons.cancel_rounded,
                        size: 25,
                      ),
                      color: Colors.white,
                    )
                  : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showMenu(context, widget.recordId);
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        //Icons.delete_forever,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //Todo: 날짜
  Widget _date(textTheme) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        '${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일',
        style: textTheme.bodyMedium,
      ),
    );
  }

  //Todo: 이미지 영역
  Widget _image(screenWidth, screenHeight) {
    return // 이미지 영역
        Stack(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _editMode
                ? image == null
                    ? Image.network(
                        widget.imageUrl,
                        height: screenHeight * 0.22,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: screenHeight * 0.22,
                          );
                        },
                      )
                    : Image.file(
                        image!,
                        height: screenHeight * 0.22,
                        fit: BoxFit.cover,
                      )
                : image == null
                    ? Image.network(
                        widget.imageUrl,
                        height: screenHeight * 0.22,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: screenHeight * 0.22,
                          );
                        },
                      )
                    : Image.file(
                        image!,
                        height: screenHeight * 0.22,
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        Visibility(
          visible: _editMode,
          child: Positioned(
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
                ), // child: IconButton(
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Todo: 설명란
  Widget _description(textTheme, screenWidth, screenHeight) {
    return Expanded(
      child: _editMode
          ? YellowTextFormField(
              controller: controller,
              maxLength: 100,
              height: screenHeight * 0.25,
              width: screenWidth,
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            ),
    );
  }

  //Todo: 버튼
  Widget _button(textTheme) {
    return ElevatedButton(
      onPressed: _editMode
          ? () {
              setState(() {
                content = controller.text;
              });
              _editHobbyRecord(
                widget.recordId,
                widget.title,
                image,
                content,
                date,
              );
            }
          : () {
              if (image != null || widget.description != content) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          HobbyGalleryScreen(selectTime: date)),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        backgroundColor: PRIMARY_COLOR,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconColor: Colors.white,
      ),
      child: Text(
        _editMode ? '수정 완료' : '닫기',
        style: textTheme.bodyMedium,
      ),
    );
  }
}
