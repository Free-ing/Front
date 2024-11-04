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
    debugPrint("Fetching Exercise list");
    final response = await apiService.getExerciseList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> exerciseList = jsonData['result'];
        _exerciseList.clear();
        for (dynamic data in exerciseList) {
          ExerciseList exerciseCard = ExerciseList.fromJson(data);
          _exerciseList.add(exerciseCard);
        }
      }
      return _exerciseList;
    } else if (response.statusCode == 404) {
      return _exerciseList = [];
    } else {
      throw Exception('운동 리스트 가져오기 실패 ${response.statusCode}');
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
      itemCount: _exerciseList.length,
      itemBuilder: (context, index) {
        final exerciseList = _exerciseList[index];

        //Todo: 서버 요청 (운동 루틴 켜기)
        Future<void> _onExerciseRoutine() async {
          final responseCode =
              await apiService.onExerciseRoutine(exerciseList.routineId);
          if (responseCode == 200) {
            setState(() {
              exerciseList.status = !exerciseList.status;
            });
            debugPrint('운동 루틴 (${exerciseList.routineName}) 킴 on');
          } else {
            debugPrint('운동 루틴 (${exerciseList.routineName}) 켜는 중 오류 발생');
          }
        }

        //Todo: 서버 요청 (운동 루틴 끄기)
        Future<void> _offExerciseRoutine() async {
          final responseCode =
              await apiService.offExerciseRoutine(exerciseList.routineId);
          if (responseCode == 200) {
            setState(() {
              exerciseList.status = !exerciseList.status;
            });
            debugPrint('운동 루틴 (${exerciseList.routineName}) 끔 off');
          } else {
            debugPrint('운동 루틴 (${exerciseList.routineName}) 끄는 중 오류 발생');
          }
        }
        print(exerciseList.routineName);

        return GestureDetector(
          onLongPress: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                  routineId: exerciseList.routineId,
                  title: exerciseList.routineName,
                  selectImage: exerciseList.imageUrl,
                  category: '운동',
                  monday: exerciseList.monday,
                  tuesday: exerciseList.tuesday,
                  wednesday: exerciseList.wednesday,
                  thursday: exerciseList.thursday,
                  friday: exerciseList.friday,
                  saturday: exerciseList.saturday,
                  sunday: exerciseList.sunday,
                  startTime: exerciseList.startTime,
                  endTime: exerciseList.endTime,
                  explanation: exerciseList.explanation,
                  status: exerciseList.status,
                ),
              ),
            );
          },
          child: ToggledRoutineCard(
            imageUrl: exerciseList.imageUrl,
            title: exerciseList.routineName,
            status: exerciseList.status,
            explanation: exerciseList.explanation ?? '저장된 운동 루틴 설명이 없습니다.',
            onSwitch: () {
              _onExerciseRoutine();
              print('켜');
            },
            offSwitch: () {
              _offExerciseRoutine();
              print('꺼');
            },
          ),
        );
      },
    );
  }
}
