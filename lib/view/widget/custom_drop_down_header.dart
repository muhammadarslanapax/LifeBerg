import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

class CustomDropDownHeader extends StatelessWidget {
  const CustomDropDownHeader({
    Key? key,
    required this.title,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
        ),
        padding: EdgeInsets.all(8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            MyText(
              text: title,
              size: 12,
              color: kSecondaryColor,
            ),
            Image.asset(
              Assets.imagesDropIcon,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}