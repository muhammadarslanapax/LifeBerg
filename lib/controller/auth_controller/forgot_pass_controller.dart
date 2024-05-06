import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/utils/toast_utils.dart';
import 'package:life_berg/view/screens/auth/login.dart';

import '../../model/error/error_response.dart';
import '../../view/screens/auth/forgot_pass/new_pass.dart';
import '../../view/screens/auth/forgot_pass/pass_changed_success.dart';
import '../../view/screens/auth/forgot_pass/verification_code.dart';

class ForgotPassController extends GetxController {
  final HttpManager httpManager = HttpManager();

  TextEditingController emailCon = TextEditingController();
  TextEditingController otpCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController confirmCon = TextEditingController();
  RxBool isDisable = true.obs;
  RxBool isVerifyDisable = true.obs;
  RxBool isNewPassDisable = true.obs;

  void getEmail(String value) {
    emailCon.text = value;
    if (emailCon.text == '') {
      isDisable.value = true;
    } else {
      isDisable.value = false;
    }
  }

  void getOTP(String value) {
    otpCon.text = value;
    if (otpCon.text.length != 4) {
      isVerifyDisable.value = true;
    } else {
      isVerifyDisable.value = false;
    }
  }

  void getConfirmPass(String value) {
    confirmCon.text = value;
    if (confirmCon.text != passCon.text) {
      isNewPassDisable.value = true;
    } else {
      isNewPassDisable.value = false;
    }
  }

  sendVerificationCode() {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: "Please wait...");
    httpManager
        .forgotPasswordStepOne(emailCon.text.toString())
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        bool isSent = response.snapshot;
        if (isSent) {
          Get.to(() => VerificationCode());
        } else {
          ToastUtils.showToast("No user found against this email address.",
              color: kRedColor);
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  verifyEmailCode() {
    FocusManager.instance.primaryFocus?.unfocus();
    String code = otpCon.text.toString();
    SmartDialog.showLoading(msg: "Please wait...");
    httpManager
        .forgotPasswordStepTwo(
      emailCon.text.toString(),
      code,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        bool isSent = response.snapshot;
        if (isSent) {
          Get.to(() => NewPass());
        } else {
          ToastUtils.showToast("Invalid code entered.", color: kRedColor);
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
  }

  resetPassword() async {
    SmartDialog.showLoading(msg: "Please wait...");
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .forgotPasswordStepThree(
      emailCon.text.toString(),
      otpCon.text.toString(),
      passCon.text.toString(),
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          Get.offAll(() => PassChangedSuccess());
        } else {
          ErrorResponse errorResponse = response.snapshot;
          switch (errorResponse.error!.details!.code) {
            case "INVALID_PASSWORD":
              ToastUtils.showToast("You entered wrong password",color: kRedColor);
                  break;
            default:
              ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
                  color: kRedColor);
              break;
          }
        }
      } else {
        ToastUtils.showToast("Some error occurred.",
            color: kRedColor);
      }
    });
  }
}
