import 'package:abora/constants/vars.dart';
import 'package:abora/models/new_trainer.dart';
import 'package:abora/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbServices {
  final userNameCollection = FirebaseFirestore.instance.collection('userNames');
  final trainersCollection = FirebaseFirestore.instance.collection('Trainers');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late SharedPreferences sharedPref;

  Future<String> getUserName() async {
    sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString(SharedPrefVal().userName) != null) {
      return sharedPref.getString(SharedPrefVal().userName)!;
    } else {
      DocumentSnapshot docSnap = await trainersCollection.doc(uid).get();
      sharedPref.setString(SharedPrefVal().userName, docSnap['name']);
      return docSnap['name'];
    }
  }

  Future<String> getSpecializeIn() async {
    sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString(SharedPrefVal().specializeIn) != null) {
      return sharedPref.getString(SharedPrefVal().specializeIn)!;
    } else {
      DocumentSnapshot docSnap = await trainersCollection.doc(uid).get();
      sharedPref.setString(SharedPrefVal().specializeIn, docSnap['speciality']);
      return docSnap['speciality'];
    }
  }

  Future<String> getimgUrl() async {
    sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString(SharedPrefVal().trainerImgUrl) != null) {
      return sharedPref.getString(SharedPrefVal().trainerImgUrl)!;
    } else {
      DocumentSnapshot docSnap = await trainersCollection.doc(uid).get();
      sharedPref.setString(
          SharedPrefVal().trainerImgUrl, docSnap['profielPic']);
      return docSnap['profielPic'];
    }
  }

  Future getAvailableSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList(SharedPrefVal().availableSession) != null) {
      // await prefs.remove(SharedPrefVal().availableSession);
      print('shared has dates getting it');
      prefs.getStringList(SharedPrefVal().availableSession)!.forEach((element) {
        var stringDate = element;
        DateTime parsedDate = DateTime.parse(stringDate);
        specialDates.value.add(parsedDate);
        specialDates.notifyListeners();
      });
    } else {
      List<String> list = [];
      print('no dates found fetching it');
      await trainersCollection.doc(DbServices().uid).get().then((value) => {
            if (value.data()!.isNotEmpty)
              {
                List.from(value.data()!['availableSessions']).forEach((dbDate) {
                  DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                      dbDate.microsecondsSinceEpoch);
                  specialDates.value.add(date);
                  specialDates.notifyListeners();
                  list.add(date.toString());
                }),
              }
          });
      await prefs.setStringList(SharedPrefVal().availableSession, list);
    }
  }

//  functions set to DB
  setSessionsAvailable(dates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    List.from(dates).forEach((element) {
      list.add(element.toString());
    });

    await DbServices()
        .trainersCollection
        .doc(DbServices().uid)
        .update({'availableSessions': dates});
    await prefs.setStringList(SharedPrefVal().availableSession, list);
  }

// on new trainer singUp
  addNewTrainer(name) async {
    final newTrainer = NewTrainer(
      name: name,
      profielPic: '',
      bio: '',
      homeTraining: false,
      gymTraining: false,
      availableSessions: [],
      bookedSessions: [],
      area: 9000,
      speciality: '',
      pricePerSession: 10,
      reviews: [],
      adPosted: false,
    );
    await trainersCollection.doc(uid).set(newTrainer.toMap());
  }

  Future<bool> checkTrainerNameExists(userName) async {
    QuerySnapshot userNameDocs =
        await userNameCollection.where('userName', isEqualTo: userName).get();
    if (userNameDocs.docs.isNotEmpty) {
      print('user name detected  userNameDocs.docs.length');
      return true;
    } else {
      userNameCollection.add({'userName': userName});
      print('no user name detected continue');
      return false;
    }
  }
}


//  ElevatedButton(
//             onPressed: () async {
//               FirebaseAuth.instance.signOut();
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               await prefs.setBool('userLoggedIn', false);
//               Get.to(() => LoginPage());
//             },
//             child: Text('log out')),