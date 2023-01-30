import 'package:abora/constants/app_styles.dart';
import 'package:abora/constants/widgets.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
  String _userName = 'error occured';
  String _specializeIn = 'select';
  final String _bio = 'add your bio..';
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
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    availableSessions.clear();
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const SizedBox(
                    child: Icon(Icons.close_rounded),
                  ),
                ),
                Text(
                  'Profile',
                  style: kPoppinsMedium.copyWith(
                      fontSize: blkHorSize * 5, color: Colors.green),
                ),
                const SizedBox(
                  width: 20,
                ),
              ]),
              SizedBox(height: blkVerSize * 5),
              // profile row
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
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (constext) {
                        return Container(
                          width: 400,
                          height: 500,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(),
                          ),
                        );
                      });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: blkHorSize * 2, vertical: blkVerSize * 2),
                    decoration: BoxDecoration(
                      color: navBarBck,
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    width: blkHorSize * 90,
                    child: Text(
                      _bio.isEmpty
                          ? 'Tap to edit yoursdofigjdfng;odfnghndfgh;ondf;gndf;ogn;ofdng;kkdfng;kdfsn;gond;ofigjhhesdoujjfoidjgljhhdjsfogjnoimkgjmdfsogjjdofsigjpiofdngkjdsnflithgisdrhtpnewriutgndifnfdmogndfongpdfhgdfhjhgdngdflkgmdfklgjodfjgojjdfotghdfghidfsngkjdfngo;dsjfpogiudsoifutgoeijgpoijsdrrf bio'
                          : _bio,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(height: blkHorSize * 5),
              Text(
                'Description',
                style: kPoppinsSemiBold,
              ),
              SizedBox(height: blkHorSize * 2),
              const DescriptionTile(text: 'Area', value: '90565'),
              const DescriptionTile(text: 'price per session', value: '100'),
              const DescriptionTile(text: 'Home Training', value: 'Yes'),
              const DescriptionTile(text: 'Gym Training', value: 'No'),
              SizedBox(height: blkHorSize * 4),
              //
              const Text('select the dates of session can be booked .'),
              SizedBox(height: blkHorSize * 4),
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.multiple,
                minDate: DateTime(
                    DateTime.now().year, DateTime.now().month, 1, 0, 0, 0),
                maxDate: DateTime(
                    DateTime.now().year, DateTime.now().month, lastDay, 0, 0),
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
