import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class MyDialog extends StatelessWidget {
  MyDialog({
    Key? key,
    required this.heading,
    required this.content,
    this.onOkay,
    this.height,
    this.haveCustomActionButtons = false,
    this.customAction,
    this.icon = '',
  }) : super(key: key);

  final String heading, content;
  final VoidCallback? onOkay;
  double? height;
  Widget? customAction;
  bool? haveCustomActionButtons;
  String? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
          // height: height ?? 206,
          width: Get.width,
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kSecondaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      MyText(
                        text: heading,
                        size: 18,
                        weight: FontWeight.w500,
                        paddingRight: 16,
                      ),
                      if (icon!.isNotEmpty)
                        Image.asset(
                          icon!,
                          height: 18,
                        ),
                    ],
                  ),
                  MyText(
                    paddingTop: 10,
                    paddingBottom: 34,
                    text: content,
                    color: kPopupTextColor,
                    height: 1.5,
                    size: 16,
                  ),
                ],
              ),
              haveCustomActionButtons!
                  ? SizedBox(
                      child: customAction,
                    )
                  : MyText(
                      onTap: onOkay,
                      align: TextAlign.end,
                      text: 'Okay',
                      size: 16,
                      weight: FontWeight.w500,
                      color: kTertiaryColor,
                    ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
