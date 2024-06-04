import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/auth_controller/onboarding_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/setup_goal/personal_development_goal.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:lottie/lottie.dart';

import '../../../constant/color.dart';

class VocationGoal extends StatelessWidget {

  final OnboardingController onboardingController = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Back',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Lottie.asset(
                Assets.imagesNew2,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  paddingTop: 15,
                  text: 'Optimise your vocational tasks',
                  size: 22,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                MyText(
                  paddingLeft: 4,
                  paddingTop: 40,
                  text: 'Select a goal or add your own!',
                  size: 16,
                  paddingBottom: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: onboardingController.vocationGoalList
                        .asMap()
                        .map((i, element) => MapEntry(
                              i,
                              element != "Other"
                                  ? Obx(
                                      () {
                                        return ToggleButton(
                                          horizontalPadding: 10.0,
                                          onTap: () =>
                                              onboardingController.getVocationGoal(i),
                                          text: element,
                                          isSelected:
                                          onboardingController.vocationalTaskIndex == i,
                                        );
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        onboardingController.openAddNewGoalPage("vocationalTasks");
                                      },
                                      child: Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            border: Border.all(
                                              width: 1.0,
                                              color: kBorderColor,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 12.0),
                                        child: SvgPicture.asset(
                                            "assets/vectors/ic_plus.svg"),
                                      ),
                                    ),
                            ))
                        .values
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: MyButton(
                    height: 56,
                    radius: 16,
                    isDisable: false,
                    text: 'Create your goal',
                    onTap: () => onboardingController.openAddNewGoalPage("vocationalTasks"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: MyBorderButton(
                    height: 56,
                    radius: 16,
                    text: 'Skip',
                    onTap: () => Get.to(() => PersonalDevelopmentGoal()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Platform.isIOS ? IOS_BOTTOM_MARGIN : 15,
            ),
          ],
        ),
      ),
    );
  }
}
