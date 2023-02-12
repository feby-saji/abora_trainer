import 'package:abora/constants/app_styles.dart';
import 'package:abora/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// Calendar widget
class Calendar extends StatelessWidget {
  const Calendar({
    Key? key,
    required List<DateTime> specialDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      view: DateRangePickerView.month,
      minDate: DateTime(DateTime.now().year, DateTime.now().month),
      maxDate: DateTime(DateTime.now().year, DateTime.now().month, lastDay),
      monthViewSettings: DateRangePickerMonthViewSettings(
        specialDates: specialDates,
        showTrailingAndLeadingDates: true,
        blackoutDates: blackOutDates,
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDatesDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.white),
          color: Colors.red,
        ),
        blackoutDateTextStyle: const TextStyle(),
        specialDatesDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.green),
          color: Colors.green,
        ),
        specialDatesTextStyle: const TextStyle(color: Colors.black),
        cellDecoration: const BoxDecoration(shape: BoxShape.circle),
      ),
      todayHighlightColor: Colors.green,
    );
  }
}

// trainer description Tile
class DescriptionTile extends StatefulWidget {
  final String text;
  final String value;
  final Color color;
  DescriptionTile({
    Key? key,
    required this.text,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  State<DescriptionTile> createState() => _DescriptionTileState();
}

class _DescriptionTileState extends State<DescriptionTile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final blkVerSize = SizeConfig.blockSizeVertical!;
    final blkHorSize = SizeConfig.blockSizeHorizontal!;
    return Container(
      margin: EdgeInsets.only(bottom: blkVerSize * 1),
      padding: EdgeInsets.symmetric(
          horizontal: blkHorSize * 7, vertical: blkVerSize * 2),
      decoration: BoxDecoration(
        color: navBarBck,
        borderRadius: BorderRadiusDirectional.circular(20),
      ),
      width: blkHorSize * 90,
      height: blkVerSize * 6,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          widget.text,
          style: TextStyle(
            color: widget.color,
          ),
        ),
        Text(
          widget.value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}

//updateDialogueWidget
editProfileTextField(BuildContext context, TextEditingController controller,
    blockSize, hintText) {
  return Center(
      child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    width: 300,
    height: 100,
    child: Material(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    ),
  ));
}

// trainer last review tile
class ReviewWidget extends StatelessWidget {
  final String imgPath;
  final String userName;
  final String reviewText;
  final DateTime dateTime;
  const ReviewWidget({
    super.key,
    required this.blkVerSize,
    required this.blkHorSize,
    required this.imgPath,
    required this.userName,
    required this.reviewText,
    required this.dateTime,
  });

  final double blkVerSize;
  final double blkHorSize;

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(dateTime);
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(
          vertical: blkVerSize * 1, horizontal: blkHorSize * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  imgPath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: blkHorSize * 3),
              Text(userName, style: kPoppinsMedium),
            ],
          ),
          SizedBox(height: blkVerSize * 1),
          Text(reviewText),
          SizedBox(height: blkVerSize * 1),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey),
              ))
        ],
      ),
    );
  }
}
