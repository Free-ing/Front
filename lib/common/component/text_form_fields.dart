import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

// 그림자 스타일을 정의하는 열거형
enum ShadowStyle {
  none,
  grayInner,
  yellowOuter,
}

class CustomTextFormField extends StatefulWidget {
  final String? labelText; // 라벨 텍스트 (옵션)
  final String? hintText; // 힌트 텍스트 (옵션)
  final double width; // 너비
  final double height; // 높이
  final TextEditingController? controller;
  // final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final ShadowStyle shadowStyle; // 그림자 스타일
  final bool isPassword;
  final Function()? onSuffixIconTap;
  final bool showSuffixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLength;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.width = 260,
    this.height = 40,
    this.controller,
    // this.validator,
    this.keyboardType,
    this.shadowStyle = ShadowStyle.none,
    this.isPassword = false,
    this.onSuffixIconTap,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.enabled = true,
    this.maxLength,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isFocused = false;
  late FocusNode _focusNode;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);

    widget.controller?.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      _currentLength = widget.controller!.text.length;
    });
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  BoxShadow? _getBoxShadow() {
    if (_isFocused) {
      return BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          offset: Offset(2, 2),
          blurRadius: 4,
          spreadRadius: 2);
    } else {
      switch (widget.shadowStyle) {
        case ShadowStyle.grayInner:
          return BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              offset: Offset(2, 2),
              blurRadius: 4,
              spreadRadius: -2);
        case ShadowStyle.yellowOuter:
          return BoxShadow(
            color: YELLOW_SHADOW.withOpacity(0.3),
            spreadRadius: 1,
            offset: Offset(2, 2),
            blurRadius: 2,
          );
        case ShadowStyle.none:
        default:
          return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.06;
    final textTheme = Theme.of(context).textTheme;
    List<BoxShadow> boxShadows = [];
    BoxShadow? shadow = _getBoxShadow();
    if (shadow != null) {
      boxShadows.add(shadow);
    }

    return Center(
      child: SizedBox(
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
            ],
            Expanded(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: boxShadows,
                ),
                child: TextFormField(
                  textAlignVertical: screenHeight < screenHeight * 0.08 ? TextAlignVertical.center : null,
                  enabled: widget.enabled,
                  obscureText: widget.isPassword,
                  style: textTheme.bodySmall?.copyWith(color: Colors.black, fontWeight: FontWeight.w300),
                  controller: widget.controller,
                  focusNode: _focusNode,
                  // validator: widget.validator,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.isPassword ? 1 : null, // 높이에 따라 다중 라인 설정
                  maxLength: widget.maxLength,
                  buildCounter: (
                      BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) {
                    return null; // 기본 카운터 비활성화
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: textTheme.bodySmall?.copyWith(color: TEXT_GREY, fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: widget.suffixIcon,
                  ),
                ),
              ),
            ),
            if (widget.maxLength != null) ...[
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0, right: screenWidth * 0.05),
                  child: Text(
                    '$_currentLength / ${widget.maxLength}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey, // 글자 수 표시
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class GrayTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final double? width;
  final double? height;
  final String? labelText;
  final String? hintText;
  final bool enabled;

  const GrayTextFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.width, // 필요 시 커스터마이즈 가능하도록
    this.height, // 필요 시 커스터마이즈 가능하도록
    this.labelText,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.067;

    return CustomTextFormField(
      labelText: labelText ?? '이메일',
      hintText: hintText ?? '',
      width: width ?? screenWidth,
      height: height ?? screenHeight,
      controller: controller,
      // validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.grayInner, // 포커스 시 회색 내부 그림자
      enabled: enabled,
    );
  }
}

class GrayTextFormFieldWithEye extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final double? width;
  final double? height;
  final String? labelText;
  final String? hintText;
  final bool showSuffixIcon;
  final bool isPassword;
  final Function()? onSuffixIconTap;
  final bool enabled;

  const GrayTextFormFieldWithEye({
    required this.controller,
    this.validator,
    this.keyboardType,
    this.width,
    this.height,
    this.labelText,
    this.hintText,
    this.showSuffixIcon = false,
    this.isPassword = false,
    this.onSuffixIconTap,
    this.enabled = true,
    super.key,
  });

  @override
  State<GrayTextFormFieldWithEye> createState() =>
      _GrayTextFormFieldWithEyeState();
}

class _GrayTextFormFieldWithEyeState extends State<GrayTextFormFieldWithEye> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.067;

    return CustomTextFormField(
      labelText: widget.labelText ?? '비밀번호',
      hintText: widget.hintText ?? '',
      width: widget.width ?? screenWidth,
      height: widget.height ?? screenHeight,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.grayInner, // 포커스 시 회색 내부 그림자
      isPassword: _isObscured,
      enabled: widget.enabled,
      suffixIcon: GestureDetector(
        onTap: _togglePasswordVisibility,
        child: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.black,
        ),
      ),
      showSuffixIcon: true,
    );
  }
}

class GrayTextFormFieldWithButton extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  //final FormFieldValidator<String>? validator;
  //final bool obscureText;
  final double? width;
  final double? height;
  final TextInputType? keyboardType;
  final VoidCallback onButtonPressed;
  final String buttonText;
  final bool enabled;

  const GrayTextFormFieldWithButton({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    //this.validator,
    //this.obscureText = false,
    this.width,
    this.height,
    this.keyboardType,
    required this.onButtonPressed,
    required this.buttonText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.067;

    return CustomTextFormField(
      controller: controller,
      labelText: labelText ?? '이메일',
      hintText: hintText ?? '이메일을 입력해주세요.',
      //validator: validator,
      //obscureText: obscureText,
      width: width ?? screenWidth,
      height: height ?? screenHeight,
      keyboardType: keyboardType,
      enabled: enabled,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            foregroundColor: Colors.black,
            padding: EdgeInsets.zero,
            fixedSize: Size(105, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: Colors.black,
              ),
            ),
          ),
          onPressed: onButtonPressed,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class GrayTextFormFieldWihTimerButton extends StatefulWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final VoidCallback onButtonPressed;
  final bool enabled;
  final bool isVisible;

  const GrayTextFormFieldWihTimerButton({
    this.controller,
    this.width,
    this.height,
    required this.onButtonPressed,
    this.enabled = true,
    this.isVisible = true,
    super.key,
  });

  @override
  State<GrayTextFormFieldWihTimerButton> createState() =>
      _GrayTextFormFieldWihTimerButtonState();
}

class _GrayTextFormFieldWihTimerButtonState
    extends State<GrayTextFormFieldWihTimerButton> {
  Timer? _timer;
  int _start = 300;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          bool isVisible = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      setState(() {
        bool isVisible = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.067;

    return Container(
      width: widget.width ?? screenWidth,
      height: widget.height ?? screenHeight,
      child: Row(
        children: [
          CustomTextFormField(
            controller: widget.controller,
            hintText: '인증번호를 입력해주세요.',
            width: 254,
            keyboardType: TextInputType.number,
            enabled: widget.enabled,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 15.0),
              child: Visibility(
                visible: widget.isVisible,
                child: Text(
                  '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          SizedBox(
            width: 57.5,
            height: 30,
            child: ElevatedButton(
              onPressed: widget.onButtonPressed,
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 1,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class YellowTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final double? width;
  final double? height;
  final String? hintText;
  final bool enabled;
  final int? maxLength;

  const YellowTextFormField({
    Key? key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.width, // 필요 시 커스터마이즈 가능하도록
    this.height, // 필요 시 커스터마이즈 가능하도록
    this.hintText,
    this.enabled = true,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.72;
    final screenHeight = MediaQuery.of(context).size.height * 0.1;

    return CustomTextFormField(
      width: width ?? screenWidth,
      height: height ?? screenHeight,
      controller: controller,
      maxLength: maxLength,
      // validator: validator,
      enabled: enabled,
      keyboardType: keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.yellowOuter, // 포커스 시 회색 내부 그림자
    );
  }
}
