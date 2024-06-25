import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/user/user_response.dart';
import 'package:life_berg/utils/toast_utils.dart';

import '../../constant/color.dart';
import '../../firebase/fire_auth.dart';
import '../../model/error/error_response.dart';
import '../../model/user/apple_user_credential.dart';
import '../../utils/pref_utils.dart';
import '../../view/screens/auth/complete_profile/complete_profile.dart';
import '../../view/screens/bottom_nav_bar/bottom_nav_bar.dart';

class SignupController extends GetxController {
  final HttpManager httpManager = HttpManager();

  // All Text Editing controller fields.
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController repeatPassCon = TextEditingController();

  // Start validation related code
  RxBool isDisable = true.obs;

  void getEmail(String value) {
    emailCon.text = value;
    isValid();
  }

  bool isValid() {
    if (emailCon.text == '') {
      isDisable.value = true;
      return false;
    } else {
      isDisable.value = false;
      return true;
    }
  }
  // End validation related code

  // Start all API Calls code
  signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: "Please wait..");
    String? token = await FirebaseMessaging.instance.getToken();
    httpManager
        .signUp(nameCon.text.toString(), emailCon.text.toString(),
            passCon.text.toString(), token ?? "")
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          UserResponse userResponse = value.snapshot;
          if (userResponse.success == true) {
            PrefUtils().user = json.encode(userResponse.user);
            PrefUtils().token = userResponse.token ?? '';
            PrefUtils().userId = userResponse.token ?? '';

            Get.to(() => CompleteProfile());
          } else {
            ToastUtils.showToast(
                userResponse.message ?? "",
                color: kRedColor);
          }
        }else{
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      }else{
        ToastUtils.showToast(
            value.error ?? "",
            color: kRedColor);
      }
    });
  }

  signInWithApple() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FireAuth.signInWithApple().then((response) async {
      if (response != null) {
        SmartDialog.showLoading(msg: "Please wait...");
        AppleUserCredential appleUserCredential = response;
        String displayName = appleUserCredential.fullName ?? "";
        String firstName = "";
        String lastName = "";
        if (displayName.isEmpty) {
          if (appleUserCredential.userCredential.user?.providerData != null &&
              appleUserCredential
                  .userCredential.user!.providerData.isNotEmpty) {
            var userInfo =
            appleUserCredential.userCredential.user!.providerData[0];
            displayName = userInfo.displayName ?? "";
          }
        }
        httpManager
            .socialLogin(appleUserCredential.userCredential.user?.email ?? "",
            "apple", displayName)
            .then((response) {
          SmartDialog.dismiss();
          if (response.error == null) {
            if (response.snapshot! is! ErrorResponse) {
              UserResponse userResponse = response.snapshot;
              if (userResponse.success == true) {
                _moveToNextScreen(userResponse);
              } else {
                ToastUtils.showToast(userResponse.message ?? "",
                    color: kRedColor);
              }
            } else {
              ErrorResponse errorResponse = response.snapshot;
              ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
                  color: kRedColor);
            }
          } else {
            ToastUtils.showToast("Some error occurred.",
                color: kRedColor);
          }
        });
      }
    });
  }

  signInWithGoogle() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FireAuth.signInWithGoogle().then((response) async {
      if (response != null) {
        SmartDialog.showLoading(msg: "Please wait...");
        UserCredential userCredential = response;
        String displayName = userCredential.user?.displayName ?? "";
        if (displayName.isEmpty) {
          if (userCredential.user?.providerData != null &&
              userCredential.user!.providerData.isNotEmpty) {
            var userInfo = userCredential.user!.providerData[0];
            displayName = userInfo.displayName ?? "";
          }
        }
        httpManager
            .socialLogin(
            userCredential.user?.email ?? "", "google", displayName)
            .then((response) {
          SmartDialog.dismiss();
          if (response.error == null) {
            if (response.snapshot! is! ErrorResponse) {
              UserResponse userResponse = response.snapshot;
              if (userResponse.success == true) {
                _moveToNextScreen(userResponse);
              } else {
                ToastUtils.showToast(userResponse.message ?? "",
                    color: kRedColor);
              }
            } else {
              ErrorResponse errorResponse = response.snapshot;
              ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
                  color: kRedColor);
            }
          } else {
            ToastUtils.showToast("Some error occurred.",
                color: kRedColor);
          }
        });
      }
    });
  }

  signInWithFacebook(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    FireAuth.signInWithFacebook(context).then((response) async {
      if (response != null) {
        SmartDialog.showLoading(msg: "Please wait...");
        UserCredential userCredential = response;
        String displayName = userCredential.user?.displayName ?? "";
        if (displayName.isEmpty) {
          if (userCredential.user?.providerData != null &&
              userCredential.user!.providerData.isNotEmpty) {
            var userInfo = userCredential.user!.providerData[0];
            displayName = userInfo.displayName ?? "";
          }
        }
        httpManager
            .socialLogin(
            userCredential.user?.email ?? "", "facebook", displayName)
            .then((response) {
          SmartDialog.dismiss();
          if (response.error == null) {
            if (response.snapshot! is! ErrorResponse) {
              UserResponse userResponse = response.snapshot;
              if (userResponse.success == true) {
                _moveToNextScreen(userResponse);
              } else {
                ToastUtils.showToast(userResponse.message ?? "",
                    color: kRedColor);
              }
            } else {
              ErrorResponse errorResponse = response.snapshot;
              ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
                  color: kRedColor);
            }
          } else {
            ToastUtils.showToast("Some error occurred.", color: kRedColor);
          }
        });
      }
    });
  }
  // End all API calls code

  _moveToNextScreen(UserResponse userResponse){
    PrefUtils().user = json.encode(userResponse.user);
    PrefUtils().token = userResponse.token ?? '';
    PrefUtils().userId = userResponse.token ?? '';
    if(userResponse.user?.userName == null ||
        userResponse.user?.lifeBergName == null) {
      Get.to(() => CompleteProfile());
    }else{
      Get.offAll(() => BottomNavBar());
      PrefUtils().loggedIn = true;
    }
  }

}
