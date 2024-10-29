import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/service/auth_service.dart';
import 'package:freeing/common/service/setting_api_service.dart';

import '../../common/component/toast_bar.dart';

class FeedbackTabbar extends StatefulWidget {
  const FeedbackTabbar({super.key});

  @override
  State<FeedbackTabbar> createState() => _FeedbackTabbarState();
}

class _FeedbackTabbarState extends State<FeedbackTabbar> {
  final _category = ['', '문의', '피드백', '버그 신고'];
  String _selectedCategory = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _getSelectedCategory(String category) {
    switch (category) {
      case '문의':
        return 'INQUIRY';
      case '피드백':
        return 'FEEDBACK';
      case '버그 신고':
        return 'BUG';
      default:
        return category;
    }
  }

  bool validInputs() {
    print("Category: $_selectedCategory");
    print("Title: ${_titleController.text}");
    print("Content: ${_contentController.text}");

    print(' _titleController.text.isNotEmpty: ${ _titleController.text.isNotEmpty}');
    print('_contentController.text.isNotEmpty: ${_contentController.text.isNotEmpty}');



    return _selectedCategory != _category[0] &&
        _titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty;
  }

  void attemptSubmitFeedback() async {
    if (validInputs()) {
      final settingApiService = SettingAPIService();
      final response = await settingApiService.submitFeedback(
          category: _getSelectedCategory(_selectedCategory),
          inquiriesTitle: _titleController.text,
          content: _contentController.text);
      print('_getselectedCategory  ${_getSelectedCategory(_selectedCategory)}');
      print('inquirestitle ${_titleController.text}');
      print('content ${_contentController.text}');
      if(response.statusCode == 201){
        setState(() {
          _selectedCategory = '';
          _titleController.clear();
          _contentController.clear();
        });
        ToastBarWidget(
          title: '정상적으로 등록되었습니다.',
          leadingImagePath: "assets/imgs/home/sleep_record_success.png",
        ).showToast(context);
      } else if(response.statusCode == 400){
        print('statusCode 400');
        ToastBarWidget(
          title: '모두 입력해주세요.',
        ).showToast(context);
      } else if(response.statusCode == 401){
        // access Token이 만료됨 -> refreshtoken으로 accessToken 발급/ refreshtoken도 만료된 경우 다시 로그인
        final authService = AuthService();
        final authResponse = await authService.reissueAccessToken(context);
        if(authResponse != null && authResponse.statusCode==200){
          // refreshToken으로 accessToken 발급 성공
          // accessToken 저장하고 다시 서버에 요청 보내야함.
          final retryResponse = await settingApiService.submitFeedback(
            category: _getSelectedCategory(_selectedCategory),
            inquiriesTitle: _titleController.text,
            content: _contentController.text,
          );

          if (retryResponse.statusCode == 201) {
            ToastBarWidget(
              title: '정상적으로 등록되었습니다.',
              leadingImagePath: "assets/imgs/home/sleep_record_success.png",
            ).showToast(context);
          } else {
            // 재발급 후에도 오류 발생 시 적절히 처리
            ToastBarWidget(
              title: '다시 시도해 주세요.',
            ).showToast(context);
          }
        }
      } else{
        // statusCode == 500
        ToastBarWidget(
          title: '서버 내부 오류가 발생했습니다.',
        ).showToast(context);
      }
    } else {
      print('validInputs() : ${validInputs()}');
      ToastBarWidget(
        title: '모두 입력해주세요.',
      ).showToast(context);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     _selectedCategory = _category[0];
  //   });
  // }
  //

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SizedBox verticalSpace = SizedBox(height: screenHeight * 0.02);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '유형',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: screenWidth * 0.08,
                ),
                SizedBox(
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.033,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(screenWidth * 0.01),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.black, width: 1), // 클릭되지 않았을 때의 테두리
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    value: _selectedCategory.isNotEmpty
                        ? _selectedCategory
                        : null,
                    items: _category
                        .where((e) => e.isNotEmpty)
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                e,
                                style: textTheme.bodySmall,
                              ),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    dropdownStyleData: DropdownStyleData(
                      //maxHeight: screenHeight * 0.15,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace,
            Row(
              children: [
                Text('제목',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(
                  width: screenWidth * 0.08,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.035,
                    child: TextFormField(
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                      controller: _titleController,
                      cursorColor: Colors.black,
                      cursorHeight: screenHeight * 0.02,
                      maxLines: 1,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace,
            Text('내용',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _contentController,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                    cursorColor: Colors.black,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                        isCollapsed: true, border: InputBorder.none),
                  ),
                )),

            Spacer(),
            Align(
                alignment: Alignment.center,
                child: GreenButton(
                    text: '확인',
                    width: screenWidth * 0.61,
                    onPressed: attemptSubmitFeedback)),
            verticalSpace,
            verticalSpace
          ],
        ),
      ),
    );
  }
}
