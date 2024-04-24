import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/setup_goal/add_new_goal.dart';
import 'package:life_berg/view/screens/setup_goal/personal_development_goal.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:lottie/lottie.dart';

class VocationGoal extends StatelessWidget {
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
                Assets.imagesNew2,
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
                Row(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Obx(
                        () {
                          var data = goalController.vocationGoalList[i];
                          return Expanded(
                            flex: i == 0 ? 4 : 6,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () => goalController.getVocationGoal(i),
                                text: data.text,
                                isSelected:
                                    goalController.vocationalTaskIndex.value ==
                                        i,
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
                          var data = goalController.vocationGoalList[i];
                          return Expanded(
                            flex: i == 2 ? 2 : 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () => goalController.getVocationGoal(i),
                                text: data.text,
                                isSelected:
                                    goalController.vocationalTaskIndex.value ==
                                        i,
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
                    for (int i = 5; i < 9; i++)
                      if (i == 8)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () =>
                                    AddNewGoal(createdFrom: 'vocationalTasks'),
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
                            var data = goalController.vocationGoalList[i];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 12.5,
                                onTap: () => goalController.getVocationGoal(i),
                                text: data.text,
                                isSelected:
                                    goalController.vocationalTaskIndex.value ==
                                        i,
                              ),
                            );
                          },
                        ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 0),
                //   child: Wrap(
                //     crossAxisAlignment: WrapCrossAlignment.center,
                //     spacing: 8,
                //     runSpacing: 16,
                //     children: List.generate(
                //       goalController.vocationGoalList.length,
                //       (index) {
                //         if (index ==
                //             goalController.vocationGoalList.length - 1) {
                //           return GestureDetector(
                //             onTap: () => Get.to(() => AddNewGoal()),
                //             child: Image.asset(
                //               Assets.imagesAddIcon,
                //               height: 34,
                //             ),
                //           );
                //         } else {
                //           var data = goalController.vocationGoalList[index];
                //           return Obx(() {
                //             return ToggleButton(
                //               horizontalPadding: 8.0,
                //               onTap: () =>
                //                   goalController.getVocationGoal(index),
                //               text: data.text,
                //               isSelected: data.isSelected.value,
                //             );
                //           });
                //         }
                //       },
                //     ),
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
                      () => AddNewGoal(createdFrom: 'vocationalTasks'),
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
                    onTap: () => Get.to(() => PersonalDevelopmentGoal()),
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
