import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPassController extends GetxController {
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
}
