import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';

import '../../model/reminder/reminder_date_time.dart';
import '../../view/screens/setup_goal/add_new_goal.dart';

class GoalController extends GetxController {
  static GoalController instance = Get.find<GoalController>();

  final TextEditingController goalNameCon = TextEditingController();
  final TextEditingController goalDesCon = TextEditingController();
  final TextEditingController daysCon = TextEditingController();

  // Fields related to add new goal page..
  RxString icon = "".obs;
  Color? color;
  RxString selectedGoal = "Select category".obs;

  RxString selectGoalDaysType = 'Week'.obs;
  RxDouble seekbarValue = 5.0.obs;
  RxBool isScale = true.obs;
  List<String> items = [
    'Week',
    'Month',
  ];

  List<String> goals = [
    'Select category',
    'Wellbeing',
    'Vocation',
    'Personal Development',
  ];

  RxList<ReminderDateTime> timeList = RxList();

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

  final List<ToggleButtonModel> wellBeingPlanList = [
    ToggleButtonModel(
      text: 'Journal',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Go for a run',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Pray',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Debrief',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Adjust goals',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Contact Jill',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Video call Family',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Gratitude Timeline',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Mentors',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Creativity',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: '',
      isSelected: false.obs,
    ),
  ];

  void getWellBeingPlan(int index) {
    wellBeingIndex.value = index;
    selectedWellBeing = wellBeingList[index];
  }

  final List<String> vocationGoalList = [
    "Case logs",
    "Task prioritisation",
    "Project X",
    "Research X",
    "Plan kid’s activities",
    "Use organiser",
    "Study group",
    "Patient care",
    "Mentoring",
    "Other"
  ];

  void getVocationGoal(int index) {
    vocationalTaskIndex.value = index;
    selectedVocationalTask = vocationGoalList[index];
  }

  final List<String> personalDevelopmentList = [
    "Step out of comfort zone",
    "Acts of kindness",
    "Try new recipes",
    "Acts of kindness",
    "Weights",
    "Quit smoking",
    "Gratitude journal",
    "Other"
  ];

  void getPersonalDevelopments(int index) {
    personalDevIndex.value = index;
    selectedPersonalDev = personalDevelopmentList[index];
  }

  openAddNewGoalPage(String from) {
    if (from == "wellbeing") {
      selectedGoal.value = "Wellbeing";
      goalNameCon.text =
          wellBeingIndex.value != -1 ? wellBeingList[wellBeingIndex.value] : "";
    } else if (from == "vocationalTasks") {
      selectedGoal.value = "Vocation";
      goalNameCon.text = vocationalTaskIndex.value != -1
          ? vocationGoalList[vocationalTaskIndex.value]
          : "";
    } else if (from == "personalDevelopment") {
      selectedGoal.value = "Personal Development";
      goalNameCon.text = personalDevIndex.value != -1
          ? personalDevelopmentList[personalDevIndex.value]
          : "";
    }
    Get.to(
      () => AddNewGoal(),
    );
  }
}
