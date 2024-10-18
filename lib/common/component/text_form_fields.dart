import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

// 그림자 스타일을 정의하는 열거형
enum ShadowStyle {
  none,
  grayInner,
  yellowOuter,
}

// // CustomTextFormField 클래스 정의
// class CustomTextFormField extends StatefulWidget {
//   final String? labelText; // 라벨 텍스트 (옵션)
//   final String? hintText; // 힌트 텍스트 (옵션)
//   final double width; // 너비
//   final double height; // 높이
//   final TextEditingController? controller;
//   // final FormFieldValidator<String>? validator;
//   final TextInputType? keyboardType;
//   final ShadowStyle shadowStyle; // 그림자 스타일
//
//   const CustomTextFormField({
//     Key? key,
//     this.labelText,
//     this.hintText,
//     this.width = 260,
//     this.height = 40,
//     this.controller,
//     // this.validator,
//     this.keyboardType,
//     this.shadowStyle = ShadowStyle.none,
//   }) : super(key: key);
//
//   @override
//   _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
// }
//
// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   bool _isFocused = false;
//   late FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _focusNode.addListener(_handleFocusChange);
//   }
//
//   void _handleFocusChange() {
//     setState(() {
//       _isFocused = _focusNode.hasFocus;
//     });
//   }
//
//   @override
//   void dispose() {
//     _focusNode.removeListener(_handleFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   BoxShadow? _getBoxShadow() {
//     if (_isFocused) {
//       return BoxShadow(
//         color: Colors.grey.withOpacity(0.7),
//         offset: Offset(2, 2),
//         blurRadius: 4,
//         spreadRadius: 2
//       );
//     } else {
//       switch (widget.shadowStyle) {
//         case ShadowStyle.grayInner:
//           return BoxShadow(
//             color: Colors.grey.withOpacity(0.7),
//             offset: Offset(2, 2),
//             blurRadius: 4,
//             spreadRadius: -2
//           );
//         case ShadowStyle.yellowOuter:
//           return BoxShadow(
//             color: Colors.yellow.withOpacity(0.3),
//             spreadRadius: 1,
//             offset: Offset(2, 2),
//             blurRadius: 2,
//           );
//         case ShadowStyle.none:
//         default:
//           return null;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<BoxShadow> boxShadows = [];
//     BoxShadow? shadow = _getBoxShadow();
//     if (shadow != null) {
//       boxShadows.add(shadow);
//     }
//
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.labelText != null) ...[
//             Text(
//               widget.labelText!,
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height*0.001),
//           ],
//           Container(
//             width: widget.width,
//             height: widget.height,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.black, width: 1),
//               boxShadow: boxShadows,
//             ),
//             child: TextFormField(
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w300,
//                 color: Color(0xFF929292),
//               ),
//               controller: widget.controller,
//               focusNode: _focusNode,
//               // validator: widget.validator,
//               keyboardType: widget.keyboardType,
//               maxLines: widget.height > 40 ? null : 1, // 높이에 따라 다중 라인 설정
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 border: InputBorder.none,
//                 fillColor: Colors.transparent,
//                 filled: true,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class GrayTextFormField extends StatelessWidget {
//   final TextEditingController? controller;
//   final FormFieldValidator<String>? validator;
//   final TextInputType? keyboardType;
//   final double? width;
//   final double? height;
//   final String? labelText;
//   final String? hintText;
//
//   const GrayTextFormField({
//     Key? key,
//     this.controller,
//     this.validator,
//     this.keyboardType,
//     this.width, // 필요 시 커스터마이즈 가능하도록
//     this.height, // 필요 시 커스터마이즈 가능하도록
//     this.labelText,
//     this.hintText,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomTextFormField(
//       labelText: labelText ?? '이메일',
//       hintText: hintText ?? '',
//       width: width ?? 260,
//       height: height ?? 40,
//       controller: controller,
//       // validator: validator,
//       keyboardType: keyboardType ?? TextInputType.text,
//       shadowStyle: ShadowStyle.grayInner, // 포커스 시 회색 내부 그림자
//     );
//   }
// }
//
// class GrayTextFormFieldWithEye extends StatefulWidget {
//
//
//   const GrayTextFormFieldWithEye({super.key});
//
//   @override
//   State<GrayTextFormFieldWithEye> createState() => _GrayTextFormFieldWithEyeState();
// }
//
// class _GrayTextFormFieldWithEyeState extends State<GrayTextFormFieldWithEye> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

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
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
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
            color: Colors.yellow.withOpacity(0.3),
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
    List<BoxShadow> boxShadows = [];
    BoxShadow? shadow = _getBoxShadow();
    if (shadow != null) {
      boxShadows.add(shadow);
    }

    return Center(
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
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: boxShadows,
            ),
            child: TextFormField(
              obscureText: widget.isPassword,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFF929292),
              ),
              controller: widget.controller,
              focusNode: _focusNode,
              // validator: widget.validator,
              keyboardType: widget.keyboardType,
              maxLines: widget.height > 40 ? null : 1, // 높이에 따라 다중 라인 설정
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ],
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

  const GrayTextFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.width, // 필요 시 커스터마이즈 가능하도록
    this.height, // 필요 시 커스터마이즈 가능하도록
    this.labelText,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: labelText ?? '이메일',
      hintText: hintText ?? '',
      width: width ?? 260,
      height: height ?? 40,
      controller: controller,
      // validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.grayInner, // 포커스 시 회색 내부 그림자
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
    return CustomTextFormField(
      labelText: widget.labelText ?? '비밀번호',
      hintText: widget.hintText ?? '',
      width: widget.width ?? 260,
      height: widget.height ?? 40,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.grayInner, // 포커스 시 회색 내부 그림자
      isPassword: _isObscured,
      suffixIcon: GestureDetector(
        onTap: _togglePasswordVisibility,
        child: Icon(
          widget.isPassword
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: labelText ?? '이메일',
      hintText: hintText ?? '이메일을 입력해주세요.',
      //validator: validator,
      //obscureText: obscureText,
      width: width ?? 260,
      height: height ?? 40,
      keyboardType: keyboardType,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: MAIN_COLOR,
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
  final VoidCallback onButtonPressed;

  const GrayTextFormFieldWihTimerButton({
    this.controller,
    this.width,
    required this.onButtonPressed,
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 320,
      height: 40,
      child: Row(
        children: [
          CustomTextFormField(
            hintText: '인증번호를 입력해주세요.',
            width: 254,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top:8.0, right: 15.0),
              child: Text(
                '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
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
              onPressed: () {},
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MAIN_COLOR,
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

  const YellowTextFormField({
    Key? key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.width, // 필요 시 커스터마이즈 가능하도록
    this.height, // 필요 시 커스터마이즈 가능하도록
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      width: width ?? 260,
      height: height ?? 76,
      controller: controller,
      // validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      shadowStyle: ShadowStyle.yellowOuter, // 포커스 시 회색 내부 그림자
    );
  }
}
