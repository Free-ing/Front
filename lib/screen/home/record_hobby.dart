import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/screen/home/select_hobby_name.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/const/colors.dart';

class RecordHobby extends StatefulWidget {
  const RecordHobby({super.key});

  @override
  State<RecordHobby> createState() => _RecordHobbyState();
}

class _RecordHobbyState extends State<RecordHobby> {
  String selectedHobby = '취미 선택';
  final TextEditingController _hobbyMemoController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  //Todo: 사진 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
    Navigator.of(context).pop();
  }

  //Todo: 모달 바텀 시트: 사진 선택 옵션
  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('카메라로 촬영'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectHobbyName(),
                    ),
                  );
                  setState(() {
                    selectedHobby = result;
                  });
                },
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.045,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1),
                  ),
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedHobby,
                          style: selectedHobby == '취미 선택'
                              ? textTheme.bodyMedium?.copyWith(color: TEXT_GREY)
                              : textTheme.bodyMedium,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.arrow_right_rounded))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: _image == null
                        ? Center(child: Text('사진을 입력해주세요.'))
                        : Image.file(
                            _image!,
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
                        _showPicker(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text('오늘 했던 취미 활동에 대해서 알려주세요.',
                      style: textTheme.bodyMedium),
                ),
              ),
              YellowTextFormField(
                controller: _hobbyMemoController,
                maxLength: 50,
                // height: screenHeight * 0.06,
                height: screenHeight * 0.1,
                width: screenWidth,
              ),

              GreenButton(width: 120, onPressed: (){})
            ],
          ),
        ),
      ),
    );
  }
}
