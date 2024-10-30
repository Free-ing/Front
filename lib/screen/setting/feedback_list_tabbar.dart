import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/custom_circular_progress_indicator.dart';
import 'package:freeing/screen/setting/check_feedback_list.dart';
import 'package:intl/intl.dart';

import '../../common/service/setting_api_service.dart';
import '../../model/setting/feedback_list.dart';

class FeedbackListTabbar extends StatefulWidget {
  const FeedbackListTabbar({super.key});

  @override
  State<FeedbackListTabbar> createState() => _FeedbackListTabbarState();
}

class _FeedbackListTabbarState extends State<FeedbackListTabbar> {
  List<FeedbackList> _feedbackList = [];
  bool _isLoading = true;

  // TODO: category map하기(영어 -> 한국)
  String _getDisplayCategory(String category) {
    switch (category) {
      case 'FEEDBACK':
        return '피드백';
      case 'BUG':
        return '버그 신고';
      case 'INQUIRY':
        return '문의';
      default:
        return category;
    }
  }

  String _formatDateOnly(String createdDate) {
    final dateTime = DateTime.parse(createdDate);
    return DateFormat('yyyy년 MM월 dd일').format(dateTime);
  }
  
  // TODO: 문의/버그 리스트 서버 요청
  Future<void> _getFeedbackList() async {
    print('getFeedbackList안!!');
    try {
      final response = await SettingAPIService().viewFeedbackList();
      if (response.statusCode == 200) {
        print('StatusCode 200 !!!!!!!!!!!!');
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> noticeData = json.decode(decodedBody);
        setState(() {
          _feedbackList = noticeData
              .map((json) => json != null ? FeedbackList.fromJson(json) : null)
              .whereType<FeedbackList>() // null 필터링
              .toList();
          _feedbackList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          _isLoading = false;
        });
      } else {
        throw Exception('피드백 리스트 가져오기 실패 ${response.statusCode}');
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
    _getFeedbackList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? CustomCircularProgressIndicator()
            : Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.015, bottom: screenHeight * 0.03),
              child: ListView.builder(
                  itemCount: _feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedbackList = _feedbackList[index];
                    final isReply = feedbackList.answer != null;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.01),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckFeedbackList(feedbackList: feedbackList, isReply: isReply,)));
                          },
                          child: Container(
                            width: screenWidth * 0.89,
                            height: screenHeight * 0.093,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.018),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '[${_getDisplayCategory(feedbackList.category)}]',
                                        style: textTheme.bodySmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Text(
                                        '${feedbackList.inquiriesTitle}',
                                        style: textTheme.bodySmall
                                            ?.copyWith(fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_formatDateOnly(feedbackList.createdAt)}',
                                        style: textTheme.bodySmall
                                            ?.copyWith(fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        isReply ? '답변 완료' : '답변 미완료',
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: isReply
                                              ? Color(0xFFA2CE8A)
                                              : Color(0xFFFAB457),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ));
  }
}
