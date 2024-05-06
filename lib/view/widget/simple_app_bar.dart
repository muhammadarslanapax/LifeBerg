import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

AppBar simpleAppBar({
  String? title,
  VoidCallback? onBackTap,
  bool? haveLeading = true,
  bool? centerTitle = false,
}) {
  return AppBar(
    centerTitle: centerTitle,
    backgroundColor: kTertiaryColor,
    elevation: 1,
    leading: haveLeading!
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBackTap ?? () => Get.back(),
                child: Image.asset(
                  Assets.imagesArrowBack,
                  height: 24,
                  color: kSecondaryColor,
                ),
              ),
            ],
          )
        : SizedBox(),
    title: MyText(
      text: title,
      size: 16,
      weight: FontWeight.w500,
      color: kSecondaryColor,
    ),
  );
}
