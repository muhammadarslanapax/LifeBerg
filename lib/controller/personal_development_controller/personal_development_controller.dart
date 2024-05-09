import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:life_berg/generated/assets.dart';

class PersonalDevelopmentController extends GetxController {
  static PersonalDevelopmentController instance = Get.find<PersonalDevelopmentController>();

  final latestUpdatePageController = PageController();
  final videoPageController = PageController();
  RxInt latestUpdateCI = 0.obs;
  RxInt videoCI = 0.obs;

  final List<Map<String, dynamic>> exploreTopics = [
    {
      'img': Assets.imagesWellBing,
      'title': 'Wellbeing',
    },
    {
      'img': Assets.imagesNutrition,
      'title': 'Nutrition',
    },
    {
      'img': Assets.imagesInsights,
      'title': 'Insights',
    },
    {
      'img': Assets.imagesMedSchool,
      'title': 'Med School',
    },
    {
      'img': Assets.imagesClinical,
      'title': 'Clinical',
    },
    {
      'img': Assets.imagesDevelopment,
      'title': 'Development',
    },
  ];

  void onUpdatePageChanged(int index) {
    latestUpdateCI.value = index;
  }
  void onVideoPageChanged(int index) {
    videoCI.value = index;
  }
}
