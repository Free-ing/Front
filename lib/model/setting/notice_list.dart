class NoticeList {
  final int announcementId;
  final String title;
  final String createdDate;
  final String content;
  final String category;


  NoticeList({
    required this.announcementId,
    required this.title,
    required this.createdDate,
    required this.content,
    required this.category,
  });

  // JSON 형태로 서버에서 받아온 데이터를 Notice 객체로 변환하는 팩토리 메서드
  factory NoticeList.fromJson(Map<String, dynamic> json) {
    return NoticeList(
      announcementId: json['announcementId'],
      title: json['title'],
      createdDate: json['createdDate'],
      content: json['content'],
      category: json['category']
    );
  }


}