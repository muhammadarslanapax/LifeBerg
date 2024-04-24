import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/setup_goal/we_are_off.dart';
import 'package:life_berg/view/screens/setup_goal/well_being.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';


class CompleteProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        appBar: simpleAppBar(
          centerTitle: false,
          title: 'Back',
          onBackTap: () => completeProfileController.onBackTap(),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Obx(() {
              return IndexedStack(
                index: completeProfileController.currentIndex.value,
                children: completeProfileController.profileSteps,
                // PageView.builder(
                //   controller: completeProfileController.pageController,
                //   onPageChanged: (index) =>
                //       completeProfileController.getCurrentIndex(index),
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: completeProfileController.profileSteps.length,
                //   itemBuilder: (context, index) {
                //     return completeProfileController.profileSteps[index];
                //   },
                // ),
              );
            }),
            Obx(() {
              return SizedBox(
                height: completeProfileController.currentIndex.value == 2
                    ? Get.height * 0.13
                    : Get.height * 0.21,
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 20,
              ),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyButton(
                      isDisable: completeProfileController.currentIndex == 0
                          ? completeProfileController
                              .isUserNameVocationDisable.value
                          : completeProfileController.currentIndex.value == 1
                              ? completeProfileController.isIceBergDisable.value
                              : false,
                      text: completeProfileController.currentIndex.value == 2
                          ? 'Let’s go!'
                          : 'Next',
                      onTap: completeProfileController.currentIndex == 2
                          ? () {
                              Get.to(
                                () => WellBeing(),
                              );
                            }
                          : () {
                              completeProfileController.onNext();
                            },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (completeProfileController.currentIndex.value == 2)
                      MyBorderButton(
                        text: 'Skip onboarding',
                        onTap: () {
                          Get.to(
                            () => WeAreOff(),
                          );
                        },
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
