import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/screens/auth/login.dart';

class LaunchController extends GetxController {
  final pageController = PageController();
  RxInt currentIndex = 0.obs;

  final List<Map<String, dynamic>> onBoardingContent = [
    {
      'image': Assets.imagesOn1,
      'title': onboardHeadingOne,
      'description': onboardDesOne,
    },
    {
      'image': Assets.imagesOn2,
      'title': onboardHeadingTwo,
      'description': onboardDesTwo,
    },
    {
      'image': Assets.imagesOn3,
      'title': onboardHeadingThree,
      'description': onboardDesThree,
    },
  ];

  void getCurrentPage(int index) => currentIndex.value = index;

  void onBackTap() {
    pageController.previousPage(
      duration: Duration(
        milliseconds: 230,
      ),
      curve: Curves.easeInOut,
    );
  }

  void onTap() {
    if (currentIndex.value == 2) {
      PrefUtils().setIsShowIntro = false;
    }
    currentIndex.value == 2
        ? Get.offAll(() => Login())
        : pageController.nextPage(
            duration: Duration(
              milliseconds: 230,
            ),
            curve: Curves.easeInOut,
          );
  }
}
