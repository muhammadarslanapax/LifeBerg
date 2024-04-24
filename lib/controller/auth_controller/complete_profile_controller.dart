import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/ice_berg.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/username_vocation.dart';
import 'package:life_berg/view/screens/auth/complete_profile/steps/welcome_on_board.dart';

class CompleteProfileController extends GetxController {
  static CompleteProfileController instance =
      Get.find<CompleteProfileController>();
  TextEditingController userNameCon = TextEditingController();
  RxString selectedVocation = 'Medical Student'.obs;
  TextEditingController iceBergCon = TextEditingController();
  RxBool isUserNameVocationDisable = true.obs;
  RxBool isIceBergDisable = true.obs;
  final pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxBool showOtherField = false.obs;
  final List<Widget> profileSteps = [
    UserNameVocation(),
    IceBerg(),
    WelcomeOnBoard(),
  ];

  final List<String> vocationList = [
    'Medical Student',
    'Junior Doctor',
    'Senior Doctor',
    'Other',
  ];

  void getVocation(String value) {
    selectedVocation.value = value;
    isUserNameVocationDisable.value = false;
    if (selectedVocation.value == 'Other') {
      showOtherField.value = true;
    } else {
      showOtherField.value = false;
    }
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
    if (isUserNameVocationDisable.value == false) {
      currentIndex.value++;
    } else {
      log('message');
    }
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
}
