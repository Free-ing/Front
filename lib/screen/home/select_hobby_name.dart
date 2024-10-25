import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/hobby_card.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/model/hobby/hobby_list.dart';

class SelectHobbyName extends StatefulWidget {
  const SelectHobbyName({super.key});

  @override
  State<SelectHobbyName> createState() => _SelectHobbyNameState();
}

class _SelectHobbyNameState extends State<SelectHobbyName> {
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
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset(
          'assets/imgs/background/background_image_routine_chart.png',
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
              Text("취미 선택", style: textTheme.headlineLarge)
            ]),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _hobbyList.length,
            itemBuilder: (context, index) {
              final hobbyList = _hobbyList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(hobbyList.hobbyName);
                },
                child: HobbyCard(
                  routineId: hobbyList.routineId,
                  imageUrl: hobbyList.imageUrl,
                  title: hobbyList.hobbyName,
                ),
              );
            },
          ),
        ),
      )
    ]);
  }
}
