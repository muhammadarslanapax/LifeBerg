import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_report/details.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response_data.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response_data.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';

import '../../../../constant/color.dart';
import '../../../../model/error/error_response.dart';
import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../utils/toast_utils.dart';
import 'goals.dart';

class GoalExpandController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  RxList<GoalReportListResponseData> expandedGoalReport =
      <GoalReportListResponseData>[].obs;

  RxList<GoalChartDateModel> expandedGoalReportChart =
      <GoalChartDateModel>[].obs;

  GoalReportListResponse? goalReportListResponse;

  RxString tabType = "one_week".obs;
  User? user;
  RxString fullName = "".obs;
  RxString userName = "".obs;
  RxString userProfileImageUrl = "".obs;

  RxInt selectedGoalIndex = 0.obs;

  RxBool isLoadingData = true.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _getUserData({bool isShowLoading = true}) {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
      fullName.value = user?.fullName ?? "";
      userName.value = user?.userName ?? "";
      userProfileImageUrl.value = user?.profilePicture ?? "";
      getGoalReport(statisticsController.goalsList[0].sId!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  getGoalReport(String goalId, {String type = ""}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoadingData.value = true;
    httpManager.getGoalReport(PrefUtils().token, goalId).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalReportListResponse goalReportListResponse = value.snapshot;
          if (goalReportListResponse.success == true) {
            if (goalReportListResponse.data != null) {
              expandedGoalReport.clear();
              expandedGoalReport.addAll(goalReportListResponse.data!);
              processExpandSpecificGoalChart(goalReportListResponse);
            }
          } else {
            isLoadingData.value = false;
            SmartDialog.dismiss();
            ToastUtils.showToast(goalReportListResponse.message ?? "",
                color: kRedColor);
          }
        } else {
          isLoadingData.value = false;
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        isLoadingData.value = false;
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
      }
    });
  }

  List<GoalChartDateModel> processExpandSpecificGoalChart(
      GoalReportListResponse goalReportListResponse) {
    expandedGoalReportChart.clear();
    if (tabType.value == "one_week") {
      Map<String, List<int>> days = {
        'Mon': [],
        'Tue': [],
        'Wed': [],
        'Thu': [],
        'Fri': [],
        'Sat': [],
        'Sun': []
      };

      Map<String, List<String>> comments = {
        'Mon': [],
        'Tue': [],
        'Wed': [],
        'Thu': [],
        'Fri': [],
        'Sat': [],
        'Sun': []
      };

      DateTime now = DateTime.now();
      DateTime startOfWeek =
          now.subtract(Duration(days: now.weekday - 1)); // Monday of this week
      DateTime endOfWeek =
          startOfWeek.add(Duration(days: 6)); // Sunday of this week

      // Iterate over the response data
      for (var report in goalReportListResponse.data!) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the current week
        if (date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            date.isBefore(endOfWeek.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) *
                10; // Scale 0-10 to 0-100
          }

          String comment = report.details![0].comment ?? "";

          // Assign to the correct day of the week
          String dayOfWeek = DateFormat('EEE')
              .format(date); // Get day of the week in 'Mon', 'Tue', etc.
          if (days.containsKey(dayOfWeek)) {
            days[dayOfWeek]!.add(value);
            if (comment.isNotEmpty) {
              comments[dayOfWeek]!.add(comment);
            }
          }
        }
      }

      days.forEach((day, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[day]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(day, average, comment));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(day, 0, ''));
        }
      });
    } else if (tabType.value == "one_month") {
      DateTime now = DateTime.now();
      DateTime startOfMonth =
          now.subtract(Duration(days: 30)); // Start of 30 days ago
      DateTime endOfMonth = now; // End of the current date

      Map<String, List<int>> days = {};
      Map<String, List<String>> comments = {};

      // Generate day labels for the last 30 days
      for (int i = 0; i <= 30; i++) {
        DateTime day = now.subtract(Duration(days: i));
        String label = DateFormat('MMM dd').format(day);
        days[label] = [];
        comments[label] = [];
      }

      // Iterate over the response data
      for (var report in goalReportListResponse.data!) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the last 30 days
        if (date.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
            date.isBefore(endOfMonth.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) *
                10; // Scale 0-10 to 0-100
          }

          String comment = report.details![0].comment ?? "";

          // Assign to the correct day
          String dayLabel = DateFormat('MMM dd').format(date);
          if (days.containsKey(dayLabel)) {
            days[dayLabel]!.add(value);
            if (comment.isNotEmpty) {
              comments[dayLabel]!.add(comment);
            }
          }
        }
      }

      days.forEach((label, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[label]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(label, average, comment));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(label, 0, ''));
        }
      });
    } else if (tabType.value == "six_month") {
      DateTime now = DateTime.now();
      DateTime startOfSixMonths =
          DateTime(now.year, now.month - 5, 1); // Start of six months ago
      DateTime endOfSixMonths =
          DateTime(now.year, now.month + 1, 0); // End of the current month

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      // Generate month labels for the last six months
      for (int i = 0; i < 6; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      // Iterate over the response data
      for (var report in goalReportListResponse.data!) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the last six months
        if (date.isAfter(startOfSixMonths.subtract(Duration(days: 1))) &&
            date.isBefore(endOfSixMonths.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) *
                10; // Scale 0-10 to 0-100
          }

          String comment = report.details![0].comment ?? "";

          // Assign to the correct month
          String monthLabel = DateFormat('MMM').format(date);
          if (months.containsKey(monthLabel)) {
            months[monthLabel]!.add(value);
            if (comment.isNotEmpty) {
              comments[monthLabel]!.add(comment);
            }
          }
        }
      }

      months.forEach((label, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[label]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(label, average, comment));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(label, 0, ''));
        }
      });
    } else if (tabType.value == "three_month") {
      DateTime now = DateTime.now();
      DateTime startOfThreeMonths =
          DateTime(now.year, now.month - 2, 1); // Start of three months ago
      DateTime endOfThreeMonths =
          DateTime(now.year, now.month + 1, 0); // End of the current month

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      // Generate month labels for the last three months
      for (int i = 0; i < 3; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      // Iterate over the response data
      for (var report in goalReportListResponse.data!) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the last three months
        if (date.isAfter(startOfThreeMonths.subtract(Duration(days: 1))) &&
            date.isBefore(endOfThreeMonths.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) *
                10; // Scale 0-10 to 0-100
          }

          String comment = report.details![0].comment ?? "";

          // Assign to the correct month
          String monthLabel = DateFormat('MMM').format(date);
          if (months.containsKey(monthLabel)) {
            months[monthLabel]!.add(value);
            if (comment.isNotEmpty) {
              comments[monthLabel]!.add(comment);
            }
          }
        }
      }

      months.forEach((label, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[label]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(label, average, comment));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(label, 0, ''));
        }
      });
    } else {
      DateTime now = DateTime.now();
      DateTime startOfYear =
          DateTime(now.year, now.month - 11, 1); // Start of twelve months ago
      DateTime endOfYear =
          DateTime(now.year, now.month + 1, 0); // End of the current month

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      // Generate month labels for the last year
      for (int i = 0; i < 12; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      // Iterate over the response data
      for (var report in goalReportListResponse.data!) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the last year
        if (date.isAfter(startOfYear.subtract(Duration(days: 1))) &&
            date.isBefore(endOfYear.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) *
                10; // Scale 0-10 to 0-100
          }

          String comment = report.details![0].comment ?? "";

          // Assign to the correct month
          String monthLabel = DateFormat('MMM').format(date);
          if (months.containsKey(monthLabel)) {
            months[monthLabel]!.add(value);
            if (comment.isNotEmpty) {
              comments[monthLabel]!.add(comment);
            }
          }
        }
      }

      months.forEach((label, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[label]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(label, average, comment));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(label, 0, ''));
        }
      });
    }

    // if(tabType.value != "one_week") {
    expandedGoalReportChart.value = expandedGoalReportChart.reversed.toList();
    // }
    isLoadingData.value = false;
    return expandedGoalReportChart;
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    _getUserData(isShowLoading: false);
  }
}
