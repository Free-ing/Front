class Answer {
  final int? answerId;
  final String? content;
  final String? createdAt;

  Answer({
    this.answerId,
    this.content,
    this.createdAt,
  });

  // JSON 데이터를 Answer 객체로 변환하는 팩토리 메서드
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'] as int?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}

class FeedbackList {
  final int inquiriesId;
  final String category;
  final String inquiriesTitle;
  final String content;
  final int userId;
  final String createdAt;
  final Answer? answer;

  FeedbackList({
    required this.inquiriesId,
    required this.category,
    required this.inquiriesTitle,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.answer,
  });

  // JSON 데이터를 NoticeList 객체로 변환하는 팩토리 메서드
  factory FeedbackList.fromJson(Map<String, dynamic> json) {
    return FeedbackList(
      inquiriesId: json['inquiriesId'],
      category: json['category'],
      inquiriesTitle: json['inquiriesTitle'],
      content: json['content'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      answer: json['answer'] != null ? Answer.fromJson(json['answer']) : null,
    );
  }
}

