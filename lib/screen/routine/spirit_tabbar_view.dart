import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/toggled_routine_card.dart';
import 'package:freeing/common/service/spirit_api_service.dart';
import 'package:freeing/model/spirit/spirit_list.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';

class SpiritTabBarView extends StatefulWidget {
  const SpiritTabBarView({super.key});

  @override
  State<SpiritTabBarView> createState() => _SpiritTabBarViewState();
}

class _SpiritTabBarViewState extends State<SpiritTabBarView> {
  List<SpiritList> _spiritList = [];

  final apiService = SpiritAPIService();

  //Todo: 서버 요청 (마음 채우기 리스트 조회)
  Future<List<SpiritList>> _fetchSpiritList() async {
    debugPrint("Fetching Spirit list");
    final response = await apiService.getSpiritList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> spiritList = jsonData['result'];
        _spiritList.clear();
        for (dynamic data in spiritList) {
          SpiritList spiritCard = SpiritList.fromJson(data);
          _spiritList.add(spiritCard);
        }
      }
      return _spiritList;
    } else if (response.statusCode == 404) {
      return _spiritList = [];
    } else {
      throw Exception('마음 채우기 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSpiritList().then((spirits) {
      setState(() {
        _spiritList = spirits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _spiritList.length,
      itemBuilder: (context, index) {
        final spiritList = _spiritList[index];

        //Todo: 서버 요청 (마음 채우기 루틴 켜기)
        Future<void> _onSpiritRoutine() async {
          final responseCode =
              await apiService.onSpiritRoutine(spiritList.routineId);
          if (responseCode == 200) {
            setState(() {
              spiritList.status = !spiritList.status;
            });
            debugPrint('마음 채우기 루틴 (${spiritList.spiritName}) 킴 on.');
          } else {
            debugPrint(
                '마음 채우기 루틴 (${spiritList.spiritName}) 켜는 중 오류 발생 ${responseCode}.');
          }
        }

        //Todo: 서버 요청 (마음 채우기 루틴 끄기)
        Future<void> _offSpiritRoutine() async {
          final responseCode =
              await apiService.offSpiritRoutine(spiritList.routineId);
          if (responseCode == 200) {
            setState(() {
              spiritList.status = !spiritList.status;
            });
            print('마음 채우기 루틴 (${spiritList.spiritName}) 끔 off.');
          } else {
            print(
                '마음 채우기 루틴 (${spiritList.spiritName}) 끄는 중 오류 발생 ${responseCode}.');
          }
        }

        return GestureDetector(
          onLongPress: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                  routineId: spiritList.routineId,
                  title: spiritList.spiritName,
                  selectImage: spiritList.imageUrl,
                  category: '마음 채우기',
                  monday: spiritList.monday,
                  tuesday: spiritList.tuesday,
                  wednesday: spiritList.wednesday,
                  thursday: spiritList.thursday,
                  friday: spiritList.friday,
                  saturday: spiritList.saturday,
                  sunday: spiritList.sunday,
                  startTime: spiritList.startTime,
                  endTime: spiritList.endTime,
                  explanation: spiritList.explanation,
                  status: spiritList.status,
                ),
              ),
            );
          },
          child: ToggledRoutineCard(
            imageUrl: spiritList.imageUrl,
            title: spiritList.spiritName,
            explanation: spiritList.explanation ?? '저장된 마음 채우기 루틴 설명이 없습니다.',
            status: spiritList.status,
            onSwitch: () {
              _onSpiritRoutine();
              print('켜');
            },
            offSwitch: () {
              _offSpiritRoutine();
              print('꺼');
            },
          ),
        );
      },
    );
  }
}
