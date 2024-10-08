import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/controller/auth_controller/complete_profile_controller.dart';
import 'package:life_berg/view/screens/setup_goal/we_are_off.dart';
import 'package:life_berg/view/screens/setup_goal/well_being.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../../constant/color.dart';

class CompleteProfile extends StatelessWidget {
  final CompleteProfileController controller =
      Get.put(CompleteProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        centerTitle: false,
        title: back,
        onBackTap: () => controller.onBackTap(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return IndexedStack(
                index: controller.currentIndex.value,
                children: controller.profileSteps,
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 20,
            ),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyButton(
                    height: 56,
                    radius: 16,
                    isDisable: controller.currentIndex == 0
                        ? controller.isUserNameVocationDisable.value
                        : controller.currentIndex.value == 1
                            ? controller.isIceBergDisable.value
                            : false,
                    text: controller.currentIndex.value == 2 ? letsGo : next,
                    onTap: controller.currentIndex == 2
                        ? () {
                            Get.to(
                              () => WellBeing(),
                            );
                          }
                        : () {
                            if (controller.currentIndex == 0) {
                              controller.updateUsername();
                            } else {
                              controller.updateIcebergName();
                            }
                          },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (controller.currentIndex.value == 2)
                    MyBorderButton(
                      radius: 16,
                      height: 56,
                      text: skipOnboarding,
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
    );
  }
}
