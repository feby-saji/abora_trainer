import 'dart:io';

import 'package:abora/constants/app_styles.dart';
import 'package:abora/constants/vars.dart';
import 'package:abora/constants/widgets.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:abora/main.dart';
import 'package:abora/pages/appoinment.dart';
import 'package:abora/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:http/http.dart' show get;

// Global vars
//  // // // ///

int lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
List<DateTime> specialDates = [];
List<DateTime> blackOutDates = [
  DateTime.now().add(const Duration(days: 2)),
  DateTime.now().add(const Duration(days: 1)),
];

String userName = '';
String specializeIn = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String AdPostState = 'Post AD';
  String imgPath = '';
  late SharedPreferences prefs;
  int currentBookings = 0;
  int totalBookings = 0;
  final List<DateTime> _specialDates = [];

//   showcase
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _calendarKey = GlobalKey();
  final GlobalKey _appoinmentKey = GlobalKey();

  displayshowCase() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    bool? showCaseBool =
        sharedPref.getBool(SharedPrefVal().displayShowCaseHome);
    if (showCaseBool = !true) {
      ShowCaseWidget.of(context)
          .startShowCase([_profileKey, _appoinmentKey, _calendarKey]);
      await sharedPref.setBool(SharedPrefVal().displayShowCaseHome, true);
    } else {
      await sharedPref.setBool(SharedPrefVal().displayShowCaseHome, true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      userName = await DbServices().getUserName();
      specializeIn = await DbServices().getSpecializeIn();
      await DbServices().getAvailableSessions();
      setState(() {});
      displayshowCase();
      await DbServices().fillDocSnap();

// check shared has ImgPath
      if (prefs.getString(SharedPrefVal().profilePic) == null) {
        print('this thing is running nowwwwwwwwwww');
// getImgUrl
        DocumentSnapshot snapDoc =
            await DbServices().trainersCollection.doc(DbServices().uid).get();
        // file = snapDoc['profilePic'];
// download and save it in local storage
        //comment out the next two lines to prevent the device from getting
        // the image from the web in order to prove that the picture is
        // coming from the device instead of the web.
        var url = snapDoc['profilePic']; // <-- 1
        var response = await get(Uri.parse(url)); // <--2
        var documentDirectory = await getApplicationDocumentsDirectory();
        var firstPath = "${documentDirectory.path}/images";
        var filePathAndName = '${documentDirectory.path}/images/pic.jpg';
        //comment out the next three lines to prevent the image from being saved
        //to the device to show that it's coming from the internet
        await Directory(firstPath).create(recursive: true); // <-- 1
        File file2 = File(filePathAndName); // <-- 2
        file2.writeAsBytesSync(response.bodyBytes); // <-- 3
        setState(() {
          file = file2;
        });
        await prefs.setString(SharedPrefVal().profilePic, filePathAndName);
      } else {
        print('this thing wont run cuz this aint null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final blkVerSize = SizeConfig.blockSizeVertical!;
    final blkHorSize = SizeConfig.blockSizeHorizontal!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: blkVerSize * 6,
          left: blkHorSize * 2.5,
          right: blkHorSize * 2.5,
        ),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: Column(
            children: [
// appBar
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ABORA Trainers',
                    style: kPoppinsSemiBold.copyWith(
                        fontSize: blkHorSize * 5, color: Colors.green),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowCaseWidget(
                                        builder: Builder(
                                            builder: (context) =>
                                                const AppoinmentPage()),
                                      )));
                        },
                        child: Showcase(
                          key: _appoinmentKey,
                          title: 'Appoinments',
                          description:
                              'you will be notified when client books your session.',
                          child: SizedBox(
                            child: Image.asset(
                              'assets/icons/appoinment.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowCaseWidget(
                                        builder: Builder(
                                            builder: (context) =>
                                                const ProfilePage()),
                                      )));
                        },
                        child: Showcase(
                          key: _profileKey,
                          title: 'Profile',
                          description: 'set your profile here.',
                          child: SizedBox(
                            child: Image.asset(
                              'assets/icons/user.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: blkVerSize * 1),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: blkVerSize * 3),

// profile Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: file != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                file!,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'assets/images/default_profile_img.jpg',
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            )),
                  SizedBox(width: blkHorSize * 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: kPoppinsRegular.copyWith(
                          fontSize: blkHorSize * 4.5,
                        ),
                      ),
                      SizedBox(height: blkVerSize * 2),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Specialize in : ',
                          style: kPoppinsMedium,
                        ),
                        TextSpan(
                          text: specializeIn.isEmpty ? '' : specializeIn,
                          style: kPoppinsRegular,
                        )
                      ]))
                    ],
                  ),
                ],
              ),
              SizedBox(height: blkHorSize * 7),
//
              SizedBox(
                width: blkHorSize * 90,
                height: blkVerSize * 5,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () => postAd(),
                  child: Text(
                    AdPostState,
                    style: kPoppinsMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: blkHorSize * 7),
// details
              SizedBox(
                width: blkHorSize * 80,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total sessions booked'),
                    Text(totalBookings.toString()),
                  ],
                ),
              ),
              SizedBox(
                width: blkHorSize * 80,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total booking current month'),
                    Text(currentBookings.toString()),
                  ],
                ),
              ),
              SizedBox(height: blkHorSize * 5),
              Text(
                'Your schedule',
                style: kPoppinsMedium.copyWith(fontSize: blkHorSize * 4.5),
              ),
              SizedBox(height: blkHorSize * 5),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('sessions available'),
                          SizedBox(width: blkHorSize * 3),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 10,
                              height: 10,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('sessions booked'),
                          SizedBox(width: blkHorSize * 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 10,
                              height: 10,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Showcase(
                    key: _calendarKey,
                    title: 'calendar',
                    description:
                        'quick view of your available sessions and the booked session.',
                    child: Calendar(specialDates: _specialDates)),
              )
            ],
          ),
        ),
      ),
    );
  }

  postAd() async {
    DocumentSnapshot docSnap =
        await DbServices().trainersCollection.doc(DbServices().uid).get();
    if (docSnap['adPostable'] == true) {
      setState(() {
        AdPostState = 'AD is live now';
      });
      await DbServices()
          .trainersCollection
          .doc(DbServices().uid)
          .update({'adPosted': true});
    } else {
      Get.snackbar(
        '',
        'Complete your profile settings to make your ad live',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
