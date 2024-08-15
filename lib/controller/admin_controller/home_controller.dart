import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
  late TextEditingController goalCommentController;

  RxBool isLoadingGoals = true.obs;
  RxBool isShowHighlight = false.obs;

  Timer? _timer;

  User? user;
  RxString fullName = "".obs;
  RxString userName = "".obs;
  RxString userProfileImageUrl = "".obs;

  RxDouble wellbeingPercentage = 0.0.obs;
  RxDouble vocationPercentage = 0.0.obs;
  RxDouble personalDevPercentage = 0.0.obs;
  RxDouble globalPercentage = 0.0.obs;

  XFile? xFile;
  RxString imageFilePath = "".obs;

  RxMoodData selectedMood = RxMoodData(emoji: "", value: -1);
  RxMoodData savedSelectedMood = RxMoodData(emoji: "", value: -1);

  final List<RxMoodData> emojis = [
    RxMoodData(emoji: Assets.imagesVeryBad, value: 1),
    RxMoodData(emoji: Assets.imagesBad, value: 2),
    RxMoodData(emoji: Assets.imagesAverage, value: 3),
    RxMoodData(emoji: Assets.imagesVeryGood, value: 4),
    RxMoodData(emoji: Assets.imagesExcellent, value: 5),
  ];

  List<Goal> wellBeingGoals = <Goal>[].obs;
  List<Goal> vocationalGoals = <Goal>[].obs;
  List<Goal> personalDevGoals = <Goal>[].obs;

  RxBool isHighlightChecked = false.obs;

  List<GoalSubmitData> goalSubmitData = [];

  RxInt streakDays = 0.obs;

  RxBool isGoalSubmittedToday = false.obs;

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

  List<String> skippedGoalIds = [];

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    print("Home Init");
    moodCommentController = TextEditingController();
    goalCommentController = TextEditingController();
    setTodayMood();
    getUserData();
  }

  setTodayMood(){
    if (PrefUtils().savedMoodComment.isNotEmpty) {
      moodCommentController.text = PrefUtils().savedMoodComment;
    }
    if (PrefUtils().savedMood.isNotEmpty) {
      savedSelectedMood.value.value = emojis[int.parse(PrefUtils().savedMood) - 1].value.value;
      savedSelectedMood.emoji.value = emojis[int.parse(PrefUtils().savedMood) - 1].emoji.value;
      updateEmoji(emojis[int.parse(PrefUtils().savedMood) - 1].emoji.value,
          emojis[int.parse(PrefUtils().savedMood) - 1].value.value);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkAndResetGoals();
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("Home Dispose");
  }

  @override
  void onClose() {
    _timer?.cancel();
    print("Home Close");
    // moodCommentController.dispose();
    // goalCommentController.dispose();
    // learnedTodayController.dispose();
    // greatFulController.dispose();
    // tomorrowHighlightController.dispose();
    super.onClose();
  }

  updateEmoji(String emoji, int value) {
    selectedMood.emoji.value = emoji;
    selectedMood.value.value = value;
  }

  getUserData({bool isShowLoading = true}) {
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
      if (PrefUtils().getSkippedGoals.isNotEmpty) {
        skippedGoalIds =
            List<String>.from(jsonDecode(PrefUtils().getSkippedGoals));
      }
      getUserGoals(isShowLoading: isShowLoading);
      getUserDetail();
    }
  }

  bool isGoalSkipped(String goalId) {
    for (var skippedId in skippedGoalIds) {
      if (goalId == skippedId) {
        return true;
      }
    }
    return false;
  }

  String getIcebergComment() {
    if (globalPercentage.value == 100) {
      Random random = Random();
      int randomNumber = 1 + random.nextInt(2);
      if (randomNumber == 1) {
        return "Amazing! You have perfectly achieved all of your goals!";
      } else if (randomNumber == 2) {
        return "Wow! You have scored across all of your goals!";
      }
    } else if (wellbeingPercentage.value == 100) {
      return "Wonderful! You have achieved all of your wellbeing goals!";
    } else if (vocationPercentage.value == 100) {
      return "Wonderful! You have achieved all of your vocational goals!";
    } else if (personalDevPercentage.value == 100) {
      return "Wonderful! You have achieved all of your personal development goals!";
    } else if (globalPercentage.value >= 80 && globalPercentage.value <= 90) {
      return "Brilliant! Keep up the great work!";
    } else if (globalPercentage.value >= 60 && globalPercentage.value <= 79) {
      return "Fantastic! Keep up the great work!";
    } else if (globalPercentage.value >= 40 && globalPercentage.value <= 59) {
      return "Great work! Keep the momentum going!";
    } else if (globalPercentage.value >= 20 && globalPercentage.value <= 39) {
      return "You're on a roll! Keep it up!";
    } else if (globalPercentage.value >= 1 && globalPercentage.value <= 19) {
      return "Really nice work, you achieved more goals than yesterday!";
    } else if (globalPercentage.value == 0) {
      Random random = Random();
      int randomNumber = 1 + random.nextInt(2);
      if (randomNumber == 1) {
        return "Hello! It's great to see you checking in!";
      } else if (randomNumber == 2) {
        return "Remember to create a daily highlight for tomorrow!";
      }
    }
    return "";
  }

  String getIcebergJson() {
    if (globalPercentage.value >= 0 && globalPercentage.value <= 20) {
      return Assets.iceBergImageOne;
    } else if (globalPercentage.value > 20 && globalPercentage.value <= 40) {
      return Assets.iceBergImageTwo;
    } else if (globalPercentage.value > 40 && globalPercentage.value <= 60) {
      return Assets.iceBergImageThree;
    } else if (globalPercentage.value > 60 && globalPercentage.value <= 80) {
      return Assets.iceBergImageFour;
    } else {
      return Assets.iceBergImageFive;
    }
  }

  checkAndResetGoals() async {
    if (PrefUtils().isGoalSubmittedToday != isGoalSubmittedToday.value) {
      isGoalSubmittedToday.value = PrefUtils().isGoalSubmittedToday;
    }
    DateTime now = DateTime.now();
    DateTime? lastCheckedDate = PrefUtils().lastSavedDate.isNotEmpty
        ? DateTime.parse(PrefUtils().lastSavedDate)
        : null;
    if (lastCheckedDate == null ||
        DateUtility.isResetTimeReached(now, lastCheckedDate)) {
      isGoalSubmittedToday.value = false;
      PrefUtils().lastHighlightText = "";
      PrefUtils().lastLearntText = "";
      PrefUtils().lastGratefulText = "";
      PrefUtils().lastGratefulTextId = "";
      PrefUtils().lastLearntTextId = "";
      PrefUtils().isGoalSubmittedToday = false;
      PrefUtils().submittedGoals = "";
      PrefUtils().setSkippedGoals = "";
      PrefUtils().savedMood = "";
      PrefUtils().savedMoodComment = "";
      PrefUtils().lastSavedDate = now.toIso8601String();
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
  }

  void calculatePercentage() {
    double wellbeingCompletion = 0;
    int wellbeingGoalsCount = 0;

    double vocationCompletion = 0;
    int vocationGoalsCount = 0;

    double personalDevCompletion = 0;
    int personalDevGoalsCount = 0;

    List<Goal> goals = [];
    goals.addAll(wellBeingGoals);
    goals.addAll(vocationalGoals);
    goals.addAll(personalDevGoals);

    double totalCompletion = 0;
    int nonSkippedGoalsCount = 0;

    goals.forEach((goal) {
      if (!goal.isSkipped.value) {
        double completion = 0;

        if (goal.goalMeasure!.type == "boolean") {
          completion = goal.isChecked.value ? 1 : 0;
        } else if (goal.goalMeasure!.type == "string") {
          completion = goal.sliderValue.value / 10.0;
        }

        totalCompletion += completion;
        nonSkippedGoalsCount++;

        switch (goal.category?.name) {
          case "Wellbeing":
            wellbeingCompletion += completion;
            wellbeingGoalsCount++;
            break;
          case "Vocational":
            vocationCompletion += completion;
            vocationGoalsCount++;
            break;
          case "Personal Development":
            personalDevCompletion += completion;
            personalDevGoalsCount++;
            break;
        }
      }
    });

    double wellbeingPer = wellbeingGoalsCount > 0
        ? (wellbeingCompletion / wellbeingGoalsCount) * 100
        : 0;
    double vocationPer = vocationGoalsCount > 0
        ? (vocationCompletion / vocationGoalsCount) * 100
        : 0;
    double personalDevPer = personalDevGoalsCount > 0
        ? (personalDevCompletion / personalDevGoalsCount) * 100
        : 0;

    wellbeingPercentage.value = wellbeingPer;
    vocationPercentage.value = vocationPer;
    personalDevPercentage.value = personalDevPer;

    // Calculate the global score based on all non-skipped goals
    double globalPer = nonSkippedGoalsCount > 0
        ? (totalCompletion / nonSkippedGoalsCount) * 100
        : 0;

    globalPercentage.value = globalPer;
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
        goal.sId!,
        goal.goalMeasure!.type!,
        isChecked,
        trackValue,
        "",
      );
      goalSubmitData.add(goalData);
    }
    String jsonString =
        jsonEncode(goalSubmitData.map((goal) => goal.toJson()).toList());
    PrefUtils().submittedGoals = jsonString;
  }

  saveLocalGoalComment(
    Goal goal,
  ) {
    bool isFound = false;
    goal.comment = goalCommentController.text.toString();
    for (var goals in goalSubmitData) {
      if (goals.goalId == goal.sId) {
        goals.comment = goalCommentController.text.toString();
        isFound = true;
      }
    }
    if (!isFound) {
      GoalSubmitData goalData = GoalSubmitData(
        goal.sId!,
        goal.goalMeasure!.type!,
        false,
        "0.0",
        goalCommentController.text.toString(),
      );
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

  String getGoalComment(Goal goal) {
    for (var goalData in goalSubmitData) {
      if (goalData.goalId == goal.sId!) {
        return goalData.comment;
      }
    }
    return "";
  }

  String checkGoalTrackValue(Goal goal) {
    for (var goalData in goalSubmitData) {
      if (goalData.goalId == goal.sId!) {
        return goalData.measureValue;
      }
    }
    return "0.0";
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
    SmartDialog.showLoading(msg: pleaseWait);
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

  updateUserImage(Function(bool isSuccess) imageUploadedCallback) async {
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
            imageUploadedCallback(true);
            selectedAvatar.value = "";
            this.user?.profilePicture = userResponse.user?.profilePicture;
            userProfileImageUrl.value = user?.profilePicture ?? "";
            PrefUtils().user = json.encode(user);
          } else {
            imageUploadedCallback(false);
            ToastUtils.showToast(userResponse.message ?? "", color: kRedColor);
          }
        } else {
          imageUploadedCallback(false);
          ToastUtils.showToast(
              "Some error occurred. please upload image again.",
              color: kRedColor);
        }
      } else {
        imageUploadedCallback(false);
        ToastUtils.showToast("Some error occurred. please upload image again.",
            color: kRedColor);
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
            setTodayMood();
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
    httpManager.getUserGoalsList(PrefUtils().token, "active").then((value) {
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
                  goal.isSkipped.value = isGoalSkipped(goal.sId!);
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  goal.comment = getGoalComment(goal);
                  vocationalGoals.add(goal);
                }
                calculatePercentage();
              }
              if (goalsListResponse.data!.personalDevelopment != null) {
                for (var goal in goalsListResponse.data!.personalDevelopment!) {
                  goal.isSkipped.value = isGoalSkipped(goal.sId!);
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  goal.comment = getGoalComment(goal);
                  personalDevGoals.add(goal);
                }

                calculatePercentage();
              }
              if (goalsListResponse.data!.wellBeing != null) {
                for (var goal in goalsListResponse.data!.wellBeing!) {
                  goal.isSkipped.value = isGoalSkipped(goal.sId!);
                  goal.isChecked.value = checkIsGoalChecked(goal);
                  goal.sliderValue.value =
                      double.parse(checkGoalTrackValue(goal));
                  goal.comment = getGoalComment(goal);
                  wellBeingGoals.add(goal);
                }
                calculatePercentage();
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

  getUserDetail() {
    httpManager
        .getCurrentUserDetail(
      PrefUtils().token,
    )
        .then((response) {
      if (response.error == null) {
        UserResponse userResponse = response.snapshot;
        if (userResponse.success == true) {
          PrefUtils().user = json.encode(userResponse.user);
          streakDays.value = userResponse.user!.currentStreak ?? 0;
        }
      } else {
        ToastUtils.showToast(someError, color: kRedColor);
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
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    getUserData(isShowLoading: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
