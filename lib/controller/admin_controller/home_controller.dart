import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal/goals_list_response_data.dart';
import 'package:life_berg/model/mood/mood_data.dart';

import '../../constant/color.dart';
import '../../model/error/error_response.dart';
import '../../model/goal/goal.dart';
import '../../model/user/user.dart';
import '../../model/user/user_response.dart';
import '../../utils/pref_utils.dart';
import '../../utils/toast_utils.dart';

class HomeController extends GetxController {
  final HttpManager httpManager = HttpManager();

  final TextEditingController moodCommentController = TextEditingController();

  User? user;
  RxString fullName = "".obs;
  RxString userProfileImageUrl = "".obs;

  XFile? xFile;
  RxString imageFilePath = "".obs;

  RxMoodData selectedMood = RxMoodData(emoji: "", value: -1);

  RxBool isLoadingGoals = true.obs;

  List<Goal> wellBeingGoals = [];
  List<Goal> vocationalGoals = [];
  List<Goal> personalDevGoals = [];

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
      user = User.fromJson(json.decode(PrefUtils().user));
      fullName.value = user?.fullName ?? "";
      userProfileImageUrl.value = user?.profilePicture ?? "";
      getUserGoals();
    }
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
    isLoadingGoals.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserGoalsList(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalsListResponse goalsListResponse = value.snapshot;
          if (goalsListResponse.success == true) {
            if (goalsListResponse.data != null) {
              if (goalsListResponse.data!.vocational != null) {
                vocationalGoals.addAll(goalsListResponse.data!.vocational!);
              }
              if (goalsListResponse.data!.personalDevelopment != null) {
                personalDevGoals
                    .addAll(goalsListResponse.data!.personalDevelopment!);
              }
              if (goalsListResponse.data!.wellBeing != null) {
                wellBeingGoals.addAll(goalsListResponse.data!.wellBeing!);
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

  deleteGoal(Goal goal,String type, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .deleteGoal(
      PrefUtils().token,
      goal.sId!,)
        .then((response) {
      if (response.error == null) {
        GenericResponse genericResponse = response.snapshot;
        if(genericResponse.success == true){
          switch(type){
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
}
