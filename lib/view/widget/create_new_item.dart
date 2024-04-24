import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/add_reminder_widget.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/due_date_and_time.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

class CreateNewItem extends StatefulWidget {
  CreateNewItem({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateNewItem> createState() => _CreateNewItemState();
}

class _CreateNewItemState extends State<CreateNewItem> {
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
        height: Get.height * 0.83,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 15),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: [
              MainHeading(
                text: 'Create new item',
                paddingBottom: 10,
              ),
              MyTextField(
                hint: 'Title',
              ),
              MyTextField(
                hint: 'Description',
                maxLines: 6,
                marginBottom: 16.0,
              ),

              Row(
                children: [
                  MainHeading(
                    text: 'Due date & time',
                    paddingRight: 32.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (_) {
                          return DueDateAndTime();
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
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (_) {
                          return DueDateAndTime();
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
              //   text: '*Use calendar Icon to select date and time',
              //   size: 12,
              // ),
              SizedBox(
                height: 16,
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
                height: 10.0,
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
                text: 'Colour on timeline',
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
              heading: 'Admin task',
              content: 'Your new admin task has been created.',
              image: Assets.imagesAdminTaskCreated,
              imageSize: 85.0,
              imagePaddingBottom: 5,
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
