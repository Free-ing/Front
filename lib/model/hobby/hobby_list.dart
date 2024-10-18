class HobbyList {
  String imageUrl;
  String hobbyName;
  int routineId;

  HobbyList({
    required this.imageUrl,
    required this.hobbyName,
    required this.routineId,
  });

  factory HobbyList.fromJson(Map<String, dynamic> json) {
    return HobbyList(
      imageUrl: json['imageUrl'],
      hobbyName: json['hobbyName'],
      routineId: json['routineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'hobbyName': hobbyName,
      'routineId': routineId,
    };
  }
}
