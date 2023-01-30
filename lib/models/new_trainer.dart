class NewTrainer {
  final String name;
  String profielPic;
  String bio;
  bool homeTraining;
  bool gymTraining;
  int area;
  String speciality;
  int pricePerSession;
  List availableSessions;
  List bookedSessions;
  List reviews;
  bool adPosted;

  NewTrainer({
    required this.name,
    required this.profielPic,
    required this.bio,
    required this.homeTraining,
    required this.gymTraining,
    required this.availableSessions,
    required this.bookedSessions,
    required this.area,
    required this.speciality,
    required this.pricePerSession,
    required this.reviews,
    required this.adPosted,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "profielPic": profielPic,
      "bio": bio,
      "homeTraining": homeTraining,
      "gymTraining": gymTraining,
      "availableSessions": availableSessions,
      "sessionsBooked": bookedSessions,
      "area": area,
      "speciality": speciality,
      "pricePerSession": pricePerSession,
      "reviews": reviews,
    };
  }
}
