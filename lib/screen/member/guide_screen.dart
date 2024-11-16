import 'package:flutter/material.dart';
import 'package:freeing/common/component/buttons.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/member/login.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final int _totalPages = 5; // 총 페이지 수
  double _progress = 1 / (5 - 1); // 초기 진행 상태
  // PageController _imageController1 = PageController();
  // PageController _imageController2 = PageController();
  // PageController _imageController3 = PageController();
  // PageController _imageController4 = PageController();

  List<PageController> _imageControllers = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // _imageController1 = PageController(viewportFraction: 0.66);
    // _imageController2 = PageController(viewportFraction: 0.66);
    // _imageController3 = PageController(viewportFraction: 0.66);
    // _imageController4 = PageController(viewportFraction: 0.66);

    _pageController.addListener(() {
      setState(() {
        _progress = (_pageController.page! + 1) / (_totalPages - 1);
      });
    });
    // 각 가이드마다 PageController 초기화
    for (int i = 0; i < 4; i++) {
      _imageControllers.add(PageController(viewportFraction: 0.66));
    }
  }

  @override
  void dispose() {
    // _imageController1.dispose();
    // _imageController2.dispose();
    // _imageController3.dispose();
    // _imageController4.dispose();
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

    List<Widget> guide = [
      _buildGuide1(screenWidth, screenHeight, textTheme, _imageControllers[0]),
      _buildGuide2(screenWidth, screenHeight, textTheme, _imageControllers[1]),
      _buildGuide3(screenWidth, screenHeight, textTheme, _imageControllers[2]),
      _buildGuide4(screenWidth, screenHeight, textTheme, _imageControllers[3]),
      _buildGoToLogin(screenWidth, screenHeight, textTheme)
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
                SizedBox(height: screenHeight * 0.028),
                SizedBox(
                  height: screenHeight * 0.87,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: guide.length,
                    itemBuilder: (BuildContext context, int index) {
                      return guide[index];
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Todo: 이용 가이드 1 - 스트레스 지수 측정
  Widget _buildGuide1(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.201,
          child: Column(
            children: [
              Text(
                '스트레스 지수 측정',
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
                    '은 스트레스 관리 애플리케이션입니다.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.028),
              Text(
                '대한민국 보건복지부에서 발표한 설문조사로\n'
                '꾸준히 스트레스 지수를 측정하여\n'
                '변화하는 자신을 기록으로 남겨보세요.',
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.028),
        SizedBox(
          //width: screenWidth * 0.66,
          height: screenHeight * 0.64,
          child: PageView.builder(
            controller: imageController,
            itemCount: 2, // 이미지 개수
            itemBuilder: (context, index) {
              return _buildAnimatedImage(
                  index,
                  [
                    'assets/imgs/guide/guide_image_1.png',
                    'assets/imgs/guide/guide_image_2.png'
                  ],
                  imageController);
            },
          ),
        ),
      ],
    );
  }

  // Todo: 이용 가이드 2 - 나만의 스트레스 관리 루틴
  Widget _buildGuide2(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.201,
          child: Column(
            children: [
              Text(
                '나만의 스트레스 관리 루틴',
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
                    '은 루틴을 통해 스트레스 관리를 돕습니다.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.028),
              Text(
                '운동, 수면, 취미, 마음채우기,\n'
                '4개의 카테고리로 자신만의 루틴을 세워\n'
                '스트레스를 관리해보세요.',
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.028),
        SizedBox(
          //width: screenWidth * 0.66,
          height: screenHeight * 0.64,
          child: PageView.builder(
            controller: imageController,
            itemCount: 2, // 이미지 개수
            itemBuilder: (context, index) {
              return _buildAnimatedImage(
                  index,
                  [
                    'assets/imgs/guide/guide_image_3.png',
                    'assets/imgs/guide/guide_image_4.png',
                  ],
                  imageController);
            },
          ),
        ),
      ],
    );
  }

  // Todo: 이용 가이드 3 - 피드백 제공
  Widget _buildGuide3(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.201,
          child: Column(
            children: [
              Text(
                '피드백 제공',
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
                    '은 스트레스 관리를 위한 피드백을 제공합니다.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.028),
              Text(
                '루틴 트래커를 통해 한 달간의 루틴 수행 여부와\n'
                '기록한 운동, 수면에 대한 주간 리포트로\n'
                '일상생활의 가이드를 제공해요.',
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.028),
        SizedBox(
          //width: screenWidth * 0.66,
          height: screenHeight * 0.64,
          child: PageView.builder(
            controller: imageController,
            itemCount: 3, // 이미지 개수
            itemBuilder: (context, index) {
              return _buildAnimatedImage(
                  index,
                  [
                    'assets/imgs/guide/guide_image_5.png',
                    'assets/imgs/guide/guide_image_6.png',
                    'assets/imgs/guide/guide_image_7.png'
                  ],
                  imageController);
            },
          ),
        ),
      ],
    );
  }

  // Todo: 이용 가이드 4 - 정서적 교감
  Widget _buildGuide4(
      screenWidth, screenHeight, textTheme, PageController imageController) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.201,
          child: Column(
            children: [
              Text(
                '정서적 교감',
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
                    '은 사용자를 응원합니다.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.028),
              Text(
                '취미 활동 기록, 감정일기 작성을 통한\n'
                'AI 편지 기능을 제공합니다.\n'
                '따뜻한 위로로 하루를 마무리하도록 도울게요.',
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.028),
        SizedBox(
          //width: screenWidth * 0.66,
          height: screenHeight * 0.64,
          child: PageView.builder(
            controller: imageController,
            itemCount: 3, // 이미지 개수
            itemBuilder: (context, index) {
              return _buildAnimatedImage(
                  index,
                  [
                    'assets/imgs/guide/guide_image_9.png',
                    'assets/imgs/guide/guide_image_10.png',
                    'assets/imgs/guide/guide_image_11.png'
                  ],
                  imageController);
            },
          ),
        ),
      ],
    );
  }

  // Todo: 로그인 하러 가기
  Widget _buildGoToLogin(screenWidth, screenHeight, textTheme) {
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
              MaterialPageRoute(
                  builder: (context) =>
                     Login()),
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
