import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_calender.dart';

import 'package:life_berg/view/widget/my_text.dart';

class AddReminderWithCheckBoxTile extends StatelessWidget {
  const AddReminderWithCheckBoxTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: Get.height * 0.65,
      buttonText: 'Confirm',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainHeading(
            text: 'Add a reminder',
            paddingLeft: 15,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              children: List.generate(
                6,
                (index) {
                  List<String> _items = [
                    '1 week before',
                    '24 hours ',
                    '1 hour',
                    '30 minutes',
                    '10 minutes',
                    'Customise',
                  ];
                  return CustomCheckBoxTile(
                    title: _items[index],
                    isSelected: index == 0 ? true : false,
                    onSelect: _items[index] == 'Customise'
                        ? () {
                            Get.back();
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              isScrollControlled: true,
                              builder: (_) {
                                return CustomiseReminder();
                              },
                            );
                          }
                        : () {},
                  );
                },
              ),
            ),
          ),
        ],
      ),
      isButtonDisable: false,
      onTap: () {
        Navigator.pop(context);
        // showDialog(
        //   context: context,
        //   builder: (_) {
        //     return MyDialog(
        //       heading: 'Count Down',
        //       content: 'Your new count down has been created.',
        //       onOkay: () => Get.back(),
        //     );
        //   },
        // );
      },
    );
  }
}

class CustomiseReminder extends StatelessWidget {
  const CustomiseReminder({
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
            text: 'Customise reminder',
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
