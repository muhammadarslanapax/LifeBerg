import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_mood_report/check_reports.dart';
import 'package:life_berg/model/goal_report/details.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response_data.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response_data.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';

import '../../../../constant/color.dart';
import '../../../../constant/strings.dart';
import '../../../../generated/assets.dart';
import '../../../../model/error/error_response.dart';
import '../../../../model/generic_response.dart';
import '../../../../model/goal/goal.dart';
import '../../../../model/goal/goal_submit/goal_submit_data.dart';
import '../../../../model/goal_mood_report/goal_date_response.dart';
import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../utils/toast_utils.dart';
import '../../../widget/my_dialog.dart';
import 'goals.dart';

class GoalExpandController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController commentController = TextEditingController();

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
              expandedGoalReport.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
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
      Map<String, List<int>> dayValues = {};
      Map<String, List<String>> dayComments = {};
      Map<String, List<String>> goalIds = {};

      DateTime now = DateTime.now();
      DateTime startOfLastWeek = now.subtract(Duration(days: 7));

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        dayValues[formattedDate] = [];
        dayComments[formattedDate] = [];
        goalIds[formattedDate] = [];
      }

      for (var report in goalReportListResponse.data!) {
        if (report.details != null && report.details!.isNotEmpty) {
          DateTime date = DateTime.parse(report.date!);
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);

          if (dayValues.containsKey(formattedDate)) {
            int value = 0;

            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            dayValues[formattedDate]!.add(value);
            goalIds[formattedDate]!.add(report.details![0].goal!.sId!);
            if (comment.isNotEmpty) {
              dayComments[formattedDate]!.add(comment);
            }
          }
        }
      }

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        double average = dayValues[formattedDate]!.isNotEmpty
            ? dayValues[formattedDate]!.reduce((a, b) => a + b) /
                dayValues[formattedDate]!.length
            : 0;
        String comments = dayComments[formattedDate]!.join(', ');
        String goalId = goalIds[formattedDate]!.join(', ');

        expandedGoalReportChart.add(GoalChartDateModel(
            formattedDate, average, comments,
            goalId: goalId));
      }
    } else if (tabType.value == "one_month") {
      DateTime now = DateTime.now();
      DateTime startOfMonth = now.subtract(Duration(days: 30));
      DateTime endOfMonth = now;

      Map<String, List<int>> days = {};
      Map<String, List<String>> comments = {};
      Map<String, List<String>> goalIds = {};

      for (int i = 0; i <= 30; i++) {
        DateTime day = now.subtract(Duration(days: i));
        String label = DateFormat('yyyy-MM-dd').format(day);
        days[label] = [];
        goalIds[label] = [];
        comments[label] = [];
      }

      for (var report in goalReportListResponse.data!) {
        if (report.details != null && report.details!.isNotEmpty) {
          if (report.details != null && report.details!.isNotEmpty) {
            DateTime date = DateTime.parse(report.date!);

            if (date.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
                date.isBefore(endOfMonth.add(Duration(days: 1)))) {
              int value = 0;

              if (report.details![0].type == 'boolean') {
                value = report.details![0].value == 'true' ? 100 : 0;
              } else if (report.details![0].type == 'string') {
                value = int.parse(report.details![0].value!) * 10;
              }

              String comment = report.details![0].comment ?? "";

              String dayLabel = DateFormat('yyyy-MM-dd').format(date);
              if (days.containsKey(dayLabel)) {
                days[dayLabel]!.add(value);
                goalIds[dayLabel]!.add(report.details![0].goal!.sId!);
                if (comment.isNotEmpty) {
                  comments[dayLabel]!.add(comment);
                }
              }
            }
          }
        }
      }

      days.forEach((label, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[label]!.join(', ');
          String goalId = goalIds[label]!.join(', ');
          expandedGoalReportChart
              .add(GoalChartDateModel(label, average, comment,
          goalId: goalId));
        } else {
          expandedGoalReportChart.add(GoalChartDateModel(label, 0, ''));
        }
      });
    } else if (tabType.value == "six_month") {
      DateTime now = DateTime.now();
      DateTime startOfSixMonths = DateTime(now.year, now.month - 5, 1);
      DateTime endOfSixMonths = DateTime(now.year, now.month + 1, 0);

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      for (int i = 0; i < 6; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      for (var report in goalReportListResponse.data!) {
        if (report.details != null && report.details!.isNotEmpty) {
          DateTime date = DateTime.parse(report.date!);

          if (date.isAfter(startOfSixMonths.subtract(Duration(days: 1))) &&
              date.isBefore(endOfSixMonths.add(Duration(days: 1)))) {
            int value = 0;

            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            String monthLabel = DateFormat('MMM').format(date);
            if (months.containsKey(monthLabel)) {
              months[monthLabel]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthLabel]!.add(comment);
              }
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
      DateTime startOfThreeMonths = DateTime(now.year, now.month - 2, 1);
      DateTime endOfThreeMonths = DateTime(now.year, now.month + 1, 0);

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      for (int i = 0; i < 3; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      for (var report in goalReportListResponse.data!) {
        if (report.details != null && report.details!.isNotEmpty) {
          DateTime date = DateTime.parse(report.date!);

          if (date.isAfter(startOfThreeMonths.subtract(Duration(days: 1))) &&
              date.isBefore(endOfThreeMonths.add(Duration(days: 1)))) {
            int value = 0;

            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            String monthLabel = DateFormat('MMM').format(date);
            if (months.containsKey(monthLabel)) {
              months[monthLabel]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthLabel]!.add(comment);
              }
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
      DateTime startOfYear = DateTime(now.year, now.month - 11, 1);
      DateTime endOfYear = DateTime(now.year, now.month + 1, 0);

      Map<String, List<int>> months = {};
      Map<String, List<String>> comments = {};

      for (int i = 0; i < 12; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        String label = DateFormat('MMM').format(monthStart);
        months[label] = [];
        comments[label] = [];
      }

      for (var report in goalReportListResponse.data!) {
        if (report.details != null && report.details!.isNotEmpty) {
          DateTime date = DateTime.parse(report.date!);

          if (date.isAfter(startOfYear.subtract(Duration(days: 1))) &&
              date.isBefore(endOfYear.add(Duration(days: 1)))) {
            int value = 0;

            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            String monthLabel = DateFormat('MMM').format(date);
            if (months.containsKey(monthLabel)) {
              months[monthLabel]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthLabel]!.add(comment);
              }
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

    if (tabType.value != "one_week") {
      expandedGoalReportChart.value = expandedGoalReportChart.reversed.toList();
    }
    isLoadingData.value = false;
    return expandedGoalReportChart;
  }

  getGoalReportByDate(String date, GoalReportListResponseData data,
      {bool isForDelete = false}) async {
    SmartDialog.showLoading();
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getGoalReportByDate(PrefUtils().token, date).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalDateResponse goalDateResponse = value.snapshot;
          if (goalDateResponse.success == true) {
            if (goalDateResponse.data != null) {
              if (goalDateResponse.data!.checkReports != null) {
                for (var report
                    in goalDateResponse.data!.checkReports!.details!) {
                  if (report.goal!.sId == data.details![0].goal!.sId) {
                    report.comment = data.details![0].comment;
                  }
                }
                updateComment((isSuccess) => null,
                    goalDateResponse.data!.checkReports!, data, date,
                    isForDelete: isForDelete);
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(goalDateResponse.message ?? "",
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
    });
  }

  updateComment(Function(bool isSuccess) onReportSubmit, CheckReports reports,
      GoalReportListResponseData data, String date,
      {bool isForDelete = false}) {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateCommentGoalReport(PrefUtils().token, "", reports, date: date)
        .then((response) {
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            SmartDialog.dismiss();
            onReportSubmit(true);
            List<GoalSubmitData> goalSubmitData = [];
            if (PrefUtils().submittedGoals.isNotEmpty) {
              List<dynamic> jsonList = jsonDecode(PrefUtils().submittedGoals);
              List<GoalSubmitData> goalSubmitDataList = jsonList
                  .map((jsonItem) => GoalSubmitData.fromJson(jsonItem))
                  .toList();
              goalSubmitData.addAll(goalSubmitDataList);
            }
            for (var goals in goalSubmitData) {
              if (goals.goalId == data.details![0].goal!.sId &&
                  DateFormat("yyyy-MM-dd")
                          .format(DateTime.parse(PrefUtils().lastSavedDate)) ==
                      date) {
                goals.comment = commentController.text;
              }
            }
            String jsonString = jsonEncode(
                goalSubmitData.map((goal) => goal.toJson()).toList());
            PrefUtils().submittedGoals = jsonString;
            homeController.getUserData();
            getGoalReport(
                statisticsController.goalsList[selectedGoalIndex.value].sId!);
            if (!isForDelete) {
              Get.dialog(
                MyDialog(
                  icon: Assets.imagesComment,
                  heading: commentAdded,
                  content: commentAddedDes,
                  onOkay: () {
                    Get.back();
                  },
                ),
              );
            }
          } else {
            SmartDialog.dismiss();
            onReportSubmit(false);
          }
        }
      } else {
        SmartDialog.dismiss();
        onReportSubmit(false);
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  addCommentOnGoal(String goalId, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading();
    httpManager
        .addCommentOnGoal(PrefUtils().token, goalId, "")
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          expandedGoalReport[index].details![0].comment = "";
          expandedGoalReportChart.refresh();
        }
      } else {
        ToastUtils.showToast("Some error occurred.", color: kRedColor);
      }
    });
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
