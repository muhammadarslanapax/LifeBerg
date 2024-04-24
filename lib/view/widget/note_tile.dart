import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class NotesTile extends StatelessWidget {
  NotesTile({
    Key? key,
    required this.note,
  }) : super(key: key);

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: 40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kBorderColor,
        ),
      ),
      child: MyText(
        text: note,
        size: 14,
        color: kCoolGreyColor,
      ),
    );
  }
}
