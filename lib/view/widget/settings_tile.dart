import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class SettingsTiles extends StatelessWidget {
  SettingsTiles({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.haveNextIcon = true,
  }) : super(key: key);

  final String icon, title;
  final VoidCallback onTap;
  bool? haveNextIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: Color(0xffE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kPrimaryColor.withOpacity(0.05),
          highlightColor: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(7.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 24,
                  color: kTertiaryColor,
                ),
                Expanded(
                  child: MyText(
                    paddingLeft: 10,
                    text: title,
                    size: 16,
                  ),
                ),
                haveNextIcon!
                    ? Image.asset(
                        Assets.imagesArrowNext,
                        height: 16,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
