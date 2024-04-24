import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/login.dart';

class LaunchController extends GetxController {
  final pageController = PageController();
  RxInt currentIndex = 0.obs;

  final List<Map<String, dynamic>> onBoardingContent = [
    {
      'image': Assets.imagesOn1,
      'title': 'Are you busy?',
      'description':
          'But keen to optimize your wellbeing, productivity and personal development?',
    },
    {
      'image': Assets.imagesOn2,
      'title': 'Informed by medical students & doctors in Australia',
      'description':
          'LifeBerg is here to help you to become more intentional with your time and squeeze more meaningful activities into your day.',
    },
    {
      'image': Assets.imagesOn3,
      'title': 'Our vision is simple',
      'description':
          'We hope to support you so that you can, in turn, care for those around you. We’re ready when you are!',
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
