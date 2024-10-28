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
                  SizedBox(width: screenWidth * 0.08,),
                  DropdownButton(
                      value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
                      items: _category.where((e)=>e.isNotEmpty).map(
                          (e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value){
                        setState(() {
                          _selectedCategory = value!;
                        });
                      }),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       borderSide: BorderSide.none, // 테두리를 없앱니다.
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.white, // 드롭다운 버튼 배경색
                  //   ),
                  //   dropdownColor: Colors.white, // 드롭다운 메뉴 배경색
                  //   menuMaxHeight: screenHeight * 0.3, // 드롭다운 메뉴 최대 높이
                  //   value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
                  //   hint: Text('선택해 주세요'),
                  //   items: _category
                  //       .where((e) => e.isNotEmpty)
                  //       .map((e) => DropdownMenuItem(
                  //     value: e,
                  //     child: Material(
                  //       color: Colors.white, // 메뉴 아이템 배경색
                  //       borderRadius: BorderRadius.circular(15.0), // borderRadius 설정
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //         child: Text(e),
                  //       ),
                  //     ),
                  //   ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectedCategory = value!;
                  //     });
                  //   },
                  // ),
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
