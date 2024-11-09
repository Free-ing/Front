import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freeing/common/component/show_chart_date.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:freeing/common/service/hobby_api_service.dart';
import 'package:freeing/layout/chart_layout.dart';
import 'package:freeing/model/hobby/hobby_album.dart';
import 'package:freeing/screen/chart/chart_page.dart';
import 'package:freeing/screen/chart/view_detail_hobby_record.dart';
import 'dart:convert';

class HobbyGalleryScreen extends StatefulWidget {
  final DateTime? selectTime;
  const HobbyGalleryScreen({super.key, this.selectTime});

  @override
  State<HobbyGalleryScreen> createState() => _HobbyGalleryScreenState();
}

class _HobbyGalleryScreenState extends State<HobbyGalleryScreen> {
  DateTime selectedDate = DateTime.now();

  List<HobbyAlbum> _hobbyAlbums = [];

  //Todo: 서버 요청(취미 기록 조회)
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
    selectedDate = widget.selectTime ?? DateTime.now();
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
      backToPage: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ChartPage()),
        );
      },
      chartWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),
          ShowChartDate(
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
            return ViewDetailHobbyRecord(
              title: title,
              imageUrl: imageUrl,
              description: description,
              recordId: recordId,
              date: date,
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
}
