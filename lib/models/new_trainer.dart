class NewTrainer {
  final String name;
  String profilePic;
  String bio;
  bool homeTraining;
  bool gymTraining;
  String area;
  String speciality;
  String pricePerSession;
  List availableSessions;
  List bookedSessions;
  bool adPosted;
  bool adPostable;
  DateTime createdOn;
  String uid;

  NewTrainer({
    required this.name,
    required this.profilePic,
    required this.bio,
    required this.homeTraining,
    required this.gymTraining,
    required this.availableSessions,
    required this.bookedSessions,
    required this.area,
    required this.speciality,
    required this.pricePerSession,
    required this.adPosted,
    required this.adPostable,
    required this.createdOn,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "profilePic": profilePic,
      "bio": bio,
      "homeTraining": homeTraining,
      "gymTraining": gymTraining,
      "availableSessions": availableSessions,
      "sessionsBooked": bookedSessions,
      "area": area,
      "speciality": speciality,
      "pricePerSession": pricePerSession,
      "adPostable": adPostable,
      "adPosted": adPosted,
      "createdOn": createdOn,
      "uid": uid,
    };
  }
}
