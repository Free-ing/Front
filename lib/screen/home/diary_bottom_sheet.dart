import 'package:flutter/material.dart';
import 'package:freeing/common/component/bottom_sheet.dart';
import 'package:freeing/common/component/dialog_manager.dart';
import 'package:freeing/common/component/question_mark.dart';
import 'package:freeing/common/component/text_form_fields.dart';
import 'package:freeing/common/component/toast_bar.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/spirit_api_sevice.dart';

//Todo: 감정 일기
void showDiaryBottomSheet(
  BuildContext context,
  String title,
  // int year,
  // int month,
  // int day,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context, TextTheme textTheme) {
      return _DiaryBottomSheetContent(
        title: title,
        textTheme: textTheme,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        // year: year,
        // month: month,
        // day: day,
      );
    },
  );
}

class _DiaryBottomSheetContent extends StatefulWidget {
  final String title;
  final TextTheme textTheme;
  final double screenWidth;
  final double screenHeight;
  // final int year;
  // final int month;
  // final int day;

  const _DiaryBottomSheetContent({
    super.key,
    required this.title,
    required this.textTheme,
    required this.screenWidth,
    required this.screenHeight,
    // required this.year,
    // required this.month,
    // required this.day,
  });

  @override
  _DiaryBottomSheetContentState createState() =>
      _DiaryBottomSheetContentState();
}

class _DiaryBottomSheetContentState extends State<_DiaryBottomSheetContent> {
  int? selectedIndex;
  bool _getAiLetter = true;

  final TextEditingController wellDoneController = TextEditingController();
  final TextEditingController hardWorkController = TextEditingController();

  List<String> emotionList = ['HAPPY', 'CALM', 'ANXIETY', 'ANGRY', 'SAD'];

  void handleButtonSelected(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });
  }

  //Todo: 서버 요청 (감정 일기 작성)
  Future<void> _submitEmotionalDiary() async {
    final String wellDone = wellDoneController.text;
    final String hardWork = hardWorkController.text;
    String emotion = 'default';
    final apiService = SpiritAPIService();

    if (selectedIndex! >= 0) {
      emotion = emotionList[selectedIndex!];
    } else {
      print('Invalid index: $selectedIndex');
    }

    print(emotion);
    print(wellDone);
    print(wellDoneController.text);
    print(hardWork);
    print(hardWorkController.text);
    print(_getAiLetter);

    if (wellDoneController.text.isNotEmpty &&
        hardWorkController.text.isNotEmpty) {
      final int response = await apiService.postEmotionalDiary(
        wellDone,
        hardWork,
        _getAiLetter,
        emotion,
      );

      if (response == 200) {
        Navigator.pop(context);
        if (_getAiLetter == true) {
          const ToastBarWidget(
            title: '감정 일기 작성이 저장되었습니다.\n편지가 도착하면 확인해보실 수 있어요.',
          ).showToast(context);
        } else {
          const ToastBarWidget(
            title: '감정 일기 작성이 저장되었습니다.',
          ).showToast(context);
        }
      } else if (response == 400) {
        DialogManager.showAlertDialog(
            context: context, title: '알림', content: '모두 입력해주세요{$response}.');
      } else {
        DialogManager.showAlertDialog(
          context: context,
          title: '알림',
          content: '서버에서 오류가 발생하였습니다.\n다시 시도해주세요. $response',
        );
      }
    } else {
      DialogManager.showAlertDialog(
        context: context,
        title: '알림',
        content: '모두 입력해주세요.(모두 입력 안됨)',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseAnimatedBottomSheetContent(
      title: widget.title,
      onButtonPressed: (AnimationController) async {
        await _submitEmotionalDiary();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.1),
        child: Column(
          children: [
            // Text(
            //   '${widget.year}년 ${widget.month}월 ${widget.day}일',
            //   style: widget.textTheme.titleSmall,
            // ),
            //SizedBox(height: widget.screenHeight * 0.03),
            _selectDailyEmotion(),
            SizedBox(height: widget.screenHeight * 0.03),
            _wellDoneRecord(),
            SizedBox(height: widget.screenHeight * 0.03),
            _hardWorkRecord(),
            SizedBox(height: widget.screenHeight * 0.02),
            _checkAILetter(),
          ],
        ),
      ),
    );
  }

  //Todo: 오늘의 감정 고르기
  Widget _selectDailyEmotion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: widget.screenHeight * 0.02),
          child:
              Text('오늘 하루 동안의 기분을 알려 주세요.', style: widget.textTheme.bodyMedium),
        ),
        Center(
          child: SizedBox(
            width: widget.screenWidth,
            height: widget.screenHeight * 0.1,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: widget.screenWidth * 0.02);
              },
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                final imagePath = [
                  'assets/imgs/mind/emotion_happy',
                  'assets/imgs/mind/emotion_calm',
                  'assets/imgs/mind/emotion_anxiety',
                  'assets/imgs/mind/emotion_angry',
                  'assets/imgs/mind/emotion_sad',
                ];

                final label = ['기쁨', '평온', '불안', '분노', '슬픔'];

                return _SelectEmotionButton(
                  index: index,
                  imagePath: imagePath[index],
                  label: label[index],
                  onSelected: () => handleButtonSelected(index),
                  isSelected: selectedIndex == index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  //Todo: 칭찬 작성
  Widget _wellDoneRecord() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('칭찬하고 싶은 일을 알려주세요', style: widget.textTheme.bodyMedium),
        Text('*타인을 칭찬해도 좋고 나 자신을 칭찬해도 좋아요.',
            style: widget.textTheme.labelMedium),
        SizedBox(height: widget.screenHeight * 0.02),
        YellowTextFormField(
          width: widget.screenWidth,
          maxLength: 200,
          controller: wellDoneController,
        ),
      ],
    );
  }

  //Todo: 힘든 일 작성
  Widget _hardWorkRecord() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('힘들었던 일을 알려주세요', style: widget.textTheme.bodyMedium),
        SizedBox(height: widget.screenHeight * 0.02),
        YellowTextFormField(
          controller: hardWorkController,
          width: widget.screenWidth,
          maxLength: 200,
        ),
      ],
    );
  }

  //Todo: ai 답장 받기 체크
  Widget _checkAILetter() {
    return Row(
      children: [
        Checkbox(
          value: _getAiLetter,
          onChanged: (bool? newValue) {
            setState(
              () {
                _getAiLetter = newValue ?? false; // Ensure to handle null case
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          activeColor: BLUE_PURPLE,
        ),
        const Text('AI에게 답장 받기'),
        SizedBox(
          width: widget.screenWidth * 0.1,
          child: const QuestionMark(
            title: '오늘 하루 수고한 당신에게\n답장을 보내드릴게요.',
            content: '최대 10분 정도 소요될 수 있어요.\n광고를 시청하면 편지를 볼 수 있어요.',
            subContent: '*해당 기능은 GPT를 사용합니다. \n민감한 개인정보 입력은 유의해 주세요.',
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

//Todo: 감정 선택 버튼
class _SelectEmotionButton extends StatelessWidget {
  final int index;
  final String imagePath;
  final String label;
  final VoidCallback? onSelected;
  final bool isSelected;

  const _SelectEmotionButton({
    super.key,
    required this.index,
    required this.imagePath,
    required this.label,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              if (onSelected != null) {
                onSelected!();
              }
            },
            child: SizedBox(
              height: screenHeight * 0.06,
              child: isSelected
                  ? Image.asset(
                      '${imagePath}_on.png',
                      width: screenWidth * 0.16,
                    )
                  : Image.asset(
                      '${imagePath}_off.png',
                      width: screenWidth * 0.145,
                    ),
            )),
        SizedBox(height: screenWidth * 0.02),
        Text(label, style: textTheme.labelMedium),
      ],
    );
  }
}
