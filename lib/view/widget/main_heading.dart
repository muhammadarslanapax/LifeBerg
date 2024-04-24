import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';

// ignore: must_be_immutable
class MainHeading extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var text;
  double? paddingTop, paddingLeft, paddingRight, paddingBottom;

  // ignore: prefer_typing_uninitialized_variables
  VoidCallback? onTap;

  MainHeading({
    Key? key,
    @required this.text,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          "$text",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Ubuntu',
          ),
        ),
      ),
    );
  }
}
