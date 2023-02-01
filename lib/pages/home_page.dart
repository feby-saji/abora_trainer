import 'package:abora/constants/app_styles.dart';
import 'package:abora/constants/widgets.dart';
import 'package:abora/functions/DB/db_functions.dart';
import 'package:abora/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
List<DateTime> specialDates = [];
List<DateTime> blackOutDates = [
  DateTime.now().add(const Duration(days: 2)),
  DateTime.now().add(const Duration(days: 1)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imgPath = '';
  String _userName = 'error occured';
  String _specializeIn = '';
  int currentBookings = 0;
  int totalBookings = 0;
  final List<DateTime> _specialDates = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _userName = await DbServices().getUserName();
      _specializeIn = await DbServices().getSpecializeIn();
      await DbServices().getAvailableSessions();
      setState(() {});
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ABORA Trainers',
                    style: kPoppinsSemiBold.copyWith(
                        fontSize: blkHorSize * 5, color: Colors.green),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProfilePage()),
                    child: SizedBox(
                      child: Image.asset(
                        'assets/icons/user.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        imgPath.isEmpty
                            ? 'assets/images/default_profile_img.jpg'
                            : imgPath,
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
                          text: _specializeIn.isEmpty ? '' : _specializeIn,
                          style: kPoppinsRegular,
                        )
                      ]))
                    ],
                  ),
                ],
              ),
              SizedBox(height: blkHorSize * 7),
              SizedBox(
                width: blkHorSize * 90,
                height: blkVerSize * 5,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () {},
                  child: Text(
                    "Post AD",
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
                'sessions booked',
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
                child: Calendar(specialDates: _specialDates),
              )
            ],
          ),
        ),
      ),
    );
  }
}
