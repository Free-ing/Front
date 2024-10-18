import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/hobby/hobby_album.dart';
import 'dart:convert';

class HobbyGalleryScreen extends StatefulWidget {
  const HobbyGalleryScreen({super.key});

  @override
  State<HobbyGalleryScreen> createState() => _HobbyGalleryScreenState();
}

class _HobbyGalleryScreenState extends State<HobbyGalleryScreen> {
  DateTime selectedDate = DateTime.now();

  List<HobbyAlbum> _hobbyAlbums = [];

  //Todo: 서버 요청
  Future<List<HobbyAlbum>> _fetchHobbyAlbum(int year, int month) async {
    print("Fetching hobby albums for $year-$month");

    final apiService = HobbyAPIService();
    final response = await apiService.getHobbyAlbum(year, month);

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      //List<HobbyAlbum> hobbyGallery = [];
      for (dynamic data in jsonData) {
        HobbyAlbum hobbyRecord = HobbyAlbum.fromJson(data);
        _hobbyAlbums.add(hobbyRecord);
        //_hobbyGallery = hobbyGallery;
      }
      return _hobbyAlbums;
    } else if (response.statusCode == 404) {
      return _hobbyAlbums = [];
    } else {
      throw Exception('취미 기록 가져오기 실패 ${response.statusCode}');
    }
  }

  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
    });
    _hobbyAlbums =
        await _fetchHobbyAlbum(selectedDate.year, selectedDate.month);
  }

  @override
  void initState() {
    super.initState();
    _fetchHobbyAlbum(selectedDate.year, selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChartLayout(
      title: "취미 사진첩",
      chartWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.01),
            ShowChartDate(
              // 모듈화된 날짜 선택 UI 사용
              selectedDate: selectedDate,
              onDateChanged: updateSelectedDate, // 콜백 함수 전달
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                ),
                itemCount: _hobbyAlbums.length,
                itemBuilder: (context, index) {
                  final hobbyAlbum = _hobbyAlbums[index];
                  return _buildHobbyRecord(
                    context: context,
                    imageUrl: hobbyAlbum.photoUrl,
                    date: hobbyAlbum.date,
                    title: hobbyAlbum.hobbyName,
                    description: hobbyAlbum.recordBody,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      onDateSelected: updateSelectedDate,
    );
  }

  //Todo: 취미 사진 불러오기
  Widget _buildHobbyRecord({
    required BuildContext context,
    required String imageUrl,
    required DateTime date,
    required String title,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _customPopup(
              context: context,
              title: title,
              date: date,
              imageUrl: imageUrl,
              description: description,
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: BASIC_GREY,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6)
                      ], // 시작 색상과 끝 색상
                      stops: const [0.0, 0.15, 0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  //height: 40,
                  child: Center(
                    child: Text('${date.year}년 ${date.month}월 ${date.day}일',
                        style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w300)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Todo: 취미기록 상세 보기
  Widget _customPopup({
    required BuildContext context,
    required String title,
    required DateTime date,
    required String imageUrl,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: IVORY,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(16.0),
        width: 400,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 상단 타이틀
            Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: BLUE_PURPLE,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 300.0,
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            const SizedBox(height: 12.0),
            // 날짜
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${date.year}년 ${date.month}월 ${date.day}일',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10.0),
            // 이미지 영역

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 10.0),
            // 설명 텍스트
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                backgroundColor: PRIMARY_COLOR,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                iconColor: Colors.white,
              ),
              child: Text(
                "닫기",
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // //Todo: 취미 사진 불러오기
  // Widget _buildHobbyRecord({required BuildContext context}) {
  //   final textTheme = Theme.of(context).textTheme;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return _customPopup(context);
  //         },
  //       );
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: BASIC_GREY,
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       child: Stack(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(15),
  //             child: Image.asset(
  //               'assets/imgs/background/hobby_image.png',
  //               //'assets/imgs/hobby/games.png',
  //               fit: BoxFit.cover,
  //               width: double.infinity,
  //               height: double.infinity,
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: FractionallySizedBox(
  //               heightFactor: 0.2,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(15),
  //                     bottomRight: Radius.circular(15),
  //                   ),
  //                   gradient: LinearGradient(
  //                     colors: [
  //                       Colors.black.withOpacity(0),
  //                       Colors.black.withOpacity(0.05),
  //                       Colors.black.withOpacity(0.3),
  //                       Colors.black.withOpacity(0.6)
  //                     ], // 시작 색상과 끝 색상
  //                     stops: [0.0, 0.15, 0.5, 1.0],
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                   ),
  //                 ),
  //                 //height: 40,
  //                 child: Center(
  //                   child: Text("2024년 9월 12일",
  //                       style: textTheme.bodyMedium?.copyWith(
  //                           color: Colors.white, fontWeight: FontWeight.w300)),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // //Todo: 취미기록 상세 보기
  // Widget _customPopup(BuildContext context) {
  //   final textTheme = Theme.of(context).textTheme;
  //
  //   return Dialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: IVORY,
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       padding: EdgeInsets.all(16.0),
  //       width: 400,
  //       height: 500,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         //crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           // 상단 타이틀
  //           Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 decoration: BoxDecoration(
  //                   color: BLUE_PURPLE,
  //                   border: Border.all(color: Colors.black),
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 width: 300.0,
  //                 child: Center(
  //                   child: Text(
  //                     "요리",
  //                     style: Theme.of(context).textTheme.headlineSmall,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               )),
  //           SizedBox(height: 12.0),
  //           // 날짜
  //           Container(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               '2024년 9월 4일',
  //               style: textTheme.bodyMedium,
  //             ),
  //           ),
  //           SizedBox(height: 10.0),
  //           // 이미지 영역
  //
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(15),
  //             child: Image.asset(
  //               "assets/imgs/background/hobby_image.png",
  //               height: 200,
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //
  //           SizedBox(height: 10.0),
  //           // 설명 텍스트
  //           Expanded(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 border: Border.all(color: Colors.black),
  //                 borderRadius: BorderRadius.circular(20.0),
  //               ),
  //               padding: EdgeInsets.all(8),
  //               child: SingleChildScrollView(
  //                 child: Text(
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n',
  //                   style: TextStyle(fontSize: 14.0),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 12.0),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(
  //               "닫기",
  //               style: textTheme.bodyMedium,
  //             ),
  //             style: ElevatedButton.styleFrom(
  //               padding: const EdgeInsets.symmetric(horizontal: 48.0),
  //               backgroundColor: PRIMARY_COLOR,
  //               side: const BorderSide(color: Colors.black),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //               iconColor: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
