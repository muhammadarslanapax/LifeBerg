import 'package:flutter/material.dart';
import 'package:life_berg/model/journal/journal_color.dart';

import '../../constant/color.dart';

class JournalChooseColor extends StatelessWidget {
  const JournalChooseColor({
    super.key,
    required this.colors,
    required this.colorIndex,
    this.onTap,
  });

  final List<JournalColor> colors;
  final int colorIndex;
  final Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 8; i++)
              GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!(i);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: colors[i].color,
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
              GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!(i);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: colors[i].color,
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
              ),
          ],
        ),
      ],
    );
  }
}
