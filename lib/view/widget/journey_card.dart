import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

class JourneyCard extends StatelessWidget {
  final String icon, content;
  final bool haveBottomIcon;
  final Color bgColor;
  Alignment? bottomIconAlign;
  String? bottomIcon;

  JourneyCard({
    super.key,
    required this.icon,
    required this.content,
    required this.haveBottomIcon,
    required this.bgColor,
    this.bottomIconAlign,
    this.bottomIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.fromLTRB(15, 17, 15, 30),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(7),
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesBorder,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                icon,
                height: 70,
              ),
              MyText(
                text: content,
                size: 13,
                color: kBlackColor,
                height: 1.5,
                paddingTop: 8,
              ),
            ],
          ),
        ),
        if (haveBottomIcon)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: bottomIconAlign ?? Alignment.centerLeft,
              child: Image.asset(
                bottomIcon!,
                height: 38,
              ),
            ),
          )
      ],
    );
  }
}
