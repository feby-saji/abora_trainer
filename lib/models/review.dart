class TrainerReviewModel {
  final String name;
  String profilePic;
  String text;
  DateTime dateTime;
  TrainerReviewModel({
    required this.name,
    required this.profilePic,
    required this.text,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
