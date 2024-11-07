import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/custom_circular_progress_indicator.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:freeing/model/setting/notice_list.dart';
import 'package:freeing/screen/setting/notice_detail_page.dart';
import 'package:intl/intl.dart';

import '../../common/service/setting_api_service.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<NoticeList> _noticeList = [];
  bool _isLoading = true;

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

  // TODO: createDate 날짜 형식으로 바꾸기
  String _formatDateOnly(String createdDate) {
    final dateTime = DateTime.parse(createdDate);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // TODO: 공지사항 리스트 서버 요청
  Future<void> _getNoticeInfo() async {
    try {
      final response = await SettingAPIService().viewNoticeList();
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> noticeData = json.decode(decodedBody);
        setState(() {
          _noticeList =
              noticeData.map((json) => NoticeList.fromJson(json)).toList();
          _noticeList.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          _isLoading = false;
        });
      } else {
        throw Exception('공지사항 리스트 가져오기 실패 ${response.statusCode}');
      }
    } catch (e) {
      print("Error loading notices: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getNoticeInfo();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SettingLayout(
      title: '공지사항',
      child: _isLoading
          ? const CustomCircularProgressIndicator()
          : ListView.builder(
              itemCount: _noticeList.length,
              itemBuilder: (context, index) {
                final noticeList = _noticeList[index];
                return ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                    '[${_getDisplayCategory(noticeList.category)}]',
                                    style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600)),
                                SizedBox(width: screenWidth * 0.013,),
                                Expanded(
                                  child: Text(
                                    '${noticeList.title}',
                                    style: textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01,),
                          Text(_formatDateOnly(noticeList.createdDate),
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w300)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        width: screenWidth,
                        child: Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NoticeDetailPage(noticeList: noticeList))).then((shouldRefresh){
                                  if(shouldRefresh == true){
                                    setState(() {
                                      _getNoticeInfo();
                                    });
                                  }
                    });
                  },
                );
              }),
    );
  }
}
