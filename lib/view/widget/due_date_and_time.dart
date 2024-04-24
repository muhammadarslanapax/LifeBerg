import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_text.dart';

class DueDateAndTime extends StatelessWidget {
  const DueDateAndTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: CALENDAR_BOTTOM_SHEET_HEIGHT,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainHeading(
            paddingLeft: 15,
            text: 'Due date & time',
            paddingBottom: 20,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 6, 0, 15),
              children: [
                MyCalender(),
                hourMinute12HCustomStyle(),
              ],
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pop(context),
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}
