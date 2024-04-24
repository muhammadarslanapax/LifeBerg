import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class ImageDialog extends StatelessWidget {
  ImageDialog({
    Key? key,
    required this.heading,
    required this.content,
    this.onOkay,
    this.height,
    this.haveCustomActionButtons = false,
    this.customAction,
    this.image = '',
    this.imageSize,
    this.imagePaddingLeft = 0.0,
    this.imagePaddingBottom = 0.0,
  }) : super(key: key);

  final String heading, content;
  final VoidCallback? onOkay;
  double? height, imageSize;
  Widget? customAction;
  bool? haveCustomActionButtons;
  String? image;
  double? imagePaddingLeft, imagePaddingBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 13, 15, 10),
          height: height ?? 171,
          width: Get.width,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kSecondaryColor,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: heading,
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      if (content.isNotEmpty)
                        MyText(
                          paddingTop: 6,
                          text: content,
                          color: kPopupTextColor,
                          height: 1.5,
                          size: 13,
                          paddingBottom: 8.0,
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      haveCustomActionButtons!
                          ? SizedBox(
                              child: customAction,
                            )
                          : MyText(
                              onTap: onOkay,
                              align: TextAlign.end,
                              text: 'Okay',
                              size: 14,
                              weight: FontWeight.w500,
                              color: kTertiaryColor,
                            ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: content.isNotEmpty ? 0 : 8,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: imagePaddingLeft!,
                      bottom: imagePaddingBottom!,
                    ),
                    child: Image.asset(
                      image!,
                      height: imageSize ?? 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
