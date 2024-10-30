import 'package:flutter/material.dart';
import 'package:freeing/common/component/toggled_routine_card.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';

class ExerciseTabBarView extends StatefulWidget {
  const ExerciseTabBarView({super.key});

  @override
  State<ExerciseTabBarView> createState() => _ExerciseTabBarViewState();
}

class _ExerciseTabBarViewState extends State<ExerciseTabBarView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ToggledRoutineCard(
          imageUrl: 'https://freeingimage.s3.ap-northeast-2.amazonaws.com/select_exercise.png',
          title: '운동 루틴',
          status: false,
          explanation: '운동 루틴에 대한 설명',
          onSwitch: () {},
          offSwitch: () {},
        );

        //   final hobbyList = _hobbyList[index];
        //   return GestureDetector(
        //     onLongPress: () async {
        //       await Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => EditRoutineScreen(
        //             routineId: hobbyList.routineId,
        //             title: hobbyList.hobbyName,
        //             selectImage: hobbyList.imageUrl,
        //             category: '운동',
        //           ),
        //         ),
        //       );
        //     },
        //     child: ToggledRoutineCard(
        //       imageUrl: '',
        //       title: '',
        //       status: null,
        //       explanation: '',
        //       onSwitch: () {},
        //       offSwitch: () {},
        //     ),
        //   );
      },
    );
  }
}
