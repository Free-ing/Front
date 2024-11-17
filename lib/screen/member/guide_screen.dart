import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/member/login.dart';

class GuideScreen extends StatefulWidget {
  final bool? afterLogin;

  const GuideScreen({super.key, this.afterLogin});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final int _totalPages = 5; // 총 페이지 수
  double _progress = 1 / (5 - 1); // 초기 진행 상태
  bool _afterLogin = false;

  List<PageController> _imageControllers = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _progress = (_pageController.page! + 1) / (_totalPages - 1);
      });
    });
    // 각 가이드마다 PageController 초기화
    for (int i = 0; i < 4; i++) {
      _imageControllers.add(PageController(viewportFraction: 0.66));
    }

    _afterLogin = widget.afterLogin ?? false;
  }

  @override
  void dispose() {
    _pageController.dispose();

    // 각 imageController도 dispose 해줍니다.
    for (var controller in _imageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<Widget> guide = _afterLogin
        ? [
            _guide1(screenWidth, screenHeight, textTheme, _imageControllers[0]),
            _guide2(screenWidth, screenHeight, textTheme, _imageControllers[1]),
            _guide3(screenWidth, screenHeight, textTheme, _imageControllers[2]),
            _guide4(screenWidth, screenHeight, textTheme, _imageControllers[3]),
          ]
        : [
            _guide1(screenWidth, screenHeight, textTheme, _imageControllers[0]),
            _guide2(screenWidth, screenHeight, textTheme, _imageControllers[1]),
            _guide3(screenWidth, screenHeight, textTheme, _imageControllers[2]),
            _guide4(screenWidth, screenHeight, textTheme, _imageControllers[3]),
            _goToLogin(screenWidth, screenHeight, textTheme)
          ];

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imgs/background/background_image_home.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle(screenWidth),
                SizedBox(height: screenHeight * 0.028),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: guide.length,
                    itemBuilder: (BuildContext context, int index) {
                      return guide[index];
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.028),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: screenHeight * 0.6,
        //   right: screenWidth * 0,
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.arrow_forward_ios_rounded,
        //       size: 35,
        //       color: DARK_GREY,
        //     ),
        //   ),
        // ),
        // Positioned(
        //   top: screenHeight * 0.6,
        //   left: screenWidth * 0,
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.arrow_back_ios_rounded,
        //       size: 35,
        //       color: DARK_GREY,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTitle(screenWidth) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PreferredSize(
          preferredSize: const Size(double.infinity, 4.0),
          child: Container(
            width: screenWidth * 0.51,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: BASIC_GREY,
                valueColor: const AlwaysStoppedAnimation<Color>(ORANGE),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _afterLogin,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_rounded),
              iconSize: 35.0,
              highlightColor: Colors.grey[100],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContent({
    required TextTheme textTheme,
    required double screenWidth,
    required double screenHeight,
    required PageController imageController,
    required String title,
    required String subTitle,
    required String body,
    required List<String> images,
  }) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.201,
          child: Column(
            children: [
              Text(
                title,
                style: textTheme.headlineLarge,
              ),
              SizedBox(height: screenHeight * 0.028),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Freeing',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    subTitle,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.028),
              Text(
                body,
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.028),
        Flexible(
            child: PageView.builder(
          controller: imageController,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _buildAnimatedImage(
              index,
              images,
              imageController,
            );
          },
        ))
      ],
    );
  }

  // Todo: 이용 가이드 1 - 스트레스 지수 측정
  Widget _guide1(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return _buildContent(
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      imageController: imageController,
      title: '스트레스 지수 측정',
      subTitle: '은 스트레스 관리 애플리케이션입니다.',
      body: '대한민국 보건복지부에서 발표한 설문조사로\n'
          '꾸준히 스트레스 지수를 측정하여\n'
          '변화하는 자신을 기록으로 남겨보세요.',
      images: [
        'assets/imgs/guide/guide_image_1.png',
        'assets/imgs/guide/guide_image_2.png'
      ],
    );
  }

// Todo: 이용 가이드 2 - 나만의 스트레스 관리 루틴
  Widget _guide2(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return _buildContent(
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      imageController: imageController,
      title: '나만의 스트레스 관리 루틴',
      subTitle: '은 루틴을 통해 스트레스 관리를 돕습니다.',
      body: '운동, 수면, 취미, 마음채우기,\n'
          '4개의 카테고리로 자신만의 루틴을 세워\n'
          '스트레스를 관리해보세요.',
      images: [
        'assets/imgs/guide/guide_image_3.png',
        'assets/imgs/guide/guide_image_4.png',
      ],
    );
  }

  // Todo: 이용 가이드 3 - 피드백 제공
  Widget _guide3(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return _buildContent(
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      imageController: imageController,
      title: '피드백 제공',
      subTitle: '은 스트레스 관리를 위한 피드백을 제공합니다.',
      body: '루틴 트래커를 통해 한 달간의 루틴 수행 여부를 확인하고,\n'
          '운동 리포트와 수면 리포트를 통해\n'
          '사용자가 수행한 루틴에 대한 피드백을 제공받을 수 있어요.',
      images: [
        'assets/imgs/guide/guide_image_5.png',
        'assets/imgs/guide/guide_image_6.png',
        'assets/imgs/guide/guide_image_7.png'
      ],
    );
  }

  // Todo: 이용 가이드 4 - 정서적 교감
  Widget _guide4(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return _buildContent(
      textTheme: textTheme,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      imageController: imageController,
      title: '정서적 교감',
      subTitle: '은 사용자를 응원합니다.',
      body: '취미 활동 기록, 감정일기 작성을 통한\n'
          'AI 편지 기능을 제공합니다.\n'
          '따뜻한 위로로 하루를 마무리하도록 도울게요.',
      images: [
        'assets/imgs/guide/guide_image_9.png',
        'assets/imgs/guide/guide_image_10.png',
        'assets/imgs/guide/guide_image_11.png'
      ],
    );
  }

  // Todo: 로그인 하러 가기
  Widget _goToLogin(screenWidth, screenHeight, textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/imgs/home/logo.png'),
        SizedBox(height: screenHeight * 0.05),
        RichText(
          text: TextSpan(
            text: 'Freeing',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            children: <TextSpan>[
              TextSpan(
                text: '이 옆에서 도와드릴게요.\n\n이용 가이드는 설정 페이지에서\n언제든지 다시 볼 수 있습니다.',
                style: textTheme.titleSmall,
              )
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        GreenButton(
          width: screenWidth * 0.6,
          text: '로그인 하기',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedImage(
      int index, List<String> image, PageController imageController) {
    return AnimatedBuilder(
      animation: imageController,
      builder: (context, child) {
        double scale = 1.0;
        double opacity = 1.0;

        if (imageController.position.haveDimensions) {
          // 현재 페이지와 비교하여 스케일과 투명도를 계산
          double value = (imageController.page ?? 0) - index;
          scale =
              (1 - value.abs() * 0.3).clamp(0.7, 1.0); // 옆에 있는 이미지들은 스케일을 줄임
          opacity =
              (1 - value.abs() * 0.3).clamp(0.7, 1.0); // 옆에 있는 이미지들은 투명도 70%로
        }

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              image[index],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
