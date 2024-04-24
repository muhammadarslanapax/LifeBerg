import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class ProfileHeading extends StatelessWidget {
  String? heading;
  Color? leadingColor;
  double? marginTop;

  ProfileHeading({
    Key? key,
    this.marginTop,
    this.heading,
    this.leadingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: marginTop ?? 16,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            height: 16,
            width: 16,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: leadingColor!.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: leadingColor!,
                  shape: BoxShape.circle,
                ),
                height: Get.height,
                width: Get.width,
              ),
            ),
          ),
          MyText(
            text: heading,
            size: 18,
            paddingLeft: 8,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
