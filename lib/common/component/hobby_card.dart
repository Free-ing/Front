import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';

class HobbyCard extends StatelessWidget {
  final int routineId;
  final String imageUrl;
  final String title;

  const HobbyCard({
    super.key,
    required this.routineId,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 6,
      shadowColor: YELLOW_SHADOW,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: EdgeInsets.all(12),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Stack(
          children: [
            _routineImage(imageUrl: imageUrl, screenWidth: screenWidth),
            _routineTitle(context: context, title: title),
          ],
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl, required double screenWidth}) {
    return Positioned(
      left: 15,
      right: 15,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: screenWidth * 0.3,
        height: screenWidth * 0.3,
      ),
    );
  }

  Widget _routineTitle({required BuildContext context, required String title}) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
    );
  }
}
