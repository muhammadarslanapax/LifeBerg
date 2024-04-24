import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/add_reminder_widget.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

class EditCountDown extends StatefulWidget {
  EditCountDown({
    Key? key,
  }) : super(key: key);

  @override
  State<EditCountDown> createState() => _EditCountDownState();
}

class _EditCountDownState extends State<EditCountDown> {
  final List<Color> colors = [
    kC1,
    kC2,
    kC3,
    kC4,
    kC5,
    kC6,
    kC7,
    kC8,
    kC9,
    kC10,
    kC11,
    kC12,
    kC13,
    kQuiteTimeColor,
    kDarkBlueColor,
    kC16,
  ];

  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: CustomBottomSheet(
        height: Get.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 15),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: [
              MainHeading(
                text: 'Edit countdown timer',
                paddingBottom: 10,
              ),
              MyTextField(
                hint: 'Lee’s Surprise Birthday Party',
                marginBottom: 20.0,
              ),
              Row(
                children: [
                  MainHeading(
                    text: 'Set date & time',
                    paddingRight: 40.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (_) {
                          return SetDateAndTimeForCountDown();
                        },
                      );
                    },
                    child: Image.asset(
                      Assets.imagesCalender,
                      height: 24,
                      color: kDarkBlueColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                isReadOnly: true,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    builder: (_) {
                      return SetDateAndTimeForCountDown();
                    },
                  );
                },
                hint: '23/03/2023 @ 8:30pm',
                marginBottom: 0.0,
              ),
              // MyText(
              //   paddingTop: 8,
              //   text: '*Use calendar Icon to select date and time',
              //   size: 12,
              // ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  MainHeading(
                    text: 'Add a reminder',
                    paddingRight: 40.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (_) {
                          return EditReminderWithCheckBoxTile();
                        },
                      );
                    },
                    child: Image.asset(
                      Assets.imagesBellWithDot,
                      height: 24,
                      color: kDarkBlueColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                isReadOnly: true,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    builder: (_) {
                      return EditReminderWithCheckBoxTile();
                    },
                  );
                },
                hint: '24 hours before',
                marginBottom: 0.0,
              ),
              // MyText(
              //   paddingTop: 8,
              //   text: '*Use Bell Icon to add a reminder',
              //   size: 12,
              // ),
              SizedBox(
                height: 28,
              ),
              MainHeading(
                text: 'Colour for countdown',
                paddingBottom: 12,
              ),
              ChooseColor(
                colors: colors,
                colorIndex: colorIndex,
              ),
            ],
          ),
        ),
        onTap: () => Navigator.pop(context),
        buttonText: 'Confirm',
        isButtonDisable: false,
      ),
    );
  }
}

class SetDateAndTimeForCountDown extends StatelessWidget {
  const SetDateAndTimeForCountDown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: CALENDAR_BOTTOM_SHEET_HEIGHT,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            paddingLeft: 15,
            text: 'Due date & time',
            size: 20,
            weight: FontWeight.w500,
            paddingBottom: 24,
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
      onTap: () => Get.back(),
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}

class EditReminderWithCheckBoxTile extends StatelessWidget {
  const EditReminderWithCheckBoxTile({Key? key}) : super(key: key);

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
                    'Add 30 minutes',
                    '10 minutes',
                    '14/11/22 at 12:30 am',
                  ];
                  return CustomCheckBoxTile(
                    title: _items[index],
                    isSelected: index == 0 ? true : false,
                    onSelect: _items[index] == '14/11/22 at 12:30 am'
                        ? () {
                            Get.back();
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              isScrollControlled: true,
                              builder: (_) {
                                return EditCustomiseReminder();
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
        Get.back();
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

class EditCustomiseReminder extends StatelessWidget {
  const EditCustomiseReminder({
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
      onTap: () => Get.back(),
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}
