import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
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
}
