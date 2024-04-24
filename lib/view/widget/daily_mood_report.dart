import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:textfield_tags/textfield_tags.dart';

class DailyMoodReport extends StatelessWidget {
  DailyMoodReport({
    Key? key,
  }) : super(key: key);
  final List<String> emojis = [
    Assets.imagesVeryBad,
    Assets.imagesBad,
    Assets.imagesAverage,
    Assets.imagesVeryGood,
    Assets.imagesExcellent,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          emojis.length,
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
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: kDarkBlueColor,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    emojis[index],
                    height: 11.5,
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
  DailyMoodSheet({Key? key}) : super(key: key);

  final List<String> emojis = [
    Assets.imagesVeryBad,
    Assets.imagesBad,
    Assets.imagesAverage,
    Assets.imagesVeryGood,
    Assets.imagesExcellent,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        onTap: () {
          Get.dialog(
            ImageDialog(
              heading: 'Mood Captured',
              content: 'We hope that you are doing well!',
              imageSize: 107,
              image: Assets.imagesMoodCaptured,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: 'Submit',
        isButtonDisable: false,
        height: 330,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                emojis.length,
                (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: kDarkBlueColor,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          emojis[index],
                          height: 11.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            MyTextField(
              fillColor: kInputFillColor,
              maxLines: 6,
              hint: 'Add a short comment about your mood (optional)',
              marginBottom: 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
