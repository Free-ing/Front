import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:freeing/model/setting/notice_list.dart';
import 'package:freeing/screen/setting/notice_detail_page.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<NoticeList> _noticeList = [];
  bool _isLoading = true;

  // TODO: 공지사항 받아오는 서버 요청
  Future<void> _getNoticeInfo() async {
    try {
      // TODO: 실제 서버 요청 추가
      await Future.delayed(const Duration(seconds: 2)); // 서버 요청 시뮬레이션
      setState(() {
        _noticeList = [
          NoticeList(category: '업데이트', title: '새로운 업데이트', date: '2024-10-27', content: '앱 업데이트 내용입니다.'),
          NoticeList(category: '공지', title: '서비스 점검 안내', date: '2024-10-26', content: '점검 안내 사항입니다.'),
        ];
        _isLoading = false;
      });
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
          ? Center(child: CircularProgressIndicator())
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
                                Text('[${noticeList.category}]', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text('  ${noticeList.title}', style: textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Text(noticeList.date, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
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
                                NoticeDetailPage(noticeList: noticeList)));
                  },
                );
              }),
    );
  }
}
