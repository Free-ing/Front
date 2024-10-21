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

      // 서버에서 객체로 반환될 경우 처리
      if (jsonData is Map<String, dynamic>) {
        // 예시에서 'albums' 키로 리스트가 들어있는 경우
        List<dynamic> albumList = jsonData['result'];

        _hobbyAlbums.clear(); // 기존 앨범을 초기화
        for (dynamic data in albumList) {
          HobbyAlbum hobbyRecord = HobbyAlbum.fromJson(data);
          _hobbyAlbums.add(hobbyRecord);
        }
      } else if (jsonData is List) {
        // 만약 JSON이 리스트로 바로 반환되었다면
        _hobbyAlbums.clear();
        for (dynamic data in jsonData) {
          HobbyAlbum hobbyRecord = HobbyAlbum.fromJson(data);
          _hobbyAlbums.add(hobbyRecord);
        }
      }
      _hobbyAlbums.sort((a, b) => b.date.compareTo(a.date));
      return _hobbyAlbums;
    } else if (response.statusCode == 404) {
      return _hobbyAlbums = [];
    } else {
      throw Exception('취미 기록 가져오기 실패 ${response.statusCode}');
    }
  }

  //Todo: 날짜 update
  Future<void> updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
    });

    final hobbyAlbums =
        await _fetchHobbyAlbum(selectedDate.year, selectedDate.month);

    setState(() {
      _hobbyAlbums = hobbyAlbums;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchHobbyAlbum(selectedDate.year, selectedDate.month).then((albums) {
      setState(() {
        _hobbyAlbums = albums;
      });
    });
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
                  final hobbyAlbum =
                      _hobbyAlbums[_hobbyAlbums.length - 1 - index];
                  return _buildHobbyRecord(
                    context: context,
                    imageUrl: hobbyAlbum.photoUrl,
                    date: hobbyAlbum.date,
                    title: hobbyAlbum.hobbyName,
                    description: hobbyAlbum.recordBody,
                    recordId: hobbyAlbum.recordId,
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
    required int recordId,
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
              recordId: recordId,
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
    required int recordId,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: IVORY,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.all(screenHeight * 0.02),
        width: screenWidth * 0.9,
        height: screenHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 상단 타이틀
            Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                  decoration: BoxDecoration(
                    color: BLUE_PURPLE,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 300.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 50),
                      // IconButton(
                      //   onPressed: (){},
                      //   icon: Icon(Icons.edit_note_rounded,),
                      //   iconSize: 25,
                      // ),
                      IconButton(
                        onPressed: () async {
                          final responseCode = await HobbyAPIService()
                              .deleteHobbyRecord(recordId, 1);
                          if (responseCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('기록이 삭제되었습니다.')),
                            );
                            setState(() {
                              _hobbyAlbums.removeWhere(
                                  (album) => album.recordId == recordId);
                            });
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('기록이 삭제되지 않았습니다 ')),
                            );
                            print(responseCode);
                          }
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: screenHeight * 0.015),
            // 날짜
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${date.year}년 ${date.month}월 ${date.day}일',
                style: textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            // 이미지 영역

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                height: screenHeight * 0.22,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),
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
            SizedBox(height: screenHeight * 0.015),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
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
  // Widget _buildHobbyRecord({
  //   required BuildContext context,
  // }) {
  //   final textTheme = Theme.of(context).textTheme;
  //
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
  //                     ],
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
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;
  //
  //   return Dialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: IVORY,
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       padding: EdgeInsets.all(screenHeight*0.02),
  //       width: screenWidth*0.9,
  //       height: screenHeight*0.6,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         //crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           // 상단 타이틀
  //           Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(vertical: screenHeight*0.008),
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
  //           SizedBox(height: screenHeight*0.015),
  //           // 날짜
  //           Container(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               '2024년 9월 4일',
  //               style: textTheme.bodyMedium,
  //             ),
  //           ),
  //           SizedBox(height: screenHeight*0.015),
  //           // 이미지 영역
  //
  //           Image.asset(
  //             "assets/imgs/background/hobby_image.png",
  //             height: screenHeight*0.22,
  //             fit: BoxFit.contain,
  //           ),
  //
  //           SizedBox(height: screenHeight*0.015),
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
  //                   '친구들과 도시락 들고 피크닉 갔다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n'
  //                   '친구들과 도시락 들고 피크닉 갔다. 즐거웠다.\n',
  //                   style: textTheme.bodySmall,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: screenHeight*0.015),
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
