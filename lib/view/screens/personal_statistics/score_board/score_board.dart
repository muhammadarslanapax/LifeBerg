import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'ScoreBoard',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingActionTile(
              heading: 'Scoreboard',
              haveTrailing: true,
              customTrailingIcon: Assets.imagesPointsAccuralClose,
              onTap: () => Get.back(),
            ),
            GestureDetector(
              onTap: () {
                showMenu(
                  elevation: 10,
                  constraints: BoxConstraints(
                    maxWidth: 206,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  context: context,
                  position: RelativeRect.fromLTRB(110.0, 170.0, 0.0, 0.0),
                  items: [
                    menuItem(
                      title: 'Past week',
                      icon: '',
                    ),
                    menuItem(
                      title: 'Past month',
                      icon: '',
                    ),
                    menuItem(
                      title: 'Past year',
                      icon: '',
                    ),
                    menuItem(
                      title: 'All',
                      icon: '',
                      borderColor: Colors.transparent,
                    ),
                  ],
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyText(
                    text: 'Weekly',
                    size: 12,
                    paddingRight: 8,
                  ),
                  Image.asset(
                    Assets.imagesArrowDown,
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CustomIconTile(
              title: 'Daily gratitude',
              leadingColor: kDailyGratitudeColor,
              points: 86,
            ),
            CustomIconTile(
              title: 'Quiet Time',
              leadingColor: kStreaksColor,
              points: 100,
            ),
            CustomIconTile(
              title: 'RACGP Exam',
              leadingColor: kRACGPExamColor,
              points: 86,
            ),
            CustomIconTile(
              title: '10 Steps a day',
              leadingColor: kDayStepColor,
              points: 95,
            ),
            CustomIconTile(
              title: '20 mins cardio',
              leadingColor: kRACGPExamColor,
              points: 62,
            ),
          ],
        ),
      ),
    );
  }
}
