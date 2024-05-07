import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/launch_controller/launch_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class OnBoarding extends StatelessWidget {
  LaunchController controller = Get.put(LaunchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: controller.currentIndex.value == 0
              ? kPrimaryColor
              : kTertiaryColor,
          elevation: controller.currentIndex.value == 0 ? 0 : 1,
          leading: Obx(
            () {
              return controller.currentIndex.value == 0
                  ? SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => controller.onBackTap(),
                          child: Image.asset(
                            Assets.imagesArrowBack,
                            height: 24,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    );
            },
          ),
          title: Obx(
            () {
              return controller.currentIndex.value == 0
                  ? SizedBox()
                  : MyText(
                      text: 'Back',
                      size: 16,
                      weight: FontWeight.w500,
                      color: kSecondaryColor,
                    );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) => controller.getCurrentPage(index),
                itemCount: controller.onBoardingContent.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      controller.onBoardingContent[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            data['image'],
                          ),
                        ),
                      ),
                      MyText(
                        paddingLeft: 10,
                        paddingRight: 10,
                        text: data['title'],
                        size: 24,
                        weight: FontWeight.w500,
                        align: TextAlign.center,
                      ),
                      MyText(
                        paddingTop: 6,
                        paddingLeft: 10,
                        paddingRight: 10,
                        text: data['description'],
                        size: 16,
                        align: TextAlign.center,
                        height: 1.5,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.onBoardingContent.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 5.0,
                  activeDotColor: kTertiaryColor,
                  dotColor: kTertiaryColor.withOpacity(0.2),
                ),
                onDotClicked: (index) => controller.getCurrentPage(index),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 15,
              ),
              child: Obx(() {
                return MyButton(
                  height: 56,
                  radius: 16.0,
                  text: controller.currentIndex.value == 0
                      ? 'Yes!'
                      : controller.currentIndex.value == 1
                          ? 'Next'
                          : 'Let’s go!',
                  onTap: () => controller.onTap(),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
