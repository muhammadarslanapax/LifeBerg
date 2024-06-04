import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';
import 'package:life_berg/utils/pref_utils.dart';

import '../../constant/color.dart';
import '../../generated/assets.dart';
import '../../model/error/error_response.dart';
import '../../model/goal/goal.dart';
import '../../model/reminder/reminder_date_time.dart';
import '../../utils/toast_utils.dart';
import '../../view/screens/setup_goal/add_new_goal.dart';

class GoalController extends GetxController {
  dynamic argumentData = Get.arguments;

  static GoalController instance = Get.find<GoalController>();

  final HttpManager httpManager = HttpManager();

  final TextEditingController goalNameCon = TextEditingController();
  final TextEditingController goalDesCon = TextEditingController();
  final TextEditingController daysCon = TextEditingController();

  bool isComingFromOnBoarding = false;

  Goal? goal;

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
    'Vocational',
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

  @override
  void onInit() {
    super.onInit();
    selectedGoal.value = argumentData["goalCategory"];
    goalNameCon.text = argumentData["goalName"];
    isComingFromOnBoarding = argumentData["isComingFromOnBoarding"];
    if (argumentData.containsKey("goal")) {
      goal = argumentData["goal"];
      if (goal != null) {
        goalDesCon.text = goal!.description ?? "";
        daysCon.text = goal!.achieveXDays ?? "";
        selectGoalDaysType.value = goal!.achieveType ?? "";
        icon.value = "${goal!.icon ?? ""}";
        isScale.value = goal!.goalMeasure!.type == "string";
        seekbarValue.value = double.parse(goal!.goalImportance ?? "0.0");
        for (var date in goal!.reminders!) {
          timeList.add(ReminderDateTime(
              date.day!, DateFormat("hh:mm").parse(date.time!)));
        }
        color = hexToColor(goal!.color!);
      }
    }
  }

  addNewGoal(Function(bool isSuccess) onGoalCreate) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: "Please wait...");
    httpManager
        .addNewGoal(
            PrefUtils().token,
            icon.value,
            goalNameCon.text.toString(),
            categoryId(selectedGoal.value),
            goalDesCon.text.toString(),
            daysCon.text.toString(),
            selectGoalDaysType.value,
            seekbarValue.value.toInt().toString(),
            isScale.value,
            colorToHex(color!),
            timeList)
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if(response.snapshot! is! ErrorResponse){
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            onGoalCreate(true);
          } else {
            onGoalCreate(false);
          }
        }
      } else {
        onGoalCreate(false);
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  editGoal(Function(bool isSuccess) onGoalCreate) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: "Please wait...");
    httpManager
        .editGoal(
            PrefUtils().token,
            goal!.sId.toString(),
            icon.value,
            goalNameCon.text.toString(),
            categoryId(selectedGoal.value),
            goalDesCon.text.toString(),
            daysCon.text.toString(),
            selectGoalDaysType.value,
            seekbarValue.value.toInt().toString(),
            isScale.value,
            colorToHex(color!),
            timeList)
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        GenericResponse genericResponse = response.snapshot;
        if (genericResponse.success == true) {
          onGoalCreate(true);
        } else {
          onGoalCreate(false);
        }
      } else {
        onGoalCreate(false);
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  String categoryId(String category) {
    switch (category) {
      case 'Wellbeing':
        return "6628e19cb0f93ad8fddbd7a4";
      case 'Vocational':
        return "6638bf06584bab76b306e569";
      case 'Personal Development':
        return "6628e1ac00b9551011466195";
    }
    return '';
  }
}
