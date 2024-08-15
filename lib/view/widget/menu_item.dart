import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

PopupMenuItem<dynamic> menuItem({
  String? title,
  String? icon,
  VoidCallback? onTap,
  Color? borderColor = kBorderColor,
}) {
  return PopupMenuItem(
    onTap: onTap,
    padding: EdgeInsets.zero,
    height: 40,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    paddingTop: 12,
                    text: title,
                    size: 16,
                    color: kTextColor,
                    paddingBottom: 12,
                  ),
                  if (icon!.isNotEmpty)
                    GestureDetector(
                      onTap: onTap,
                      child: Image.asset(
                        icon,
                        height: 14,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: borderColor,
            ),
          ],
        ),
      ),
    ),
  );
}

PopupMenuItem<dynamic> scoreBoardMenuItem({
  String? title,
  String? icon,
  VoidCallback? onTap,
  Color? borderColor = kBorderColor,
}) {
  return PopupMenuItem(
    onTap: onTap,
    padding: EdgeInsets.zero,
    height: 40,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    paddingTop: 12,
                    text: title,
                    size: 14,
                    color: kTextColor,
                    paddingBottom: 7,
                  ),
                  if (icon!.isNotEmpty)
                    GestureDetector(
                      onTap: onTap,
                      child: Image.asset(
                        icon,
                        height: 14,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: borderColor,
            ),
          ],
        ),
      ),
    ),
  );
}
