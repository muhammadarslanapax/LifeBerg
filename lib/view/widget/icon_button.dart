import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class MyIconButton extends StatelessWidget {
  MyIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.iconSize,
    required this.text,
  }) : super(key: key);

  final String icon, text;
  final VoidCallback onTap;
  double? iconSize;
  Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: kPrimaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kTextColor.withOpacity(0.03),
          highlightColor: kTextColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: iconSize ?? 24,
                color: iconColor,
              ),
              MyText(
                paddingLeft: 15,
                text: text,
                size: 16,
                paddingRight: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
