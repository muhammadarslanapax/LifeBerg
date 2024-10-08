import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

import '../../../../../controller/auth_controller/complete_profile_controller.dart';

class IceBerg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompleteProfileController controller =
        Get.find<CompleteProfileController>();
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      children: [
        SizedBox(
          height: 30,
        ),
        Image.asset(
          Assets.imagesIceBag,
          height: 157,
        ),
        Obx(() => MyText(
          paddingTop: 25,
          text: 'Hello, ${controller.userPreferredName.value}!',
          size: 24,
          weight: FontWeight.w500,
          align: TextAlign.center,
        )),
        MyText(
          paddingTop: 6,
          text: 'I will be your companion! Would you like to name me?',
          size: 16,
          align: TextAlign.center,
          height: 1.5,
          paddingBottom: 20,
        ),
        MyTextField(
          hint: 'Name your iceberg',
          textInputAction: TextInputAction.done,
          fillColor: kSecondaryColor,
          controller: controller.iceBergCon,
          onChanged: (value) => controller.getIceBerg(value),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.profileSteps.length,
            (index) {
              return Obx(() {
                return AnimatedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 2.5),
                  duration: Duration(
                    milliseconds: 250,
                  ),
                  curve: Curves.easeInOut,
                  height: 8,
                  width: controller.currentIndex.value == index ? 22 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: controller.currentIndex.value == index
                        ? kTertiaryColor
                        : kTertiaryColor.withOpacity(0.2),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
