import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';

class ChooseColor extends StatelessWidget {
  const ChooseColor({
    super.key,
    required this.colors,
    required this.colorIndex,
  });

  final List<Color> colors;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 8; i++)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: colors[i],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  if (colorIndex == i)
                    CircleAvatar(
                      radius: 5.0,
                      backgroundColor: kDarkBlueColor,
                    ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 8; i < colors.length; i++)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: colors[i],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  if (colorIndex == i)
                    CircleAvatar(
                      radius: 5.0,
                      backgroundColor: kDarkBlueColor,
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}