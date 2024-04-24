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
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

class AddNewCountDownBottomSheet extends StatefulWidget {
  AddNewCountDownBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewCountDownBottomSheet> createState() =>
      _AddNewCountDownBottomSheetState();
}

class _AddNewCountDownBottomSheetState
    extends State<AddNewCountDownBottomSheet> {
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
                text: 'Add a new countdown timer',
                paddingBottom: 10,
              ),
              MyTextField(
                hint: 'Event',
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
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
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
                    hint: '',
                    marginBottom: 0.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      Assets.imagesDeleteIconNew,
                      height: 20,
                    ),
                  ),
                ],
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
                          return AddReminderWithCheckBoxTile();
                        },
                      );
                    },
                    child: Image.asset(
                      Assets.imagesReminderBell,
                      height: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  MyTextField(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (_) {
                          return AddReminderWithCheckBoxTile();
                        },
                      );
                    },
                    isReadOnly: true,
                    hint: '',
                    marginBottom: 0.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      Assets.imagesDeleteIconNew,
                      height: 20,
                    ),
                  ),
                ],
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
        onTap: () {

          Get.dialog(
            ImageDialog(
              heading: 'Countdown Timer Added',
              content: '',
              height: 170,
              image: Assets.imagesNewCountDownAdded,
              imageSize: 140.0,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
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
          MainHeading(
            paddingLeft: 15,
            text: 'Due date & time',
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
