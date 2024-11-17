import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/ad_mob_service.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/service/setting_api_service.dart';
import 'package:freeing/navigationbar/custom_bottom_navigationbar.dart';
import 'package:freeing/screen/member/guide_screen.dart';
import 'package:freeing/screen/setting/account_management_page.dart';
import 'package:freeing/screen/setting/feedback_page.dart';
import 'package:freeing/screen/setting/notice_page.dart';
import 'package:freeing/screen/setting/ready_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class User {
  final String email;
  final String name;
  final int userId;

  User({required this.email, required this.name, required this.userId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      userId: json['userId'],
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _email = '';
  String _name = '';
  BannerAd? _bannerAd;
  final String _instagramUrl =
      'https://www.instagram.com/free.ing_official?igsh=bm94Nm1nZGg0cXVi';

  // TODO: 인스타그램으로 이동
  Future<void> _launchInstagram() async {
    final Uri url = Uri.parse(_instagramUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_instagramUrl';
    }
  }

  // TODO: 서버 요청
  Future<void> _viewUserInfo() async {
    final response = await SettingAPIService().getUserInfo();

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final userData = User.fromJson(json.decode(decodedBody));
      setState(() {
        _email = userData.email;
        _name = userData.name;
      });
    } else {
      throw Exception('사용자 정보 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _viewUserInfo();
    _loadBannerAd();
  }

  //Todo: 배너 광고 생성
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: 0,
          width: screenWidth,
          child: Image.asset(
            'assets/imgs/background/background_image_setting.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.10,
              right: screenWidth * 0.10,
              top: screenWidth * 0.153,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          //color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                Image.asset('assets/imgs/setting/user_img.jpg'),
                          )),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_name  님",
                          style: textTheme.headlineSmall
                              ?.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: screenHeight * 0.018,
                        ),
                        Text(
                          _email,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.023,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: screenWidth * 0.70,
                    height: screenHeight * 0.045,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountManagementPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(width: 1, color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.white,
                        foregroundColor: ORANGE,
                      ),
                      child: Text(
                        '계정 관리',
                        style: textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.055,
                        ),
                        SettingTextButton(
                          address: 'assets/icons/setting_alarm.png',
                          text: '알림 설정',
                          targetPage: ReadyPage(
                            appBarTitle: '알림 설정',
                          ),
                        ),
                        SettingTextButton(
                          address: 'assets/icons/setting_notice.png',
                          text: '공지사항',
                          targetPage: NoticePage(),
                        ),
                        SettingTextButton(
                            address: 'assets/icons/setting_manual.png',
                            text: '이용 설명서',
                            targetPage: GuideScreen(
                              afterLogin: true,
                            )),
                        SettingTextButton(
                          address: 'assets/icons/setting_inquiry.png',
                          text: '문의/버그 신고',
                          targetPage: FeedbackPage(),
                        ),
                        SettingTextButton(
                          address: 'assets/icons/setting_review.png',
                          text: '앱 리뷰 남기기',
                          targetPage: ReadyPage(
                            appBarTitle: '앱 리뷰 남기기',
                          ),
                        ),
                        SettingTextButton(
                          address: 'assets/icons/setting_storage.png',
                          text: '임시 보관함',
                          targetPage: ReadyPage(
                            appBarTitle: '임시 보관함',
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),

                        /// 배너 광고
                        _bannerAd == null
                            ? Container()
                            : Container(
                                height: 75,
                                child: AdWidget(
                                  ad: _bannerAd!,
                                ),
                              ),
                        GestureDetector(
                            onTap: _launchInstagram,
                            child: Image.asset(
                                'assets/imgs/setting/instagram_banner.png')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3),
        ),
      ],
    );
  }
}
