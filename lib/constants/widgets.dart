import 'package:abora/constants/app_styles.dart';
import 'package:abora/pages/home_page.dart';
import 'package:flutter/material.dart';
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
  const DescriptionTile({
    Key? key,
    required this.text,
    required this.value,
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
          style: const TextStyle(
            color: Colors.white,
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
class TrainerLastReview extends StatelessWidget {
  const TrainerLastReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
