import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
          child: SizedBox(
            height: 30.0,
            width: 30.0,
            child: CircularProgressIndicator(
              color: PRIMARY_COLOR,
              strokeWidth: 4.0,
            ),
          ),
        ),
    );
  }
}
