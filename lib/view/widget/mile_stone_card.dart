import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class MilestoneCard extends StatelessWidget {
  const MilestoneCard({
    Key? key,
    required this.icon,
    required this.points,
    required this.title,
  }) : super(key: key);
  final String icon, points, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kSeoulColor2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              icon,
              height: 40,
            ),
          ),
          MyText(
            paddingTop: 12,
            paddingBottom: 8,
            text: points,
            size: 22,
            weight: FontWeight.w500,
            align: TextAlign.center,
          ),
          MyText(
            text: title,
            size: 14,
            align: TextAlign.center,
            height: 1.6,
          ),
        ],
      ),
    );
  }
}