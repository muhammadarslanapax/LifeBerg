import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/view/widget/journal_choose_color.dart';

import '../../../constant/color.dart';
import '../../../constant/strings.dart';
import '../../../generated/assets.dart';
import '../../../model/journal/journal_list_response_data.dart';
import '../../../utils/toast_utils.dart';
import '../../widget/choose_color.dart';
import '../../widget/custom_bottom_sheet.dart';
import '../../widget/image_dialog.dart';
import '../../widget/main_heading.dart';
import '../../widget/my_text.dart';
import '../../widget/my_text_field.dart';

class AddNewJournal extends StatelessWidget {
  final String category;
  final JournalListResponseData? journal;

  AddNewJournal(this.category, {super.key, this.journal});

  final JournalController controller = Get.find<JournalController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 6,
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: MainHeading(
                  text: category == "Development"
                      ? 'What have you learnt?'
                      : "What are you grateful for?",
                  paddingBottom: 12,
                ),
              ),
              MyTextField(
                fillColor: Colors.white,
                maxLines: null,
                minLines: 1,
                inputFormatter: BulletPointInputFormatter(),
                textInputType: TextInputType.multiline,
                controller: controller.addTextController,
                hint: "Add text",
                marginBottom: 0.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainHeading(
                    paddingTop: 16,
                    text: 'Colour on timeline',
                    paddingBottom: 12,
                  ),
                  Obx(() => JournalChooseColor(
                        colors: controller.colors,
                        colorIndex: controller.colorIndex.value,
                        onTap: (index) {
                          controller.colorIndex.value = index;
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          if (controller.addTextController.text.isNotEmpty &&
              controller.colorIndex.value != -1) {
            if (journal != null) {
              controller.updateJournal((isUpdated) {
                if (isUpdated) {
                  controller.isShowDevelopmentSearch.value = false;
                  controller.isShowGratitudeSearch.value = false;
                  controller.setInitialText();
                  controller.colorIndex.value = -1;
                  controller.getUserJournals();
                  Navigator.of(context).pop();
                } else {
                  ToastUtils.showToast("Some error occurred.",
                      color: kRedColor);
                }
              }, journal!.sId ?? "");
            } else {
              controller.addNewJournal((isCreated) {
                if (isCreated) {
                  controller.isShowDevelopmentSearch.value = false;
                  controller.isShowGratitudeSearch.value = false;
                  controller.setInitialText();
                  controller.colorIndex.value = -1;
                  controller.getUserJournals();
                  Get.back();
                  Get.dialog(Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 13, 20, 10),
                        width: Get.width,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kSecondaryColor,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  text: controller.currentTab == 0
                                      ? "Development noted"
                                      : "Gratitude noted",
                                  size: 18,
                                  color: kPopupTextColor,
                                  weight: FontWeight.w500,
                                ),
                                MyText(
                                  paddingTop: 6,
                                  text: 'Continue to reflect & grow!',
                                  color: kPopupTextColor,
                                  height: 1.5,
                                  size: 16,
                                  paddingBottom: 12.0,
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 0.0,
                                            bottom: 0.0,
                                          ),
                                          child: Image.asset(
                                            Assets
                                                .imagesJournalEntrySavedNewImage,
                                            height: 128,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: MyText(
                                        onTap: () {
                                          Get.back();
                                          Navigator.of(context).pop();
                                        },
                                        align: TextAlign.end,
                                        text: okay_,
                                        size: 16,
                                        weight: FontWeight.w500,
                                        color: kTertiaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
                } else {
                  ToastUtils.showToast("Some error occurred.",
                      color: kRedColor);
                }
              },
                  controller.addTextController.text.toString(),
                  colorToHex(controller.colors[controller.colorIndex.value].color),
                  controller.tabs[controller.currentTab]);
            }
          } else {
            ToastUtils.showToast("Please enter all the fields.",
                color: kRedColor);
          }
        },
        buttonText: 'Submit',
        isButtonDisable: false,
      ),
    );
  }
}

class BulletPointInputFormatter extends TextInputFormatter {
  final String bullet = '\u2022 ';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Handle case when the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(
        text: "",
        selection: TextSelection.collapsed(offset: bullet.length),
      );
    }

    // Handle backspace for bullet point deletion
    if (oldValue.text.endsWith(bullet) &&
        oldValue.text.length - newValue.text.length == 1) {
      final newText =
      newValue.text.substring(0, newValue.text.length - bullet.length);
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    // Handle bullet point addition and capitalization
    if (newValue.text.endsWith('\n')) {
      final newText =
          newValue.text.substring(0, newValue.text.length - 1) + '\n$bullet';
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    // Capitalize the first letter after the bullet point
    if (oldValue.text.endsWith('$bullet') && newValue.text.length > oldValue.text.length) {
      final lastBulletIndex = newValue.text.lastIndexOf(bullet);
      if (lastBulletIndex != -1 && newValue.text.length > lastBulletIndex + bullet.length) {
        final textBeforeBullet = newValue.text.substring(0, lastBulletIndex + bullet.length);
        final textAfterBullet = newValue.text.substring(lastBulletIndex + bullet.length);

        // Check if the first character after the bullet point is lowercase and capitalize it
        if (textAfterBullet.isNotEmpty && textAfterBullet[0] != textAfterBullet[0].toUpperCase()) {
          final capitalizedTextAfterBullet = textAfterBullet[0].toUpperCase() + textAfterBullet.substring(1);
          final capitalizedText = textBeforeBullet + capitalizedTextAfterBullet;

          return newValue.copyWith(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );
        }
      }
    }

    return newValue;
  }
}
