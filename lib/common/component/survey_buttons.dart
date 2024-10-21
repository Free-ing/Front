import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

//Todo: 카테고리 선택 버튼
class SelectCategoryButton extends StatefulWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onSelected;

  const SelectCategoryButton(
      {super.key,
      required this.imageUrl,
      required this.label,
      required this.onSelected});

  @override
  State<SelectCategoryButton> createState() => _SelectCategoryButtonState();
}

class _SelectCategoryButtonState extends State<SelectCategoryButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.37,
      height: screenWidth * 0.37,
      child: ElevatedButton(
        onPressed: widget.onSelected,
        style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: EdgeInsets.all(0),
            backgroundColor: LIGHT_GREY,
            foregroundColor: ORANGE,
            shadowColor: MEDIUM_GREY,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: MEDIUM_GREY,
                width: 1.0,
              ),
            )),
        child: Stack(
          children: [
            Positioned(
              left: 15,
              right: 15,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Todo: 정사각형 설문 버튼
class SquareSurveyButton extends StatefulWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onSelected;
  final bool isSelected;

  const SquareSurveyButton(
      {super.key,
      required this.imageUrl,
      required this.label,
      this.onSelected,
      required this.isSelected});

  @override
  State<SquareSurveyButton> createState() => _SquareSurveyButtonState();
}

class _SquareSurveyButtonState extends State<SquareSurveyButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.37,
      height: screenWidth * 0.37,
      child: ElevatedButton(
        onPressed: () {
          if (widget.onSelected != null) {
            widget.onSelected!();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: EdgeInsets.all(0),
          backgroundColor: widget.isSelected ? Colors.white : LIGHT_GREY,
          foregroundColor: ORANGE,
          shadowColor: widget.isSelected ? ORANGE : MEDIUM_GREY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: widget.isSelected ? ORANGE : MEDIUM_GREY,
              width: widget.isSelected ? 2.0 : 1.0,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 15,
              right: 15,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Todo: 직사각형 설문 버튼
class RectangleSurveyButton extends StatefulWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onSelected;
  final bool isSelected;

  const RectangleSurveyButton(
      {super.key,
      required this.imageUrl,
      required this.label,
      this.onSelected,
      required this.isSelected});

  @override
  State<RectangleSurveyButton> createState() => _RectangleSurveyButtonState();
}

class _RectangleSurveyButtonState extends State<RectangleSurveyButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.717,
      height: screenHeight * 0.069,
      child: ElevatedButton(
        onPressed: widget.onSelected,
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: EdgeInsets.all(0),
          backgroundColor: widget.isSelected ? Colors.white : LIGHT_GREY,
          foregroundColor: ORANGE,
          shadowColor: widget.isSelected ? ORANGE : MEDIUM_GREY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: widget.isSelected ? ORANGE : MEDIUM_GREY,
              width: widget.isSelected ? 2.0 : 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              width: 120,
              height: 120,
            ),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

//Todo: 원형 설문 버튼
class CircleSurveyButton extends StatefulWidget {
  final String label;
  final VoidCallback? onSelected;
  final bool isSelected;

  const CircleSurveyButton(
      {super.key,
      required this.label,
      this.onSelected,
      required this.isSelected});

  @override
  State<CircleSurveyButton> createState() => _CircleSurveyButtonState();
}

class _CircleSurveyButtonState extends State<CircleSurveyButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          width: widget.isSelected ? screenWidth * 0.12 : screenWidth * 0.1,
          height: widget.isSelected ? screenWidth * 0.12 : screenWidth * 0.1,
          child: ElevatedButton(
            onPressed: widget.onSelected,
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: EdgeInsets.all(0),
              backgroundColor: widget.isSelected ? Colors.white : LIGHT_GREY,
              foregroundColor: ORANGE,
              shadowColor: widget.isSelected ? ORANGE : MEDIUM_GREY,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: widget.isSelected ? ORANGE : MEDIUM_GREY,
                  width: widget.isSelected ? 2.0 : 1.0,
                ),
              ),
            ),
            child: Container(),
          ),
        ),
        SizedBox(
            height: widget.isSelected ? screenWidth * 0.08 : screenWidth * 0.1),
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

//Todo: Text만 있는 버튼
class OnlyTextButton extends StatefulWidget {
  final String label;
  final VoidCallback? onSelected;
  final bool isSelected;

  const OnlyTextButton(
      {super.key,
      required this.label,
      this.onSelected,
      required this.isSelected});

  @override
  State<OnlyTextButton> createState() => _OnlyTextButtonState();
}

class _OnlyTextButtonState extends State<OnlyTextButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.717,
      height: screenHeight * 0.069,
      child: ElevatedButton(
        onPressed: widget.onSelected,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: widget.isSelected ? Colors.white : LIGHT_GREY,
          foregroundColor: ORANGE,
          shadowColor: widget.isSelected ? ORANGE : MEDIUM_GREY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: widget.isSelected ? ORANGE : MEDIUM_GREY,
              width: widget.isSelected ? 2.0 : 1.0,
            ),
          ),
        ),
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
