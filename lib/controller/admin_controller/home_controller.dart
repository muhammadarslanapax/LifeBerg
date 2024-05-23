import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/user/user.dart';
import '../../utils/pref_utils.dart';

class HomeController extends GetxController {

  User? user;
  RxString fullName = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
      fullName.value = user?.fullName ?? "";
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

}