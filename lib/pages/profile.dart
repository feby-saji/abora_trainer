import 'package:abora/constants/app_styles.dart';
import 'package:abora/constants/vars.dart';
import 'package:abora/constants/widgets.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:abora/main.dart';
import 'package:abora/models/review.dart';
import 'package:abora/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// text controllers
TextEditingController _bioCtrl = TextEditingController();
TextEditingController _areaCtrl = TextEditingController();
TextEditingController _pricePerSessionCtrl = TextEditingController();

bool isRed = false;
TrainerReviewModel? lastReview;

ValueNotifier<bool> saveBtnVisible = ValueNotifier(false);
late double width;
late double height;

class _ProfilePageState extends State<ProfilePage> {
  int lastDay = DateTime(DateTime.now().year, DateTime.now().month + 2, 0).day;
  List availableSessions = [];
  List bookedSessions = [];
  int num = 0;
  String _bio = '';
  String _area = '';
  String _pricePerSession = '';

  bool _homeTraining = false;
  bool _gymTraining = false;

//   showcase keys
//   final GlobalKey _formsKey = GlobalKey();
  final GlobalKey _saveKey = GlobalKey();
  final GlobalKey _calendarKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();

  displayshowCase() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    bool? showCaseBool =
        sharedPref.getBool(SharedPrefVal().displayShowCaseProfile);
    if (showCaseBool != true) {
      ShowCaseWidget.of(context)
          .startShowCase([_saveKey, _calendarKey, _reviewKey]);
      await sharedPref.setBool(SharedPrefVal().displayShowCaseProfile, true);
    } else {
      await sharedPref.setBool(SharedPrefVal().displayShowCaseProfile, true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   SharedPreferences preferences = await SharedPreferences.getInstance();
      //   await preferences.remove(SharedPrefVal().displayShowCaseProfile);
      _bio = await DbServices().getBio();
      _area = await DbServices().getArea();
      _pricePerSession = await DbServices().getsessionPrice();
      _homeTraining = await DbServices().getHomeTrainingBool();
      _gymTraining = await DbServices().getGymTrainingBool();
      await getLastReview();
      setState(() {});
      displayshowCase();

      Future.delayed(const Duration(milliseconds: 300), () {
        width = SizeConfig.screenHeight!;
        height = SizeConfig.screenHeight!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bioCtrl.clear();
    _areaCtrl.clear();
    _pricePerSessionCtrl.clear();
    isRed = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final blkVerSize = SizeConfig.blockSizeVertical!;
    final blkHorSize = SizeConfig.blockSizeHorizontal!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: blkVerSize * 6,
            left: blkHorSize * 2.5,
            right: blkHorSize * 2.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: const SizedBox(
                        child: Icon(Icons.close_rounded),
                      )),
                  Text(
                    'Profile',
                    style: kPoppinsMedium.copyWith(
                        fontSize: blkHorSize * 5, color: Colors.green),
                  ),

                  //?   save Btn
                  Showcase(
                    key: _saveKey,
                    title: 'save button',
                    description:
                        'save button will appear when you change any values in your profile.',
                    child: ValueListenableBuilder(
                      valueListenable: saveBtnVisible,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value,
                          child: ElevatedButton(
                            onPressed: () => saveBtnFunc(),
                            child: const Text('save'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: blkVerSize * 5),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: file != null
                          ? GestureDetector(
                              onTap: () => selectImage(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => selectImage(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/images/default_profile_img.jpg',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            )),
                  SizedBox(width: blkHorSize * 4),

                  //
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

//spcialize in
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      width: 200,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: navBarBck,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
//  ? first option
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                specializeIn = 'Lean body';
                                              });
                                              saveBtnVisible.value = true;
                                              Get.back();
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text(
                                                    'Lean',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

// ? second option
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                specializeIn =
                                                    'Muscle building';
                                              });
                                              saveBtnVisible.value = true;
                                              Get.back();
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text(
                                                    'Muscle building',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

// ? third option
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                specializeIn = 'Fat loss';
                                              });
                                              saveBtnVisible.value = true;

                                              Get.back();
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text(
                                                    'Fat Loss',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

// ? Weight gain
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                specializeIn = 'Weight gain';
                                              });
                                              saveBtnVisible.value = true;
                                              Get.back();
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text(
                                                    'Weight gain',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Text(
                                'specialize in :',
                                style: kPoppinsRegular.copyWith(
                                    color: isRed && specializeIn.isEmpty
                                        ? Colors.red
                                        : Colors.black),
                              ),
                              Text(
                                specializeIn.isEmpty
                                    ? 'tap to select'
                                    : specializeIn,
                                style: kPoppinsRegular.copyWith(
                                    color: Colors.black),
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(height: blkHorSize * 7),
              Text(
                'Bio',
                style: kPoppinsSemiBold.copyWith(color: Colors.black),
              ),
              SizedBox(height: blkHorSize * 1),
//bio
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return editProfileTextField(
                        context: context,
                        controller: _bioCtrl,
                        blockSize: blkHorSize,
                        maxLength: 200,
                        hintText: 'add bio',
                        particulatVar: 'bio',
                      );
                    }),
                child: Container(
                    width: blkHorSize * 90,
                    decoration: BoxDecoration(
                        color: navBarBck,
                        borderRadius: BorderRadiusDirectional.circular(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: blkHorSize * 5, vertical: blkVerSize * 2),
                    child: Text(_bio.isEmpty ? 'Tap to edit bio' : _bio,
                        style: TextStyle(
                          color:
                              isRed && _bio.isEmpty ? Colors.red : Colors.white,
                        ))),
              ),

              SizedBox(height: blkHorSize * 5),

              //   descriptions
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return editProfileTextField(
                            inputType: TextInputType.number,
                            context: context,
                            controller: _pricePerSessionCtrl,
                            blockSize: blkHorSize,
                            maxLength: 8,
                            hintText: 'Price per session',
                            particulatVar: 'sessionPrice');
                      });
                },
                child: DescriptionTile(
                    text: 'price per session',
                    color: isRed && _pricePerSession.isEmpty
                        ? Colors.red
                        : Colors.white,
                    value: _pricePerSession.isEmpty
                        ? 'tap to add'
                        : _pricePerSession),
              ),

//   home Training
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          width: 300,
                          height: 70,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 117, 117, 117),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _homeTraining = true;
                                  });
                                  saveBtnVisible.value = true;
                                  saveBtnVisible.notifyListeners();
                                  Get.back();
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _homeTraining = false;
                                  });
                                  saveBtnVisible.value = true;
                                  saveBtnVisible.notifyListeners();
                                  Get.back();
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                child: DescriptionTile(
                    text: 'Home Training',
                    color: Colors.white,
                    value: _homeTraining ? 'Yes' : 'No'),
              ),

//   GymTraining
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          width: 300,
                          height: 70,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 117, 117, 117),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _gymTraining = true;
                                  });
                                  saveBtnVisible.value = true;
                                  saveBtnVisible.notifyListeners();
                                  Get.back();
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _gymTraining = false;
                                  });
                                  saveBtnVisible.value = true;
                                  saveBtnVisible.notifyListeners();
                                  Get.back();
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                child: DescriptionTile(
                    text: 'Gym Training',
                    color: Colors.white,
                    value: _gymTraining ? 'Yes' : 'No'),
              ),

              SizedBox(height: blkHorSize * 4),

// calendar
              Text(
                'Update available session dates.',
                style: kPoppinsMedium,
              ),
              SizedBox(height: blkHorSize * .5),

              //
              Showcase(
                key: _calendarKey,
                title: 'calendar',
                description: 'update your monthly available sessions',
//
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  selectionColor: Colors.green,
                  todayHighlightColor: Colors.green,
                  showActionButtons: true,
                  confirmText: 'SAVE',
                  minDate: DateTime(
                      DateTime.now().year, DateTime.now().month, 1, 0, 0, 0),
                  maxDate: DateTime(
                      DateTime.now().year, DateTime.now().month, lastDay, 0, 0),
//
                  onSubmit: (Object? dates) async {
                    if (dates != null) {
                      final navigator = Navigator.of(context);
                      ScaffoldMessenger.of(context).clearSnackBars();

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: SizedBox(
                              width: 300,
                              height: 300,
                              child:
                                  // CircularProgressIndicator()
                                  RiveAnimation.asset(
                                      'assets/rive/loading.riv'),
                            ));
                          });

                      await DbServices().setSessionsAvailable(dates);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        navigator.pop();
                        Get.offAll(() => ShowCaseWidget(
                            builder: Builder(
                                builder: (context) => const HomeScreen())));
                        Get.snackbar(
                          '',
                          'sessions available updated successfully',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      });
//
                    } else {
                      Get.snackbar(
                        'no dates selected',
                        'select your session available dates before you proceed',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    }
                  },
                ),
              ),

//
              Text('Last Review', style: kPoppinsSemiBold),
              Showcase(
                key: _reviewKey,
                title: 'reviews',
                description: 'recent reviews will be shown here.',
                child: Container(
                  child: lastReview == null
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: blkVerSize * 12,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(child: Text('No Reviews !')),
                        )
                      : ReviewWidget(
                          blkVerSize: blkVerSize,
                          blkHorSize: blkHorSize,
                          imgPath: lastReview!.profilePic,
                          userName: lastReview!.name,
                          reviewText: lastReview!.text,
                          dateTime: lastReview!.dateTime,
                        ),
                ),
              ),

              SizedBox(height: blkVerSize * 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final navigator = Navigator.of(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
              child: SizedBox(
            width: 300,
            height: 300,
            child:
                // CircularProgressIndicator()
                RiveAnimation.asset('assets/rive/loading.riv'),
          ));
        });
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

// get file
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      Get.back();
      return;
    }

    setState(() {
      file = File(xFile.path);
    });

// compresss it
    File compressedFile = await FlutterNativeImage.compressImage(xFile.path,
        quality: 80, targetWidth: 400, targetHeight: 400);

// upload
    final cloudinary = CloudinaryPublic('dgfprpoif', 'jtxhrv2n', cache: false);

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(compressedFile.path,
            resourceType: CloudinaryResourceType.Image),
      );
      DbServices()
          .trainersCollection
          .doc(DbServices().uid)
          .update({'profilePic': response.secureUrl});
    } on CloudinaryException catch (e) {
      Get.snackbar('', 'something went wrong $e');
      print(e.message);
      print(e.request);
      navigator.pop();
    }

    await sharedPref.setString(SharedPrefVal().profilePic, compressedFile.path);
    navigator.pop();
  }

  getLastReview() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('Trainers')
        .doc(DbServices().uid)
        .collection('reviews')
        .limit(3)
        .get();
    if (querySnap.docs.length < 0) {
      DocumentSnapshot docSnap = querySnap.docs[0];
      if (mounted) {
        setState(() {
          lastReview = TrainerReviewModel(
            name: docSnap['name'],
            profilePic: docSnap['profilePic'],
            text: docSnap['text'],
            dateTime: DateTime.fromMicrosecondsSinceEpoch(
                docSnap['dateTime'].microsecondsSinceEpoch),
          );
        });
      }
    }
  }

  editProfileTextField({
    required BuildContext context,
    required TextEditingController controller,
    TextInputType? inputType,
    required int maxLength,
    required blockSize,
    required hintText,
    required String particulatVar,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(children: [
        SizedBox(height: blockSize * 70),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          width: 300,
          child: Material(
            child: TextFormField(
              keyboardType: inputType ?? inputType,
              controller: controller,
              inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
              decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                labelText: 'Goal',
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: blockSize * 10, vertical: 10),
          child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    switch (particulatVar) {
                      case 'area':
                        _area = controller.text;
                        break;
                      case 'bio':
                        _bio = controller.text;
                        break;
                      case 'sessionPrice':
                        print('session price triggered');
                        _pricePerSession = controller.text;
                        break;
                      default:
                    }
                    saveBtnVisible.value = true;
                    saveBtnVisible.notifyListeners();
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
                child: const Text('done'),
              )),
        )
      ]),
    );
  }

  saveBtnFunc() async {
    final navigator = Navigator.of(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
              child: SizedBox(
            width: 300,
            height: 300,
            child:
                // CircularProgressIndicator()
                RiveAnimation.asset('assets/rive/loading.riv'),
          ));
        });
    if (_bio.isNotEmpty &&
        _area.isNotEmpty &&
        _pricePerSession.isNotEmpty &&
        specializeIn.isNotEmpty) {
//
      await DbServices()
          .trainersCollection
          .doc(DbServices().uid)
          .update({'adPostable': true});
//
      await DbServices()
          .saveTrainerDetails(
            bio: _bio,
            area: _area,
            sessionPrice: _pricePerSession,
            specializeIn: specializeIn,
            home: _homeTraining,
            gym: _gymTraining,
          )
          .then((value) => value ? navigator.pop() : null);
      saveBtnVisible.value = false;
      saveBtnVisible.notifyListeners();
      Get.back();
    } else {
      setState(() {
        isRed = true;
      });
      print('print $isRed');
      navigator.pop();
      Get.snackbar(
        '',
        'make sure you filled every fields',
      );
    }
  }
}
