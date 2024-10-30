import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:intl/intl.dart';
import '../../model/setting/notice_list.dart';

class NoticeDetailPage extends StatelessWidget {
  final NoticeList noticeList;
  const NoticeDetailPage({required this.noticeList, super.key});

  // TODO: category map하기(영어 -> 한국)
  String _getDisplayCategory(String category) {
    switch (category) {
      case 'URGENT':
        return '긴급';
      case 'ERROR_NOTICE':
        return '오류 안내';
      case 'UPDATE':
        return '업데이트';
      default:
        return category;
    }
  }

  String _formatDateTime(String createdDate){
    final dateTime = DateTime.parse(createdDate);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SettingLayout(
        title: noticeList.title,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('[${_getDisplayCategory(noticeList.category)}]', style: textTheme.titleMedium),
                    Text(_formatDateTime(noticeList.createdDate), style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.008),
                  width: screenWidth,
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01,),
                Text(
                  noticeList.content,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ));
  }
}
