import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class StoryCard extends StatelessWidget {
  String? title, label, content;
  bool? haveBottomText;
  VoidCallback? onBottomTextTap;
  Color? bgColor, textColor;

  StoryCard({
    Key? key,
    this.content,
    this.title,
    this.label,
    this.haveBottomText = false,
    this.onBottomTextTap,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          text: label,
          size: 18,
          weight: FontWeight.w500,
          paddingBottom: 10,
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                MyText(
                  text: title,
                  size: 18,
                  color: textColor,
                  weight: FontWeight.w500,
                  paddingBottom: 8,
                ),
              MyText(
                text: content,
                size: 13.0,
                color: textColor,
                height: 1.85,
              ),
            ],
          ),
        ),
        if (haveBottomText!)
          MyText(
            text: 'Continue reading',
            size: 14,
            color: kTertiaryColor,
            align: TextAlign.end,
            decoration: TextDecoration.underline,
            paddingTop: 8,
            paddingBottom: 21,
            onTap: onBottomTextTap,
          ),
      ],
    );
  }
}