import 'package:flutter/material.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

import '../../model/mood_history/mood_history_response_data.dart';

// ignore: must_be_immutable
class HeadingActionTile extends StatelessWidget {
  HeadingActionTile({
    Key? key,
    this.onTap,
    this.customTrailingIcon,
    this.heading,
    this.haveTrailing = false,
  }) : super(key: key);

  String? heading, customTrailingIcon;
  VoidCallback? onTap;
  bool? haveTrailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
              text: heading,
              size: 18,
              weight: FontWeight.w500,
            ),
            haveTrailing!
                ? Image.asset(
                    customTrailingIcon ?? Assets.imagesExpandedIcon,
                    height: 20,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
