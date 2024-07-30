import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal_mood_report/goal_date_response.dart';

import '../../../../constant/color.dart';
import '../../../../model/error/error_response.dart';
import '../../../../model/goal/goal.dart';
import '../../../../model/goal/goals_list_response.dart';
import '../../../../model/goal_report/goal_report_list_response.dart';
import '../../../../model/user/user.dart';
import '../../../../model/user/user_response.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../utils/toast_utils.dart';
import '../../../widget/my_dialog.dart';

class SettingsController extends GetxController {
  final HttpManager httpManager = HttpManager();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController primaryVocationController =
      TextEditingController();

  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController mewPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  RxBool isLoadingGoals = true.obs;
  List<Goal> wellBeingGoals = <Goal>[].obs;
  List<Goal> vocationalGoals = <Goal>[].obs;
  List<Goal> personalDevGoals = <Goal>[].obs;

  RxDouble wellbeingPercentage = 0.0.obs;
  RxDouble vocationPercentage = 0.0.obs;
  RxDouble personalDevPercentage = 0.0.obs;
  RxDouble globalPercentage = 0.0.obs;

  List<Goal> submittedWellBeingGoals = <Goal>[].obs;
  List<Goal> submittedVocationalGoals = <Goal>[].obs;
  List<Goal> submittedPersonalDevGoals = <Goal>[].obs;

  RxString selectedVocation = ''.obs;
  final List<String> vocationList = [
    "Medical Student",
    "Junior Doctor",
    "Senior Doctor",
    "Nurse",
    "Allied Health",
    "Skilled Trade",
    "Full Time Parent",
    "Administration",
    "Agriculture & Environment",
    "Architecture & Design",
    "Business",
    "Computer & IT",
    "Defence",
    "Education",
    "Engineering",
    "Health",
    "Hospitality",
    "Humanities & Social Sciences",
    "Law",
    "Media",
    "Music & Arts",
    "Retail",
    "Science & Mathematics",
    "Psychology",
    "Retired",
    "Other"
  ];

  DateTime? selectedCalendarDate;
  RxString date = "".obs;

  User? user;
  RxBool isLoadingUserData = true.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
    date.value = DateTime.now().toUtc().toIso8601String();
    getGoalReportByDate(date.value);
    nameController.addListener(() {
      if (nameController.text.isNotEmpty) {
        updateUser(fullName: nameController.text.toString());
      }
    });

    nameController.addListener(() {
      if (nameController.text.isNotEmpty) {
        updateUser(fullName: nameController.text.toString());
      }
    });
  }

  @override
  void onClose() {
    // moodCommentController.dispose();
    // goalCommentController.dispose();
    // learnedTodayController.dispose();
    // greatFulController.dispose();
    // tomorrowHighlightController.dispose();
    super.onClose();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
      nameController.text = user?.fullName ?? "";
      emailController.text = user?.email ?? "";
      countryController.text = user?.country ?? "";
      selectedVocation.value = user?.primaryVocation ?? "";
      dobController.text = user?.dob ?? "";
      isLoadingUserData.value = false;
      getUserGoals();
    }
  }

  updateUser(
      {String? country,
      String? iceberg,
      String? fullName,
      String? primaryVocation,
      String? dob}) async {
    httpManager
        .updateUser(PrefUtils().token, PrefUtils().userId,
            country: country,
            iceberg: iceberg,
            primaryVocation: primaryVocation,
            fullName: fullName,
            dob: dob)
        .then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            if (iceberg != null) {
              PrefUtils().loggedIn = true;
            }
            PrefUtils().user = json.encode(userResponse.user);
          } else {
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

  resetPassword(
      BuildContext context, String currentPassword, String newPassword) async {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .resetPassword(PrefUtils().token, currentPassword, newPassword)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GenericResponse genericResponse = value.snapshot;
          if (genericResponse.success == true) {
            showDialog(
              context: context,
              builder: (_) {
                return MyDialog(
                  height: 184,
                  heading: 'Reset Password',
                  content: 'Your current password has been reset.',
                  onOkay: () => Get.back(),
                );
              },
            );
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

  getUserGoals({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingGoals.value = true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserGoalsList(PrefUtils().token, "archive").then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalsListResponse goalsListResponse = value.snapshot;
          if (goalsListResponse.success == true) {
            if (goalsListResponse.data != null) {
              vocationalGoals.clear();
              personalDevGoals.clear();
              wellBeingGoals.clear();
              if (goalsListResponse.data!.vocational != null) {
                for (var goal in goalsListResponse.data!.vocational!) {
                  vocationalGoals.add(goal);
                }
              }
              if (goalsListResponse.data!.personalDevelopment != null) {
                for (var goal in goalsListResponse.data!.personalDevelopment!) {
                  personalDevGoals.add(goal);
                }
              }
              if (goalsListResponse.data!.wellBeing != null) {
                for (var goal in goalsListResponse.data!.wellBeing!) {
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
      if (isShowLoading) {
        isLoadingGoals.value = false;
      }
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
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  restoreGoal(Goal goal, String type, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateGoalStatus(PrefUtils().token, goal.sId!, "active")
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

  calculatePercentage(List<Goal> goals, String type) {
    double totalCompletion = 0;
    goals.forEach((goal) {
      if (goal.goalMeasure!.type == "boolean") {
        totalCompletion += goal.isChecked.value ? 1 : 0;
      } else {
        totalCompletion += goal.sliderValue.value / 10.0;
      }
    });
    double percentage = (totalCompletion / goals.length) * 100;
    switch (type) {
      case "wellbeing":
        wellbeingPercentage.value = percentage;
        break;
      case "vocation":
        vocationPercentage.value = percentage;
        break;
      case "personal_development":
        personalDevPercentage.value = percentage;
        break;
    }
    int totalCategories = 3;
    double globalTotalPer = wellbeingPercentage.value +
        vocationPercentage.value +
        personalDevPercentage.value;
    globalPercentage.value = globalTotalPer / totalCategories;
  }

  getGoalReportByDate(String date, {bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingGoals.value = true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getGoalReportByDate(PrefUtils().token, date).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalDateResponse goalDateResponse = value.snapshot;
          if (goalDateResponse.success == true) {
            if (goalDateResponse.data != null) {
              submittedPersonalDevGoals.clear();
              submittedVocationalGoals.clear();
              submittedWellBeingGoals.clear();
              if (goalDateResponse.data!.checkReports != null) {
                for (var data
                    in goalDateResponse.data!.checkReports!.details!) {
                  if (data.goal != null) {
                    if (data.goal!.goalMeasure!.type == "boolean") {
                      data.goal!.isChecked.value = data.value == "true";
                    } else {
                      data.goal!.sliderValue.value =
                          double.parse(data.value ?? "0.0");
                    }
                    data.goal!.comment = data.comment;
                    if (data.goal != null) {
                      if (data.goal!.category!.name == "Wellbeing") {
                        submittedWellBeingGoals.add(data.goal!);
                      } else if (data.goal!.category!.name ==
                          "Personal Development") {
                        submittedPersonalDevGoals.add(data.goal!);
                      } else {
                        submittedVocationalGoals.add(data.goal!);
                      }
                    }
                  }
                }
              }
              if (submittedPersonalDevGoals.isNotEmpty) {
                calculatePercentage(
                    submittedPersonalDevGoals, "personal_development");
              }
              if (submittedWellBeingGoals.isNotEmpty) {
                calculatePercentage(submittedWellBeingGoals, "wellbeing");
              }
              if (submittedVocationalGoals.isNotEmpty) {
                calculatePercentage(submittedVocationalGoals, "vocation");
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(goalDateResponse.message ?? "",
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
      if (isShowLoading) {
        isLoadingGoals.value = false;
      }
    });
  }
}
