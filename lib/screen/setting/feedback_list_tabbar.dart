import 'package:flutter/material.dart';
import 'package:freeing/screen/setting/check_feedback_list.dart';

class FeedbackListTabbar extends StatefulWidget {
  const FeedbackListTabbar({super.key});

  @override
  State<FeedbackListTabbar> createState() => _FeedbackListTabbarState();
}

class _FeedbackListTabbarState extends State<FeedbackListTabbar> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isReply = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckFeedbackList()));},
                child: Container(
                  width: screenWidth * 0.89,
                  height: screenHeight * 0.093,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal :screenWidth * 0.04, vertical: screenHeight * 0.018),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '[문의 유형]',
                              style: textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              '문의 제목',
                              style: textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '2024년 9월 17일',
                              style: textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              isReply ? '답변 완료' : '답변 미완료',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isReply ? Color(0xFFA2CE8A): Color(0xFFFAB457),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
