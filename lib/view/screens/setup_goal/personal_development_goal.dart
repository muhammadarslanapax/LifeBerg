import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/setup_goal/add_new_goal.dart';
import 'package:life_berg/view/screens/setup_goal/we_are_off.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:lottie/lottie.dart';

class PersonalDevelopmentGoal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Back',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Lottie.asset(
                Assets.imagesNew1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  paddingTop: 10,
                  text: 'Optimise your personal development',
                  size: 18,
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
                Row(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Obx(
                        () {
                          var data = goalController.personalDevelopmentList[i];
                          return Expanded(
                            flex: i == 0 ? 3 : 7,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () =>
                                    goalController.getPersonalDevelopments(i),
                                text: data.text,
                                isSelected:
                                    goalController.personalDevIndex.value == i,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    for (int i = 2; i < 5; i++)
                      Obx(
                        () {
                          var data = goalController.personalDevelopmentList[i];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () =>
                                    goalController.getPersonalDevelopments(i),
                                text: data.text,
                                isSelected:
                                    goalController.personalDevIndex.value == i,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    for (int i = 5; i < 8; i++)
                      if (i == 7)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => AddNewGoal(
                                    createdFrom: 'personalDevelopment'),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  Assets.imagesAddIcon,
                                  height: 34,
                                  width: 38,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Obx(
                          () {
                            var data =
                                goalController.personalDevelopmentList[i];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 12.5,
                                onTap: () =>
                                    goalController.getPersonalDevelopments(i),
                                text: data.text,
                                isSelected:
                                    goalController.personalDevIndex.value == i,
                              ),
                            );
                          },
                        ),
                  ],
                ),
                // Wrap(
                //   spacing: 8,
                //   runSpacing: 13,
                //   children: List.generate(
                //     goalController.personalDevelopmentList.length,
                //     (index) {
                //       if (index ==
                //           goalController.personalDevelopmentList.length - 1) {
                //         return GestureDetector(
                //           onTap: () => Get.to(() => AddNewGoal()),
                //           child: Image.asset(
                //             Assets.imagesAddIcon,
                //             height: 29,
                //           ),
                //         );
                //       } else {
                //         var data =
                //             goalController.personalDevelopmentList[index];
                //         return Obx(() {
                //           return ToggleButton(
                //             onTap: () =>
                //                 goalController.getPersonalDevelopments(index),
                //             text: data.text,
                //             isSelected: data.isSelected.value,
                //           );
                //         });
                //       }
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: MyButton(
                    isDisable: false,
                    text: 'Create your goal',
                    onTap: () => Get.to(
                      () => AddNewGoal(createdFrom: 'personalDevelopment'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: MyBorderButton(
                    text: 'Skip',
                    onTap: () => Get.to(() => WeAreOff()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Platform.isIOS ? IOS_BOTTOM_MARGIN : 15,
          ),
        ],
      ),
    );
  }
}
