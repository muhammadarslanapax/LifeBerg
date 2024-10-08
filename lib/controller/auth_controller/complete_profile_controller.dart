import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/model/user/user.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/ice_berg.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/username_vocation.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/welcome_on_board.dart';

import '../../constant/color.dart';
import '../../model/error/error_response.dart';
import '../../model/user/user_response.dart';
import '../../utils/toast_utils.dart';

class CompleteProfileController extends GetxController {
  final HttpManager httpManager = HttpManager();

  // All text editing fields
  TextEditingController userNameCon = TextEditingController();
  TextEditingController countryCon = TextEditingController();
  TextEditingController iceBergCon = TextEditingController();

  final pageController = PageController();

  RxString userPreferredName = "".obs;
  RxString selectedVocation = 'Medical Student'.obs;
  RxBool isUserNameVocationDisable = true.obs;
  RxBool isIceBergDisable = true.obs;
  RxInt currentIndex = 0.obs;
  RxBool showOtherField = false.obs;

  final List<Widget> profileSteps = [
    UserNameVocation(),
    IceBerg(),
    WelcomeOnBoard(),
  ];
  User? user;

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

  @override
  void onReady() {
    super.onReady();
    _getUserData();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
      if (user?.userName != null) {
        userNameCon.text = user?.userName ?? "";
        userPreferredName.value = user?.userName ?? '';
      }
      if (user?.country != null) {
        countryCon.text = user?.country ?? "";
      }
      if (user?.primaryVocation != null) {
        selectedVocation.value = user?.primaryVocation ?? "";
      }
      if (user?.lifeBergName != null) {
        iceBergCon.text = user?.lifeBergName ?? "";
      }
      getIceBerg(iceBergCon.text);
      validateUsernameVocation();
    }
  }

  validateUsernameVocation() {
    userPreferredName.value = userNameCon.text;
    isUserNameVocationDisable.value = selectedVocation.value.isEmpty ||
        userNameCon.text.isEmpty ||
        countryCon.text.isEmpty;
  }

  void getVocation(String value) {
    selectedVocation.value = value;
    validateUsernameVocation();
  }

  void getIceBerg(String value) {
    iceBergCon.text = value;
    if (iceBergCon.text == '') {
      isIceBergDisable.value = true;
    } else {
      isIceBergDisable.value = false;
    }
  }

  void onNext() {
    currentIndex.value++;
  }

  void onBackTap() {
    if (currentIndex.value == 0) {
      Get.back();
    } else {
      currentIndex.value--;
    }
  }

  void getCurrentIndex(int index) {
    currentIndex.value = index;
  }

  updateUsername() {
    updateUser(
        country: countryCon.text.toString(),
        username: userNameCon.text.toString(),
        primaryVocation: selectedVocation.value);
  }

  updateIcebergName() {
    updateUser(iceberg: iceBergCon.text.toString());
  }

  updateUser(
      {String? country,
      String? iceberg,
      String? username,
      String? primaryVocation}) async {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUser(PrefUtils().token, PrefUtils().userId,
            country: country,
            iceberg: iceberg,
            primaryVocation: primaryVocation,
            username: username)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            if (iceberg != null) {
              PrefUtils().loggedIn = true;
            }
            PrefUtils().user = json.encode(userResponse.user);
            onNext();
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
}
