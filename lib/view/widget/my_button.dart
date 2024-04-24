import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.textSize,
    this.height,
    this.fontFamily = 'Ubuntu',
    this.weight,
    this.textColor,
    this.bgColor,
    this.elevation = 0,
    this.radius,
    this.isDisable = false,
    this.minWidth,
  }) : super(key: key);

  String? fontFamily;
  FontWeight? weight;
  Color? textColor, bgColor;
  double? textSize, height, elevation, radius,minWidth;
  bool? isDisable;

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MaterialButton(
          minWidth: minWidth ?? Get.width,
          onPressed: onTap,
          elevation: elevation,
          highlightElevation: elevation,
          color: bgColor ?? kTertiaryColor,
          splashColor: kSecondaryColor.withOpacity(0.05),
          highlightColor: kSecondaryColor.withOpacity(0.05),
          height: height ?? 48,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 8.0),
          ),
          child: Text(
            '${text}',
            style: TextStyle(
              fontSize: textSize ?? 16,
              color: textColor ?? kSecondaryColor,
              fontWeight: weight ?? FontWeight.w400,
              fontFamily: fontFamily ?? 'Ubuntu',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        isDisable!
            ? Container(
                width: Get.width,
                height: height ?? 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius ?? 8.0),
                  color: kSecondaryColor.withOpacity(0.30),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
