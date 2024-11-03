import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/toggled_routine_card.dart';
import 'package:freeing/common/service/exercise_api_service.dart';
import 'package:freeing/model/exercise/exercise_list.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';

class ExerciseTabBarView extends StatefulWidget {
  const ExerciseTabBarView({super.key});

  @override
  State<ExerciseTabBarView> createState() => _ExerciseTabBarViewState();
}

class _ExerciseTabBarViewState extends State<ExerciseTabBarView> {
  List<ExerciseList> _exerciseList = [];

  final apiService = ExerciseAPIService();

  //Todo: 서버 요청 (운동 리스트 조회)
  Future<List<ExerciseList>> _fetchExerciseList() async {
    print("Fetching Spirit list");
    final response = await apiService.getExerciseList();

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> spiritList = jsonData['result'];
        _exerciseList.clear();
        for (dynamic data in spiritList) {
          ExerciseList spiritCard = ExerciseList.fromJson(data);
          _exerciseList.add(spiritCard);
        }
      }
      return _exerciseList;
    } else if (response.statusCode == 404) {
      return _exerciseList = [];
    } else {
      throw Exception('마음 채우기 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  void initState() {
    super.initState();
    _fetchExerciseList().then((exercises) {
      setState(() {
        _exerciseList = exercises;
      });
    });
  }

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
