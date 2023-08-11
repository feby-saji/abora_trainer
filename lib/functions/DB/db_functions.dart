import 'package:abora/constants/vars.dart';
import 'package:abora/main.dart';
import 'package:abora/models/new_trainer.dart';
import 'package:abora/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbServices {
  final userNameCollection = FirebaseFirestore.instance.collection('userNames');
  final trainersCollection = FirebaseFirestore.instance.collection('Trainers');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  SharedPreferences? sharedPref;

// document snapshot
  Future fillDocSnap() async {
    print('getting docSnap inside Dbservices');
    docSnap = await trainersCollection.doc(uid).get();
  }

// get Trainer Profile Details
  Future<String> getUserName() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().userName) != null) {
      return sharedPref!.getString(SharedPrefVal().userName)!;
    } else {
      sharedPref!.setString(SharedPrefVal().userName, docSnap!['name']);
      return docSnap!['name'];
    }
  }

  Future<bool> getAdPosted() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getBool('adPosted') != null) {
      return sharedPref!.getBool('adPosted')!;
    } else {
      sharedPref!.setBool('adPosted', docSnap!['adPosted']);
      return docSnap!['adPosted'];
    }
  }

  Future<String> getSpecializeIn() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().specializeIn) != null) {
      return sharedPref!.getString(SharedPrefVal().specializeIn)!;
    } else {
      sharedPref!
          .setString(SharedPrefVal().specializeIn, docSnap!['speciality']);
      return docSnap!['speciality'];
    }
  }

  Future<String> getBio() async {
    if (docSnap == null) {
      await fillDocSnap();
      print('getting docSnap inside bio $docSnap');
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().bio) != null) {
      return sharedPref!.getString(SharedPrefVal().bio)!;
    } else {
      sharedPref!.setString(SharedPrefVal().bio, docSnap!['bio']);
      return docSnap!['bio'];
    }
  }

  Future<String> getArea() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().area) != null) {
      return sharedPref!.getString(SharedPrefVal().area)!;
    } else {
      sharedPref!.setString(SharedPrefVal().area, docSnap!['area']);
      return docSnap!['area'];
    }
  }

  Future<String> getsessionPrice() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().sessionPrice) != null) {
      return sharedPref!.getString(SharedPrefVal().sessionPrice)!;
    } else {
      sharedPref!
          .setString(SharedPrefVal().sessionPrice, docSnap!['pricePerSession']);
      return docSnap!['pricePerSession'];
    }
  }

  Future<String> getimgUrl() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getString(SharedPrefVal().trainerImgUrl) != null) {
      return sharedPref!.getString(SharedPrefVal().trainerImgUrl)!;
    } else {
      sharedPref!
          .setString(SharedPrefVal().trainerImgUrl, docSnap!['profilePic']);
      return docSnap!['profilePic'];
    }
  }

  Future<bool> getHomeTrainingBool() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getBool(SharedPrefVal().home) != null) {
      return sharedPref!.getBool(SharedPrefVal().home)!;
    } else {
      sharedPref!.setBool(SharedPrefVal().home, docSnap!['homeTraining']);
      return docSnap!['homeTraining'];
    }
  }

  Future<bool> getGymTrainingBool() async {
    if (docSnap == null) {
      await fillDocSnap();
    }
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getBool(SharedPrefVal().gym) != null) {
      return sharedPref!.getBool(SharedPrefVal().gym)!;
    } else {
      sharedPref!.setBool(SharedPrefVal().gym, docSnap!['gymTraining']);
      return docSnap!['gymTraining'];
    }
  }

  Future getAvailableSessions() async {
    specialDates.clear();
    sharedPref ??= await SharedPreferences.getInstance();
    if (sharedPref!.getStringList(SharedPrefVal().availableSession) != null) {
      // await sharedPref.remove(SharedPrefVal().availableSession);
      sharedPref!
          .getStringList(SharedPrefVal().availableSession)!
          .forEach((element) {
        var stringDate = element;
        DateTime parsedDate = DateTime.parse(stringDate);
        specialDates.add(parsedDate);
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
                  specialDates.add(date);
                  list.add(date.toString());
                }),
              }
          });
      await sharedPref!.setStringList(SharedPrefVal().availableSession, list);
    }
  }

//  functions set to DB
  setSessionsAvailable(dates) async {
    sharedPref ??= await SharedPreferences.getInstance();
    List<String> list = [];
    List.from(dates).forEach((element) {
      list.add(element.toString());
    });

    await DbServices()
        .trainersCollection
        .doc(DbServices().uid)
        .update({'availableSessions': dates});
    await sharedPref!.setStringList(SharedPrefVal().availableSession, list);
    list.clear();
  }

  Future<bool> saveTrainerDetails(
      {required bio,
      required area,
      required sessionPrice,
      required String specializeIn,
      required bool home,
      required bool gym}) async {
    sharedPref ??= await SharedPreferences.getInstance();
    trainersCollection.doc(uid).update({
      'bio': bio,
      'area': area,
      'pricePerSession': sessionPrice,
      'speciality': specializeIn,
      'gymTraining': gym,
      'homeTraining': home,
    });
    await sharedPref!.setString(SharedPrefVal().bio, bio);
    await sharedPref!.setString(SharedPrefVal().area, area);
    await sharedPref!.setString(SharedPrefVal().sessionPrice, sessionPrice);
    await sharedPref!.setString(SharedPrefVal().specializeIn, specializeIn);
    await sharedPref!.setBool(SharedPrefVal().gym, gym);
    await sharedPref!.setBool(SharedPrefVal().home, home);
    return true;
  }

// on new trainer singUp
  addNewTrainer(name) async {
    final newTrainer = NewTrainer(
      name: name,
      profilePic:
          'https://cyclingmagazine.ca/wp-content/uploads/2021/08/GettyImages-1213615970.jpg',
      bio: '',
      homeTraining: false,
      gymTraining: false,
      availableSessions: [],
      bookedSessions: [],
      area: '9000',
      speciality: '',
      pricePerSession: '10',
      adPosted: false,
      adPostable: false,
      createdOn: DateTime.now(),
      uid: FirebaseAuth.instance.currentUser!.uid,
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
//               SharedPreferences sharedPref = await SharedPreferences.getInstance();
//               await sharedPref.setBool('userLoggedIn', false);
//               Get.to(() => LoginPage());
//             },
//             child: Text('log out')),
