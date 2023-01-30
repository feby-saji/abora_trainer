import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Colors.green;
const Color kWhite = Colors.white;
const Color kblack = Colors.black;
const Color kGrey = Color(0xff9397a0);
const Color navBarBck = Color(0xFF17203A);

final kPoppinsBold = GoogleFonts.poppins(
  color: kblack,
  fontWeight: FontWeight.w700,
);
final kPoppinsSemiBold = GoogleFonts.poppins(
  color: kblack,
  fontWeight: FontWeight.w600,
);
final kPoppinsMedium = GoogleFonts.poppins(
  color: kblack,
  fontWeight: FontWeight.w500,
);
final kPoppinsRegular = GoogleFonts.poppins(
  color: kblack,
  fontWeight: FontWeight.w400,
);

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}
