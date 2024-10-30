import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/hobby_card.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/model/hobby/hobby_list.dart';
import 'package:freeing/screen/routine/edit_routine_screen.dart';

class HobbyTabBarView extends StatefulWidget {
  const HobbyTabBarView({super.key});

  @override
  State<HobbyTabBarView> createState() => _HobbyTabBarViewState();
}

class _HobbyTabBarViewState extends State<HobbyTabBarView> {
  List<HobbyList> _hobbyList = [];

  //Todo: 서버 요청 (취미 리스트 조회)
  Future<List<HobbyList>> _fetchHobbyList() async {
    final apiService = HobbyAPIService();
    final response = await apiService.getHobbyList();

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      if (jsonData is Map<String, dynamic>) {
        List<dynamic> hobbyList = jsonData['result'];
        _hobbyList.clear();
        for (dynamic data in hobbyList) {
          HobbyList hobbyCard = HobbyList.fromJson(data);
          _hobbyList.add(hobbyCard);
        }
      }
      return _hobbyList;
    } else if (response.statusCode == 404) {
      return _hobbyList = [];
    } else {
      throw Exception('취미 리스트 가져오기 실패 ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHobbyList().then((hobbies) {
      setState(() {
        _hobbyList = hobbies;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _hobbyList.length,
      itemBuilder: (context, index) {
        final hobbyList = _hobbyList[index];
        return GestureDetector(
          onLongPress: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRoutineScreen(
                  routineId: hobbyList.routineId,
                  title: hobbyList.hobbyName,
                  selectImage: hobbyList.imageUrl,
                  category: '취미',
                ),
              ),
            );
          },
          child: HobbyCard(
            routineId: hobbyList.routineId,
            imageUrl: hobbyList.imageUrl,
            title: hobbyList.hobbyName,
          ),
        );
      },
    );
  }
}
