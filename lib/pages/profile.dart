import 'package:abora/constants/app_styles.dart';
import 'package:abora/constants/widgets.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// text controllers
TextEditingController _bioCtrl = TextEditingController();
TextEditingController _areaCtrl = TextEditingController();
TextEditingController _pricePerSessionCtrl = TextEditingController();

ValueNotifier<bool> saveBtnVisible = ValueNotifier(false);
late double width;
late double height;

class _ProfilePageState extends State<ProfilePage> {
  int lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
  final String _bio = 'add your bio..';
  String _userName = 'error occured';
  String _specializeIn = 'select';
  List availableSessions = [];
  List bookedSessions = [];
  int num = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _userName = await DbServices().getUserName();
      _specializeIn = await DbServices().getSpecializeIn();
      setState(() {});

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

                  //   save Btn
                  ValueListenableBuilder(
                    valueListenable: saveBtnVisible,
                    builder: (context, value, child) {
                      return Visibility(
                        visible: value,
                        child: ElevatedButton(
                          onPressed: () async =>
                              DbServices().saveTrainerDetails(),
                          child: const Text('save'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: blkVerSize * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/default_profile_img.jpg',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  SizedBox(width: blkHorSize * 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
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
                          text: _specializeIn,
                          style: kPoppinsRegular,
                        )
                      ])),
                    ],
                  ),
                ],
              ),
              SizedBox(height: blkHorSize * 7),
              Text(
                'Bio',
                style: kPoppinsSemiBold,
              ),
              SizedBox(height: blkHorSize * 1),
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return editProfileTextField(
                          context: context,
                          controller: _bioCtrl,
                          blockSize: blkHorSize,
                          maxLength: 200,
                          hintText: 'add bio');
                    }),
                child: Container(
                    width: blkHorSize * 90,
                    decoration: BoxDecoration(
                        color: navBarBck,
                        borderRadius: BorderRadiusDirectional.circular(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: blkHorSize * 2, vertical: blkVerSize * 2),
                    child: Text(_bio.isEmpty ? 'Tap to edit bio' : _bio,
                        style: const TextStyle(
                          color: Colors.white,
                        ))),
              ),
              SizedBox(height: blkHorSize * 5),

              //   descriptions
              const DescriptionTile(text: 'Area', value: '90565'),
              const DescriptionTile(text: 'price per session', value: '100'),
              const DescriptionTile(text: 'Home Training', value: 'Yes'),
              const DescriptionTile(text: 'Gym Training', value: 'No'),
              SizedBox(height: blkHorSize * 4),

              // calendar
              const Text('select the dates of session can be booked .'),
              SizedBox(height: blkHorSize * 4),
              //
              SfDateRangePicker(
                minDate: DateTime(
                    DateTime.now().year, DateTime.now().month, 1, 0, 0, 0),
                maxDate: DateTime(
                    DateTime.now().year, DateTime.now().month, lastDay, 0, 0),
                selectionMode: DateRangePickerSelectionMode.multiple,
                selectionColor: Colors.green,
                todayHighlightColor: Colors.green,
                showActionButtons: true,
                onSubmit: (Object? dates) async {
                  await DbServices().setSessionsAvailable(dates);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

editProfileTextField(
    {required BuildContext context,
    required TextEditingController controller,
    TextInputType? inputType,
    required int maxLength,
    required blockSize,
    required hintText}) {
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
          child: TextField(
            enableSuggestions: true,
            keyboardType: inputType ?? inputType,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: blockSize * 10, vertical: 10),
        child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                saveBtnVisible.value = true;
                saveBtnVisible.notifyListeners();
                Get.back();
              },
              child: const Text('done'),
            )),
      )
    ]),
  );
}
