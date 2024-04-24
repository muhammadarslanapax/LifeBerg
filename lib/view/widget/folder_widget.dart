import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: kSeoulColor2.withOpacity(0.9),
        border: Border.all(
          color: kBorderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            icon,
            height: 26,
            color: kTertiaryColor,
          ),
          SizedBox(
            height: 8,
          ),
          MyText(
            text: label,
            size: 14,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}