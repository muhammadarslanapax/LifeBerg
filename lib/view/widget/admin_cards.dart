import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class AdminCards extends StatelessWidget {
  const AdminCards({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  }) : super(key: key);

  final String title, icon;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
        color: kSeoulColor2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          splashColor: kBorderColor.withOpacity(0.1),
          highlightColor: kBorderColor.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      icon,
                      height: iconSize,
                      color: kDarkBlueColor,
                    ),
                  ],
                ),
              ),
              MyText(
                paddingBottom: 20,
                text: title,
                size: 15,
                weight: FontWeight.w500,
                color: kCoolGreyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
