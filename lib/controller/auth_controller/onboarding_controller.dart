import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';
import 'package:life_berg/utils/pref_utils.dart';

import '../../constant/color.dart';
import '../../model/reminder/reminder_date_time.dart';
import '../../utils/toast_utils.dart';
import '../../view/screens/setup_goal/add_new_goal.dart';

class OnboardingController extends GetxController {
  RxString selectedGoalType = "".obs;
  RxString selectedGoalName = "".obs;

  RxInt wellBeingIndex = RxInt(-1);
  String selectedWellBeing = '';

  RxInt wellBeingPlanIndex = RxInt(-1);
  String selectedWellBeingPlan = '';

  RxInt vocationalTaskIndex = RxInt(-1);
  String selectedVocationalTask = '';

  RxInt personalDevIndex = RxInt(-1);
  String selectedPersonalDev = '';

  final List<String> wellBeingList = [
    "Nature",
    "Sleep",
    "Exercise",
    "Social",
    "Nutrition",
    "Quiet Time",
    "Gratitude",
    "Family",
    "Journaling",
    "Prayer",
    "Creativity",
    "Other"
  ];

  void getWellBeing(int index) {
    wellBeingIndex.value = index;
    selectedWellBeing = wellBeingList[index];
  }

  final List<String> vocationGoalList = [
    "Patient care,",
    "Research",
    "Project",
    "Study",
    "Prioritisation",
    "Mentor others",
    "Innovation",
    "Household tasks",
    "Children's activities",
    ""
  ];

  void getVocationGoal(int index) {
    vocationalTaskIndex.value = index;
    selectedVocationalTask = vocationGoalList[index];
  }

  final List<String> personalDevelopmentList = [
    "Acts of kindness,",
    "Speak up",
    "Sports",
    "Cooking",
    "Reduce screen time",
    "Music",
    "Learn something new",
    "Reflection",
    ""
  ];

  void getPersonalDevelopments(int index) {
    personalDevIndex.value = index;
    selectedPersonalDev = personalDevelopmentList[index];
  }

  openAddNewGoalPage(String from) {
    if (from == "wellbeing") {
      selectedGoalType.value = "Wellbeing";
      selectedGoalName.value =
          wellBeingIndex.value != -1 ? wellBeingList[wellBeingIndex.value] : "";
    } else if (from == "vocationalTasks") {
      selectedGoalType.value = "Vocational";
      selectedGoalName.value = vocationalTaskIndex.value != -1
          ? vocationGoalList[vocationalTaskIndex.value]
          : "";
    } else if (from == "personalDevelopment") {
      selectedGoalType.value = "Personal Development";
      selectedGoalName.value = personalDevIndex.value != -1
          ? personalDevelopmentList[personalDevIndex.value]
          : "";
    }
    Get.to(() => AddNewGoal(), arguments: {
      "goalCategory": selectedGoalType.value,
      "goalName": selectedGoalName.value,
      "isComingFromOnBoarding" : true
    });
  }
}
