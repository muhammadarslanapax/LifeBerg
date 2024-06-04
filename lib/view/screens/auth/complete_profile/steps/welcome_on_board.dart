import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../controller/auth_controller/complete_profile_controller.dart';

class WelcomeOnBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompleteProfileController controller =
        Get.find<CompleteProfileController>();
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: [
        Lottie.asset(
          Assets.imagesNew4,
          height: 256,
        ),
        Obx(() => MyText(
              paddingLeft: 10,
              paddingRight: 10,
              paddingTop: 10,
              text: 'Welcome aboard, ${controller.userFullName.value}!',
              size: 24,
              weight: FontWeight.w500,
              align: TextAlign.center,
            )),
        MyText(
          paddingTop: 6,
          paddingLeft: 10,
          paddingRight: 10,
          text:
              'Let’s start by creating goals to boost your\n\n1. Wellbeing\n2. Vocational Tasks\n3. Personal Development',
          size: 16,
          align: TextAlign.center,
          height: 1.5,
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
