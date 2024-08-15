import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:lottie/lottie.dart';

class WeAreOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Back',
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Lottie.asset(
                Assets.imagesNew3,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                paddingLeft: 10,
                paddingRight: 10,
                text: 'And we’re off!',
                size: 24,
                weight: FontWeight.w500,
                align: TextAlign.center,
              ),
              MyText(
                paddingLeft: 10,
                paddingRight: 10,
                paddingTop: 6,
                text:
                    'From our team at LifeBerg, we would like to welcome you onboard and wish you all the best as you embark on your journey!',
                size: 16,
                height: 1.5,
                align: TextAlign.center,
              ),
            ],
          ),
          Spacer(
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MyButton(
              height: 56,
              radius: 16,
              isDisable: false,
              text: 'Let’s go!',
              onTap: () => Get.offAll(() => BottomNavBar(
                    key: bottomNavBarKey,
                  )),
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
