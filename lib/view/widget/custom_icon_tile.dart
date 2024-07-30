import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class CustomIconTile extends StatelessWidget {
  CustomIconTile({
    Key? key,
    this.title,
    this.leadingColor,
    this.points,
    this.haveCheckBox = false,
    this.value = false,
    this.haveLeading = true,
    this.haveTrailingIcon = false,
    this.onTap,
  }) : super(key: key);

  String? title;
  int? points;
  bool? haveCheckBox, value, haveLeading, haveTrailingIcon;
  Color? leadingColor;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        height: 40,
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: kBorderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (haveLeading!)
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
            Expanded(
              child: MyText(
                paddingLeft: 11,
                text: title,
                size: 14,
                color: kCoolGreyColor,
                weight: FontWeight.w400,
              ),
            ),
            haveCheckBox!
                ? GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: value! ? kTertiaryColor : kUnSelectedColor,
                      ),
                      child: Icon(
                        Icons.check,
                        color: kPrimaryColor,
                        size: 11,
                      ),
                    ),
                  )
                : haveTrailingIcon!
                    ? Image.asset(
                        Assets.imagesArrowNext,
                        height: 16,
                      )
                    : points != null
                        ? MyText(
                            text: '$points',
                            size: 12,
                            color: kCoolGreyColor,
                          )
                        : SizedBox(),
          ],
        ),
      ),
    );
  }
}

