class NoticeList {
  final String category;
  final String title;
  final String date;
  final String content;

  NoticeList({
    required this.category,
    required this.title,
    required this.date,
    required this.content,
  });

  // JSON 형태로 서버에서 받아온 데이터를 Notice 객체로 변환하는 팩토리 메서드
  factory NoticeList.fromJson(Map<String, dynamic> json) {
    return NoticeList(
      category: json['category'],
      title: json['title'],
      date: json['date'],
      content: json['content'],
    );
  }


}