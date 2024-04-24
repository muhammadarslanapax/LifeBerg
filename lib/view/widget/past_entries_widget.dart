import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_text.dart';

class PastEntryWidget extends StatelessWidget {
  PastEntryWidget({
    Key? key,
    this.image,
    this.subTitle,
    this.title,
    this.time,
  }) : super(key: key);
  String? title, subTitle, time, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 4,
        bottom: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kSecondaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: title ?? '',
                  size: 16,
                  weight: FontWeight.w500,
                ),
                if (subTitle!.isNotEmpty)
                  MyText(
                    paddingTop: 4,
                    text: subTitle ?? '',
                    size: 12,
                    height: 1.8,
                  ),
                MyText(
                  paddingTop: 4,
                  text: time ?? '',
                  size: 10,
                  color: kDarkBlueColor,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          if (image!.isNotEmpty)
            CommonImageView(
              height: 48,
              width: 48,
              radius: 8.0,
              url: image,
            ),
        ],
      ),
    );
  }
}