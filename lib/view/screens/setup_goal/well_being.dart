import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/setup_goal/add_new_goal.dart';
import 'package:life_berg/view/screens/setup_goal/vocation_goal.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:lottie/lottie.dart';

class WellBeing extends StatelessWidget {
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
                Assets.imagesOptimiseYourWellbeing,
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
                  text: 'Optimise your wellbeing',
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
                    for (int i = 0; i < 4; i++)
                      Obx(
                        () {
                          var data = goalController.wellBeingList[i];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () => goalController.getWellBeing(i),
                                text: data.text,
                                isSelected: goalController.wellBeingIndex == i,
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
                    for (int i = 4; i < 8; i++)
                      Obx(
                        () {
                          var data = goalController.wellBeingList[i];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                horizontalPadding: 0.0,
                                onTap: () => goalController.getWellBeing(i),
                                text: data.text,
                                isSelected: goalController.wellBeingIndex == i,
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
                    for (int i = 8; i < 12; i++)
                      if (i == 11)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => AddNewGoal(createdFrom: 'wellbeing'),
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
                            var data = goalController.wellBeingList[i];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ToggleButton(
                                onTap: () => goalController.getWellBeing(i),
                                text: data.text,
                                isSelected: goalController.wellBeingIndex == i,
                              ),
                            );
                          },
                        ),
                  ],
                ),
                // Wrap(
                //   spacing: 10,
                //   runSpacing: 13,
                //   children: List.generate(
                //     goalController.wellBeingList.length,
                //     (index) {
                //       if (index == goalController.wellBeingList.length - 1) {
                //         return GestureDetector(
                //           onTap: () => Get.to(() => AddNewGoal()),
                //           child: Image.asset(
                //             Assets.imagesAddIcon,
                //             height: 29,
                //           ),
                //         );
                //       } else {
                //         var data = goalController.wellBeingList[index];
                //         return Obx(() {
                //           return ToggleButton(
                //             onTap: () => goalController.getWellBeing(index),
                //             text: data.text,
                //             isSelected: goalController.wellBeingIndex == index,
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
                      () => AddNewGoal(createdFrom: 'wellbeing'),
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
                    onTap: () => Get.to(() => VocationGoal()),
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
