import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.height,
    this.radius,
    this.borderColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  double? height,radius;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ??  47,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8.0),
        color: kSecondaryColor,
        border: Border.all(
          width: 1.0,
          color: borderColor ?? kBorderColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kTextColor.withOpacity(0.03),
          highlightColor: kTextColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(radius ?? 8.0),
          child: Center(
            child: MyText(
              text: text,
              size: 16,
              color: kTertiaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
