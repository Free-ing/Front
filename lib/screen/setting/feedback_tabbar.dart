import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';

class FeedbackTabbar extends StatefulWidget {
  const FeedbackTabbar({super.key});

  @override
  State<FeedbackTabbar> createState() => _FeedbackTabbarState();
}

class _FeedbackTabbarState extends State<FeedbackTabbar> {
  final _category = ['', '문의', '피드백', '버그 신고'];
  String _selectedCategory = '';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
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
                  // Container(
                  //   width: screenWidth * 0.35,
                  //   height: screenHeight * 0.033,
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(color: Colors.black, width: 1),
                  //       borderRadius: BorderRadius.circular(12)),
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: DropdownButton<String>(
                  //       dropdownColor: Colors.white,
                  //       value: _selectedCategory.isNotEmpty
                  //           ? _selectedCategory
                  //           : null,
                  //       items: _category
                  //           .where((e) => e.isNotEmpty)
                  //           .map((e) =>
                  //               DropdownMenuItem(value: e, child: Text(e)))
                  //           .toList(),
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _selectedCategory = value!;
                  //         });
                  //       },
                  //       underline: Container(),
                  //       //dropdownStyleData: DropdownStyleData(),
                  //     ),
                  //   ),
                  // ),
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
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text('내용',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                  width: screenWidth,
                  height: screenHeight * 0.46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  )),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              Align(
                  alignment: Alignment.center,
                  child: GreenButton(
                      text: '확인', width: screenWidth * 0.61, onPressed: () {}))
            ],
          ),
        ),
      ),
    );
  }
}
