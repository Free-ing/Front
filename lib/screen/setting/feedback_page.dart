import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/layout/setting_layout.dart';

import 'feedback_list_tabbar.dart';
import 'feedback_tabbar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: 1,
        animationDuration: const Duration(milliseconds: 100));

    tabController.addListener((){setState(() {
    });});
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SettingLayout(
      title: '문의/버그 신고',
      isLeftAndRightPadding: false,
      child: Column(
        children: [
          _tabBar(textTheme),
          Expanded(
            child: tabController.index==0 ? FeedbackListTabbar() : FeedbackTabbar(),
          )
        ],
      ),
    );
  }

  Widget _tabBar(TextTheme textTheme) {
    return TabBar(
      controller: tabController,
      tabs: const [Tab(text: '문의 내역'), Tab(text: '문의하기')],
      labelColor: Colors.black,
      labelPadding: EdgeInsets.symmetric(horizontal: 15),
      labelStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black),
      unselectedLabelColor: MEDIUM_GREY,
      unselectedLabelStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: MEDIUM_GREY),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashBorderRadius: BorderRadius.zero,
      indicatorColor: Colors.white,
      indicator:
          UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white)),
      dividerColor: Colors.transparent,
      padding: EdgeInsets.only(left: 0, right: 8, bottom: 4),
      isScrollable: true,
    );
  }
}
