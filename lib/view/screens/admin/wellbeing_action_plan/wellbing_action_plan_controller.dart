import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/model/action_plan/action_plan.dart';
import 'package:life_berg/model/action_plan/action_plan_list_response.dart';
import 'package:life_berg/model/journal/journal_list_response.dart';
import 'package:life_berg/model/journal/journal_list_response_data.dart';

import '../../../../constant/color.dart';
import '../../../../model/error/error_response.dart';
import '../../../../model/generic_response.dart';
import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../utils/toast_utils.dart';

class WellbeingActionPlanController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HttpManager httpManager = HttpManager();

  final TextEditingController addTextController = TextEditingController();

  List<ActionPlan> allActionsList = <ActionPlan>[].obs;
  List<ActionPlan> actionsList = <ActionPlan>[].obs;
  List<ActionPlan> features = <ActionPlan>[].obs;
  List<ActionPlan> contacts = <ActionPlan>[].obs;

  RxBool isLoadingActionPlan = true.obs;
  User? user;
  RxString userName = "".obs;
  RxString iceBergName = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
    getUserActionPlans();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
      userName.value = user?.userName ?? "";
      iceBergName.value = user?.lifeBergName ?? "";
    }
  }

  getUserActionPlans() async {
    actionsList.clear();
    features.clear();
    contacts.clear();
    allActionsList.clear();
    isLoadingActionPlan.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserActionPlan(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          ActionPlanListResponse actionPlanListResponse = value.snapshot;
          if (actionPlanListResponse.success == true) {
            if (actionPlanListResponse.data != null) {
              allActionsList.addAll(actionPlanListResponse.data!);
              for (var data in actionPlanListResponse.data!) {
                if (data.category == "66910d86e9c4adad06f7bceb") {
                  actionsList.add(data);
                } else if (data.category == "66911b70c2c80d894db4a270") {
                  features.add(data);
                } else {
                  contacts.add(data);
                }
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(actionPlanListResponse.message ?? "",
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
      isLoadingActionPlan.value = false;
    });
  }

  addNewActionPlan(Function(bool isSuccess) onActionPlanCreate, String title,
      String category) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: pleaseWait);
    httpManager
        .addNewActionPlan(
      PrefUtils().token,
      title,
      category,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            onActionPlanCreate(true);
            addTextController.text = "";
          } else {
            onActionPlanCreate(false);
          }
        }
      } else {
        onActionPlanCreate(false);
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  deleteActionPlan(String actionPlanId, int index, String type) {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .deleteActionPlan(
      PrefUtils().token,
      actionPlanId,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        GenericResponse genericResponse = response.snapshot;
        if (genericResponse.success == true) {
          if (type == "actions") {
            actionsList.removeAt(index);
          } else if (type == "features") {
            features.removeAt(index);
          } else {
            contacts.removeAt(index);
          }
        }
      } else {
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  updateActionPlan(Function(bool isSuccess) onActionPlanUpdate,
      String actionPlanId, String category) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: pleaseWait);
    httpManager
        .updateActionPlan(
      PrefUtils().token,
      actionPlanId,
      addTextController.text.toString(),
      category,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            onActionPlanUpdate(true);
            addTextController.text = "";
            getUserActionPlans();
          } else {
            onActionPlanUpdate(false);
          }
        }
      } else {
        onActionPlanUpdate(false);
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }
}
