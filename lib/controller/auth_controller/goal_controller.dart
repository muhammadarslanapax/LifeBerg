import 'package:get/get.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';

class GoalController extends GetxController {
  static GoalController instance = Get.find<GoalController>();

  RxInt wellBeingIndex = RxInt(-1);
  String selectedWellBeing = '';

  RxInt wellBeingPlanIndex = RxInt(-1);
  String selectedWellBeingPlan = '';

  RxInt vocationalTaskIndex = RxInt(-1);
  String selectedVocationalTask = '';

  RxInt personalDevIndex = RxInt(-1);
  String selectedPersonalDev = '';

  final List<ToggleButtonModel> wellBeingList = [
    ToggleButtonModel(
      text: 'Nature',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Sleep',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Exercise',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Social',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Nutrition',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Quiet Time',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Gratitude',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Family',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Journaling',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Prayer',
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

  void getWellBeing(int index) {
    wellBeingIndex.value = index;
    var data = wellBeingList[index];
    selectedWellBeing = data.text;
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
    var data = wellBeingList[index];
    selectedWellBeing = data.text;
  }

  final List<ToggleButtonModel> vocationGoalList = [
    ToggleButtonModel(
      text: 'RACGP exam prep',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Exercise physiology training',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Admin tasks',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Stem cell research',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Work productivity',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Try new recipes',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'ANKI',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'OSCE practice',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: '',
      isSelected: false.obs,
    ),
  ];

  void getVocationGoal(int index) {
    vocationalTaskIndex.value = index;
    var data = vocationGoalList[index];
    selectedVocationalTask = data.text;
  }

  final List<ToggleButtonModel> personalDevelopmentList = [
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
  ];

  void getPersonalDevelopments(int index) {
    personalDevIndex.value = index;
    var data = personalDevelopmentList[index];
    selectedPersonalDev = data.text;
  }
}
