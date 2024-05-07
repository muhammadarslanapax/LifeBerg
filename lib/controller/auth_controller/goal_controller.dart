import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';

class GoalController extends GetxController {
  static GoalController instance = Get.find<GoalController>();

  final TextEditingController goalNameCon = TextEditingController();
  final TextEditingController goalDesCon = TextEditingController();
  final TextEditingController daysCon = TextEditingController();

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

  // final List<ToggleButtonModel> vocationGoalList = [
  //   ToggleButtonModel(
  //     text: 'RACGP exam prep',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'Exercise physiology training',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'Admin tasks',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'Stem cell research',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'Work productivity',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'Try new recipes',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'ANKI',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: 'OSCE practice',
  //     isSelected: false.obs,
  //   ),
  //   ToggleButtonModel(
  //     text: '',
  //     isSelected: false.obs,
  //   ),
  // ];

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

  /*final List<ToggleButtonModel> personalDevelopmentList = [
    ToggleButtonModel(
      text: 'Flute practice',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Check in with someone different daily',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Surfing classes',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Acts of kindness',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Weight training',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Quit smoking',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Gratitude journal',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: '',
      isSelected: false.obs,
    ),
  ];*/

  void getPersonalDevelopments(int index) {
    personalDevIndex.value = index;
    selectedPersonalDev = personalDevelopmentList[index];
  }
}
