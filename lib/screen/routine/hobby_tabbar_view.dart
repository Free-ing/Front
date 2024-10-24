import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/hobby_card.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/model/hobby/hobby_list.dart';

class HobbyTabBarView extends StatefulWidget {
  const HobbyTabBarView({super.key});

  @override
  State<HobbyTabBarView> createState() => _HobbyTabBarViewState();
}

class _HobbyTabBarViewState extends State<HobbyTabBarView> {
  List<HobbyList> _hobbyList = [];

  //Todo: 서버 요청
  Future<List<HobbyList>> _fetchHobbyList() async {
    print("Fetching hobby list");

    final apiService = HobbyAPIService();
    final response = await apiService.getHobbyList();

    print(response.statusCode);

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
    _fetchHobbyList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _hobbyList.length,
      itemBuilder: (context, index) {
        final hobbyList = _hobbyList[index];
        return HobbyCard(
          routineId: hobbyList.routineId,
          imageUrl: hobbyList.imageUrl,
          title: hobbyList.hobbyName,
        );
      },
    );
  }
}
