import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/mood/mood_data.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../screens/home/end_of_day_report.dart';

class DailyMoodReport extends StatelessWidget {
  DailyMoodReport({
    Key? key,
  }) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          homeController.emojis.length,
          (index) {
            return GestureDetector(
              onTap: () {
                Get.back();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  isScrollControlled: true,
                  builder: (_) {
                    return DailyMoodSheet();
                  },
                );
              },
              child: Obx(
                () => Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: homeController.savedSelectedMood.value.value ==
                            homeController.emojis[index].value.value
                        ? kLightPrimaryColor
                        : Colors.transparent,
                    border: Border.all(
                      width: 2.0,
                      color: kDarkBlueColor,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      homeController.emojis[index].emoji.value,
                      height: 11.5,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DailyMoodSheet extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  DailyMoodSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  Assets.imagesBottomSheetHandle,
                  height: 8,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    homeController.emojis.length,
                    (index) {
                      return Obx(() {
                        return GestureDetector(
                          onTap: () {
                            homeController.updateEmoji(
                                homeController.emojis[index].emoji.value,
                                homeController.emojis[index].value.value);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: homeController.selectedMood.value.value ==
                                      homeController.emojis[index].value.value
                                  ? kLightPrimaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                width: 2.0,
                                color: kDarkBlueColor,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                homeController.emojis[index].emoji.value,
                                height: 11.5,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: MyTextField(
                  fillColor: Colors.white,
                  maxLines: 1,
                  controller: homeController.moodCommentController,
                  hint: 'Add a comment about your mood ',
                  marginBottom: 0.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(15, 10, 15, 30)
                    : EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: MyButton(
                  height: 56,
                  radius: 8,
                  isDisable: false,
                  text: "Submit",
                  onTap: () {
                    if (homeController.selectedMood.value.value != -1) {
                      homeController.updateUserMood();
                      PrefUtils().savedMood =
                          homeController.selectedMood.value.value.toString();
                      PrefUtils().savedMoodComment =
                          homeController.moodCommentController.text.toString();
                      Get.dialog(
                        ImageDialog(
                          heading: 'Your mood has been captured',
                          content: 'Continue to track your mood for trends',
                          imageSize: 107,
                          image: Assets.imagesMoodCaptured,
                          onOkay: () {
                            Get.back();
                            if (homeController.selectedMood.value.value == 1) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                builder: (_) {
                                  return MessageFromTimmy();
                                },
                              );
                            } else {
                              Navigator.pop(context);
                            }
                            homeController.updateEmoji("", -1);
                            homeController.moodCommentController.text = "";
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
