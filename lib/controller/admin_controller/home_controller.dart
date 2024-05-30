import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal/goals_list_response_data.dart';
import 'package:life_berg/model/mood/mood_data.dart';

import '../../constant/color.dart';
import '../../model/error/error_response.dart';
import '../../model/goal/goal.dart';
import '../../model/goal/goal_submit/goal_submit_data.dart';
import '../../model/user/user.dart';
import '../../model/user/user_response.dart';
import '../../utils/pref_utils.dart';
import '../../utils/toast_utils.dart';

class HomeController extends GetxController {
  final HttpManager httpManager = HttpManager();

  final TextEditingController moodCommentController = TextEditingController();
  final TextEditingController goalCommentController = TextEditingController();

  User? user;
  RxString fullName = "".obs;
  RxString userProfileImageUrl = "".obs;

  XFile? xFile;
  RxString imageFilePath = "".obs;

  RxMoodData selectedMood = RxMoodData(emoji: "", value: -1);

  RxBool isLoadingGoals = true.obs;

  List<Goal> wellBeingGoals = <Goal>[].obs;
  List<Goal> vocationalGoals = <Goal>[].obs;
  List<Goal> personalDevGoals = <Goal>[].obs;

  List<GoalSubmitData> goalSubmitData = [];

  @override
  void onInit() {
    super.onInit();
    _getUserData();
  }

  updateEmoji(String emoji, int value) {
    selectedMood.emoji.value = emoji;
    selectedMood.value.value = value;
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      checkAndResetGoals();
      user = User.fromJson(json.decode(PrefUtils().user));
      fullName.value = user?.fullName ?? "";
      userProfileImageUrl.value = user?.profilePicture ?? "";
      if (PrefUtils().submittedGoals.isNotEmpty) {
        List<dynamic> jsonList = jsonDecode(PrefUtils().submittedGoals);
        List<GoalSubmitData> goalSubmitDataList = jsonList
            .map((jsonItem) => GoalSubmitData.fromJson(jsonItem))
            .toList();
        goalSubmitData.addAll(goalSubmitDataList);
      }
      getUserGoals();
    }
  }

  checkAndResetGoals() async {
    DateTime now = DateTime.now();
    DateTime? lastCheckedDate = PrefUtils().lastSavedDate.isNotEmpty
        ? DateTime.parse(PrefUtils().lastSavedDate)
        : null;
    if (lastCheckedDate == null || _isResetTimeReached(now, lastCheckedDate)) {
      PrefUtils().submittedGoals = "";
      PrefUtils().lastSavedDate = now.toIso8601String();
    }
  }

  bool _isResetTimeReached(DateTime now, DateTime lastCheckedDate) {
    DateTime resetTimeToday = DateTime(now.year, now.month, now.day, 2, 0);

    // Check if current time is at or after 02:00 AM today
    bool isAfterResetToday =
        now.isAfter(resetTimeToday) || now.isAtSameMomentAs(resetTimeToday);

    // Check if the last checked date is before today
    bool isLastCheckedBeforeToday = lastCheckedDate.isBefore(resetTimeToday);

    return isAfterResetToday && isLastCheckedBeforeToday;
  }

  saveLocalData(Goal goal, bool isChecked, String trackValue) {
    bool isFound = false;
    for (var goals in goalSubmitData) {
      if (goals.goalId == goal.sId) {
        if (goal.goalMeasure!.type == "string") {
          goals.measureValue = trackValue;
        } else {
          goals.isChecked = isChecked;
        }
        isFound = true;
      }
    }
    if (!isFound) {
      GoalSubmitData goalData = GoalSubmitData(
          goal.sId!, goal.goalMeasure!.type!, isChecked, trackValue);
      goalSubmitData.add(goalData);
    }
    String jsonString =
        jsonEncode(goalSubmitData.map((goal) => goal.toJson()).toList());
    PrefUtils().submittedGoals = jsonString;
  }

  bool checkIsGoalChecked(Goal goal) {
    for (var goalData in goalSubmitData) {
      if (goalData.goalId == goal.sId!) {
        return goalData.isChecked;
      }
    }
    return false;
  }

  String checkGoalTrackValue(Goal goal) {
    for (var goalData in goalSubmitData) {
      if (goalData.goalId == goal.sId!) {
        return goalData.measureValue;
      }
    }
    return "0.0";
  }

  String getFirstName(String fullName) {
    // Split the full name by space
    List<String> nameParts = fullName.split(' ');

    // Return the first part of the name, which is the first name
    return nameParts[0];
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 20) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  updateUserImage() async {
    SmartDialog.showLoading(msg: "Please wait..");
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUserImage(PrefUtils().token, PrefUtils().userId, xFile!)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            this.user?.profilePicture = userResponse.user?.profilePicture;
            userProfileImageUrl.value = user?.profilePicture ?? "";
            PrefUtils().user = json.encode(user);
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(userResponse.message ?? "", color: kRedColor);
          }
        } else {
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
      }
    });
  }

  updateUserMood() async {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUserMood(PrefUtils().token, selectedMood.value.value,
            moodCommentController.text.toString())
        .then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GenericResponse genericResponse = value.snapshot;
          if (genericResponse.success == true) {
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(genericResponse.message ?? "",
                color: kRedColor);
          }
        } else {
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
      }
    });
  }

  getUserGoals() async {
    vocationalGoals.clear();
    personalDevGoals.clear();
    wellBeingGoals.clear();
    isLoadingGoals.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserGoalsList(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalsListResponse goalsListResponse = value.snapshot;
          if (goalsListResponse.success == true) {
            if (goalsListResponse.data != null) {
              if (goalsListResponse.data!.vocational != null) {
                for (var goal in goalsListResponse.data!.vocational!) {
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  vocationalGoals.add(goal);
                }
              }
              if (goalsListResponse.data!.personalDevelopment != null) {
                for (var goal in goalsListResponse.data!.personalDevelopment!) {
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  personalDevGoals.add(goal);
                }
              }
              if (goalsListResponse.data!.wellBeing != null) {
                for (var goal in goalsListResponse.data!.wellBeing!) {
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  wellBeingGoals.add(goal);
                }
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(goalsListResponse.message ?? "",
                color: kRedColor);
          }
        } else {
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
      }
      isLoadingGoals.value = false;
    });
  }

  deleteGoal(Goal goal, String type, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .deleteGoal(
      PrefUtils().token,
      goal.sId!,
    )
        .then((response) {
      if (response.error == null) {
        GenericResponse genericResponse = response.snapshot;
        if (genericResponse.success == true) {
          switch (type) {
            case "wellbeing":
              wellBeingGoals.removeAt(index);
              break;
            case "vocation":
              vocationalGoals.removeAt(index);
              break;
            case "personal_development":
              personalDevGoals.removeAt(index);
              break;
          }
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  archiveGoal(Goal goal, String type, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateGoalStatus(PrefUtils().token, goal.sId!, "archive")
        .then((response) {
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            switch (type) {
              case "wellbeing":
                wellBeingGoals.removeAt(index);
                break;
              case "vocation":
                vocationalGoals.removeAt(index);
                break;
              case "personal_development":
                personalDevGoals.removeAt(index);
                break;
            }
          }
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  addCommentOnGoal(Goal goal, String type, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .addCommentOnGoal(
            PrefUtils().token, goal.sId!, goalCommentController.text.toString())
        .then((response) {
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            switch (type) {
              case "wellbeing":
                goal.comment = goalCommentController.text.toString();
                wellBeingGoals[index] = goal;
                break;
              case "vocation":
                goal.comment = goalCommentController.text.toString();
                vocationalGoals[index] = goal;
                break;
              case "personal_development":
                goal.comment = goalCommentController.text.toString();
                personalDevGoals[index] = goal;
                break;
            }
          }
          goalCommentController.text = "";
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }
}
