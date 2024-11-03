import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/layout/setting_layout.dart';
import 'package:intl/intl.dart';

import '../../model/setting/feedback_list.dart';

class CheckFeedbackList extends StatelessWidget {
  final FeedbackList feedbackList;
  final bool isReply;
  const CheckFeedbackList(
      {required this.isReply, required this.feedbackList, super.key});

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    SizedBox verticalSpace = SizedBox(height: screenHeight * 0.02);

    return SettingLayout(
        title: '문의 확인',
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
          child: SingleChildScrollView(
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
                    Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.035,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Center(
                            child: Text(
                                _getDisplayCategory(feedbackList.category),
                                style: textTheme.bodyMedium)))
                  ],
                ),
                verticalSpace,
                Row(
                  children: [
                    Text(
                      '제목',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: screenWidth * 0.08,
                    ),
                    Expanded(
                        child: Text(
                      feedbackList.inquiriesTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ))
                  ],
                ),
                verticalSpace,
                Row(children: [
                  Text(
                    '상태',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: screenWidth * 0.08,
                  ),
                  Text(
                    isReply ? '답변 완료' : '답변 미완료',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isReply ? Color(0xFFA2CE8A) : Color(0xFFFAB457),
                    ),
                  ),
                ]),
                verticalSpace,
                Text(
                  '내용',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: screenWidth * 0.83,
                      //height: screenHeight * 0.093,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          feedbackList.content,
                          style: textTheme.bodyMedium,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                      )),
                ),
                verticalSpace,
                Visibility(
                    visible: isReply,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '답변',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: screenWidth * 0.83,
                              //height: screenHeight * 0.093,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  feedbackList.answer?.content ?? '답변 없음',
                                  style: textTheme.bodyMedium,
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                ),
                              )),
                        ),
                      ],
                    )),
                verticalSpace,
                Align(
                    alignment: Alignment.bottomCenter,
                    child: GreenButton(
                        text: '확인',
                        width: screenWidth * 0.61,
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
                verticalSpace,
                verticalSpace,
              ],
            ),
          ),
        ));
  }
}
