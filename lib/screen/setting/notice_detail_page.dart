import 'package:flutter/material.dart';
import 'package:freeing/layout/setting_layout.dart';
import '../../model/setting/notice_list.dart';

class NoticeDetailPage extends StatelessWidget {
  final NoticeList noticeList;
  const NoticeDetailPage({required this.noticeList, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SettingLayout(
        title: noticeList.title,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('[${noticeList.category}]', style: textTheme.titleMedium),
                Text(noticeList.date, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300)),
              ],
            ),
            Text(
              noticeList.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ));
  }
}
