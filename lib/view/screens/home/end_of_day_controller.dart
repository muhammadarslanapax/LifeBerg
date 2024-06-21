import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/mood/mood_data.dart';
import 'package:life_berg/utils/date_utility.dart';

import '../../../model/user/user.dart';
import '../../../utils/pref_utils.dart';

class EndOfDayController extends GetxController {
  final HttpManager httpManager = HttpManager();

  final TextEditingController greatFulController = TextEditingController();
  final TextEditingController learnedTodayController = TextEditingController();
  final TextEditingController tomorrowHighlightController =
      TextEditingController();

  User? user;

  @override
  void onInit() {
    super.onInit();
    greatFulController.text = '\u2022 ';
    greatFulController.selection = TextSelection.fromPosition(
      TextPosition(offset: greatFulController.text.length),
    );
    learnedTodayController.text = '\u2022 ';
    learnedTodayController.selection = TextSelection.fromPosition(
      TextPosition(offset: learnedTodayController.text.length),
    );
    _getUserData();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
    }
  }

  @override
  void onClose() {
    // moodCommentController.dispose();
    // goalCommentController.dispose();
    // learnedTodayController.dispose();
    // greatFulController.dispose();
    // tomorrowHighlightController.dispose();
    setInitialBulletPoint();
    super.onClose();
  }

  setInitialBulletPoint() {
    greatFulController.text = '\u2022 ';
    greatFulController.selection = TextSelection.fromPosition(
      TextPosition(offset: greatFulController.text.length),
    );
    learnedTodayController.text = '\u2022 ';
    learnedTodayController.selection = TextSelection.fromPosition(
      TextPosition(offset: learnedTodayController.text.length),
    );
  }
}
