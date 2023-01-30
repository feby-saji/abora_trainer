import 'package:abora/constants/app_styles.dart';
import 'package:flutter/material.dart';

// trainer description Tile
class DescriptionTile extends StatelessWidget {
  final text;
  final value;
  const DescriptionTile({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

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
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}

// adddate
class DateModel {
  var datetime;
  int number;
  DateModel({required this.datetime, required this.number});
}

//updateDialogueWidget
showDialogueFunc(context, controller) {
  showDialog() {
    child:
    Container(
      width: 400,
      height: 500,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
        ),
      ),
    );
  }
}

// trainer last review tile
class TrainerLastReview extends StatelessWidget {
  const TrainerLastReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
