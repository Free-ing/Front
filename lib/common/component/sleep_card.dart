import 'package:flutter/material.dart';

import '../../screen/routine/edit_routine_screen.dart';
import '../const/colors.dart';

class SleepCard extends StatefulWidget {
  int routineId;
  final String imageUrl;
  final String title;

  SleepCard({super.key, required this.routineId, required this.imageUrl, required this.title});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditRoutineScreen(routineId: widget.routineId, title: widget.title, selectImage: widget.imageUrl, category: '수면',),
        ));
      },
      child: Card(
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
              _routineImage(imageUrl: widget.imageUrl),
              _routineTitle(context: context, title: widget.title),
              _toggleSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routineImage({required String imageUrl}) {
    return Positioned(
      left: 15,
      right: 15,
      top: 13,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
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
      ),
    );
  }

  Widget _toggleSwitch() {
    return Positioned(
      top: 2,
      right: 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSwitched = !isSwitched;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSwitched ? Colors.black : DARK_GREY,
              ),
              color: isSwitched ? PRIMARY_COLOR : MEDIUM_GREY,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Thumb 부분
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  left: isSwitched ? 16.0 : 2.0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSwitched ? Colors.black : DARK_GREY,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 2.0,
                            spreadRadius: 0.2,
                            offset: Offset(0.0, 2.0),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
