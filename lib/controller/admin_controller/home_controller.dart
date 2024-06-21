import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/mood/mood_data.dart';
import 'package:life_berg/utils/date_utility.dart';

import '../../constant/color.dart';
import '../../constant/strings.dart';
import '../../generated/assets.dart';
import '../../model/error/error_response.dart';
import '../../model/goal/goal.dart';
import '../../model/goal/goal_submit/goal_submit_data.dart';
import '../../model/user/user.dart';
import '../../model/user/user_response.dart';
import '../../utils/pref_utils.dart';
import '../../utils/toast_utils.dart';

class HomeController extends FullLifeCycleController with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  late TextEditingController moodCommentController;
  late TextEditingController goalCommentController = TextEditingController();

  RxBool isLoadingGoals = true.obs;
  RxBool isShowHighlight = false.obs;

  User? user;
  RxString fullName = "".obs;
  RxString userName = "".obs;
  RxString userProfileImageUrl = "".obs;

  XFile? xFile;
  RxString imageFilePath = "".obs;

  RxMoodData selectedMood = RxMoodData(emoji: "", value: -1);

  List<Goal> wellBeingGoals = <Goal>[].obs;
  List<Goal> vocationalGoals = <Goal>[].obs;
  List<Goal> personalDevGoals = <Goal>[].obs;

  RxBool isHighlightChecked = false.obs;

  List<GoalSubmitData> goalSubmitData = [];

  RxString selectedAvatar = "".obs;
  final List<String> avatars = [
    Assets.avatarA1,
    Assets.avatarA2,
    Assets.avatarA3,
    Assets.avatarA5,
    Assets.avatarA6,
    Assets.avatarA7,
    Assets.avatarA8,
    Assets.avatarA9,
    Assets.avatarA10,
    Assets.avatarA11,
    Assets.avatarA12,
    Assets.avatarA13,
    Assets.avatarA14,
    Assets.avatarA15,
    Assets.avatarA16,
    Assets.avatarA17,
    Assets.avatarA18,
    Assets.avatarA19,
    Assets.avatarA20,
    Assets.avatarA21,
    Assets.avatarA22,
    Assets.avatarA23,
    Assets.avatarA24,
    Assets.avatarA25,
    Assets.avatarA26,
    Assets.avatarA27,
    Assets.avatarA28,
  ];

  @override
  void onInit() {
    moodCommentController = TextEditingController();
    goalCommentController = TextEditingController();
    super.onInit();
    print("onInit");
    _getUserData();
  }

  @override
  void onReady() {
    super.onReady();
    print("onReady");
  }

  @override
  void onClose() {
    moodCommentController.dispose();
    goalCommentController.dispose();
    // learnedTodayController.dispose();
    // greatFulController.dispose();
    // tomorrowHighlightController.dispose();
    super.onClose();
    print("onClose");
  }

  updateEmoji(String emoji, int value) {
    selectedMood.emoji.value = emoji;
    selectedMood.value.value = value;
  }

  _getUserData({bool isShowLoading = true}) {
    if (PrefUtils().user.isNotEmpty) {
      checkAndResetGoals();
      user = User.fromJson(json.decode(PrefUtils().user));
      fullName.value = user?.fullName ?? "";
      userName.value = user?.userName ?? "";
      userProfileImageUrl.value = user?.profilePicture ?? "";
      if (PrefUtils().submittedGoals.isNotEmpty) {
        List<dynamic> jsonList = jsonDecode(PrefUtils().submittedGoals);
        List<GoalSubmitData> goalSubmitDataList = jsonList
            .map((jsonItem) => GoalSubmitData.fromJson(jsonItem))
            .toList();
        goalSubmitData.clear();
        goalSubmitData.addAll(goalSubmitDataList);
      }
      isShowTomorrowHighlight();
      getUserGoals(isShowLoading: isShowLoading);
    }
  }

  isShowTomorrowHighlight() {
    if (PrefUtils().tomorrowHighlightGoalDate.isNotEmpty) {
      var tomorrowHighlightDate =
          DateTime.parse(PrefUtils().tomorrowHighlightGoalDate);
      var now = DateTime.now();
      if (tomorrowHighlightDate.year == now.year &&
          tomorrowHighlightDate.month == now.month &&
          tomorrowHighlightDate.day == now.day) {
        isShowHighlight.value = true;
      } else {
        isShowHighlight.value = false;
      }
    } else {
      isShowHighlight.value = false;
    }
  }

  checkAndResetGoals() async {
    DateTime now = DateTime.now();
    DateTime? lastCheckedDate = PrefUtils().lastSavedDate.isNotEmpty
        ? DateTime.parse(PrefUtils().lastSavedDate)
        : null;
    if (lastCheckedDate == null ||
        DateUtility.isResetTimeReached(now, lastCheckedDate)) {
      PrefUtils().submittedGoals = "";
      PrefUtils().lastSavedDate = now.toIso8601String();
    }
  }

  saveLocalData(Goal goal, bool isChecked, String trackValue) {
    bool isFound = false;
    for (var goals in goalSubmitData) {
      if (goals.goalId == goal.sId && goal.goalMeasure != null) {
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
    List<String> nameParts = fullName.split(' ');
    return nameParts[0];
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return goodMorning;
    } else if (hour < 17) {
      return goodAfternoon;
    } else if (hour < 20) {
      return goodEvening;
    } else {
      return goodNight;
    }
  }

  updateImageFromAsset() async {
    SmartDialog.showLoading(msg: "Please wait..");
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUserImageFromAsset(
            PrefUtils().token, PrefUtils().userId, selectedAvatar.value)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            imageFilePath.value = "";
            xFile = null;
            this.user?.profilePicture = userResponse.user?.profilePicture;
            userProfileImageUrl.value = user?.profilePicture ?? "";
            PrefUtils().user = json.encode(user);
            Get.back();
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

  updateUserImage() async {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUserImage(PrefUtils().token, PrefUtils().userId, xFile!)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            selectedAvatar.value = "";
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

  deleteUserImage() async {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .deleteUserProfilePicture(
      PrefUtils().token,
    )
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            imageFilePath.value = "";
            xFile = null;
            selectedAvatar.value = "";
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

  getUserGoals({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingGoals.value = true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserGoalsList(PrefUtils().token).then((value) {
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

  @override
  void onDetached() {
    print("onDetached");
  }

  @override
  void onHidden() {
    print("onHidden");
  }

  @override
  void onInactive() {
    print("onInactive");
  }

  @override
  void onPaused() {
    print("onPause");
  }

  @override
  void onResumed() {
    _getUserData(isShowLoading: false);
    print("onResume");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("App Resumed");
        // instantSubmit();
        break;
      case AppLifecycleState.inactive:
        print("App InActive");
        break;
      case AppLifecycleState.paused:
        print("App Paused");
        break;
      case AppLifecycleState.detached:
        print("App Detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        print("Hidden");
        break;
    }
  }
}
