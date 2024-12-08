import 'package:flutter/material.dart';

class StretchingContentOrigin extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  const StretchingContentOrigin(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.description});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(name, style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Image.asset(
          imageUrl,
          width: screenWidth * 0.8,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          description,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class StretchingContentReverse extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  const StretchingContentReverse(
      {super.key,
        required this.name,
        required this.imageUrl,
        required this.description});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(name, style: textTheme.bodyLarge),
        SizedBox(height: screenHeight * 0.02),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // 좌우 반전
          child: Image.asset(
            imageUrl,
            width: screenWidth * 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          description,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
