import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/expand_goal_selection/expand_selected_goal.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_report/details.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response_data.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response_data.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';

import '../../../../constant/color.dart';
import '../../../../generated/assets.dart';
import '../../../../model/error/error_response.dart';
import '../../../../model/generic_response.dart';
import '../../../../model/goal/goal.dart';
import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../utils/toast_utils.dart';
import '../../../widget/my_text.dart';
import '../goals/goals.dart';
import 'comparison.dart';
import 'comparison_expand.dart';

class ComparisonGoalExpandController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  RxList<GoalReportListResponseData> expandedGoalReport =
      <GoalReportListResponseData>[].obs;

  RxList<GoalReportListResponse> goalReportList =
      <GoalReportListResponse>[].obs;

  RxList<List<ExpandComparisonChartDataModel>> comparisonGoalsChartData =
      <List<ExpandComparisonChartDataModel>>[].obs;

  RxString tabType = "one_week".obs;
  User? user;
  RxString fullName = "".obs;
  RxString userName = "".obs;
  RxString userProfileImageUrl = "".obs;

  RxBool isLoadingData = true.obs;

  RxList<ExpandSelectedGoal> selectedGoalsList = <ExpandSelectedGoal>[].obs;

  final List<Color> colors = [
    kC10,
    kC11,
    kC12,
    kC13,
    kQuiteTimeColor,
    kDarkBlueColor,
    kC16
  ];

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
      selectedGoalsList.add(ExpandSelectedGoal(
          getDropdown(statisticsController.goalsList[0], 0),
          statisticsController.goalsList[0].obs));
      if (statisticsController.goalsList.length > 1) {
        selectedGoalsList.add(ExpandSelectedGoal(
            getDropdown(statisticsController.goalsList[1], 1),
            statisticsController.goalsList[1].obs));
      } else {
        selectedGoalsList.add(ExpandSelectedGoal(
            getDropdown(statisticsController.goalsList[0], 1),
            statisticsController.goalsList[0].obs));
      }
      getComparisonGoalReport();
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

  getDropdown(Goal goal, int parentIndex) {
    return CustomDropdown<Goal>(
      items: statisticsController.goalsList,
      hintText: "Select Goal",
      maxlines: 1,
      closedHeaderPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: CustomDropdownDecoration(
        closedFillColor: kSecondaryColor,
        expandedFillColor: kSecondaryColor,
        closedBorder: Border.all(
          color: kBorderColor,
          width: 1.0,
        ),
        closedBorderRadius: BorderRadius.all(Radius.circular(8)),
        expandedBorderRadius: BorderRadius.all(Radius.circular(8)),
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          size: 24,
          color: Colors.grey,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up,
          size: 24,
          color: Colors.grey,
        ),
      ),
      initialItem: goal,
      hideSelectedFieldWhenExpanded: true,
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: item.category?.name == "Wellbeing"
                    ? kStreaksColor.withOpacity(0.2)
                    : item.category?.name == "Vocational"
                        ? kRACGPExamColor.withOpacity(0.2)
                        : kDailyGratitudeColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: item.category?.name == "Wellbeing"
                        ? kStreaksColor
                        : item.category?.name == "Vocational"
                            ? kRACGPExamColor
                            : kDailyGratitudeColor,
                    shape: BoxShape.circle,
                  ),
                  height: Get.height,
                  width: Get.width,
                ),
              ),
            ),
            MyText(
              paddingLeft: 11,
              text: item.name ?? "",
              size: 14,
              color: kCoolGreyColor,
              weight: FontWeight.w400,
            ),
          ],
        );
      },
      onChanged: (g) {
        selectedGoalsList[parentIndex].goal.value = g as Goal;
        getComparisonGoalReport();
      },
      headerBuilder: (
        context,
        item,
        isSelected,
      ) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: colors[parentIndex].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors[parentIndex],
                    shape: BoxShape.circle,
                  ),
                  height: Get.height,
                  width: Get.width,
                ),
              ),
            ),
            MyText(
              paddingLeft: 11,
              text: item.name ?? "",
              size: 14,
              color: kCoolGreyColor,
              weight: FontWeight.w400,
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: (){
                selectedGoalsList.removeAt(parentIndex);
                getComparisonGoalReport();
              },
              child: Image.asset(
                Assets.imagesDeleteThisItem,
                color: Colors.grey.withOpacity(0.8),
                height: 20,
              ),
            )
          ],
        );
      },
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: goal,
        hint: MyText(
          text: 'Select Goal',
          size: 14,
          color: kTextColor.withOpacity(0.50),
        ),
        items: List.generate(
          statisticsController.goalsList.length,
          (index) {
            var data = statisticsController.goalsList[index];
            return DropdownMenuItem<Goal>(
              value: data,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colors[parentIndex].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[parentIndex],
                          shape: BoxShape.circle,
                        ),
                        height: Get.height,
                        width: Get.width,
                      ),
                    ),
                  ),
                  MyText(
                    paddingLeft: 11,
                    text: data.name ?? "",
                    size: 14,
                    color: kCoolGreyColor,
                    weight: FontWeight.w400,
                  ),
                ],
              ),
            );
          },
        ),
        onChanged: (v) {
          selectedGoalsList[parentIndex].goal.value = v as Goal;
          getComparisonGoalReport();
        },
        icon: Image.asset(
          Assets.imagesDropDownIcon,
          height: 24,
        ),
        isDense: true,
        isExpanded: true,
        buttonHeight: 40,
        buttonPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        buttonDecoration: BoxDecoration(
          border: Border.all(
            color: kBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
          color: kSecondaryColor,
        ),
        buttonElevation: 0,
        itemHeight: 40,
        itemPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        dropdownMaxHeight: 200,
        dropdownWidth: Get.width * 0.92,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kSecondaryColor,
        ),
        dropdownElevation: 4,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-2, -5),
      ),
    );
  }

  getComparisonGoalReport() async {
    FocusManager.instance.primaryFocus?.unfocus();
    goalReportList.clear();
    isLoadingData.value = true;
    if(selectedGoalsList.isNotEmpty) {
      for (var i = 0; i < selectedGoalsList.length; i++) {
        httpManager
            .getGoalReport(
            PrefUtils().token, selectedGoalsList[i].goal.value.sId!)
            .then((value) {
          if (value.error == null) {
            if (value.snapshot is! ErrorResponse) {
              GoalReportListResponse goalReportListResponse = value.snapshot;
              if (goalReportListResponse.success == true) {
                if (goalReportListResponse.data != null) {
                  goalReportList.add(goalReportListResponse);
                  if (goalReportList.length == selectedGoalsList.length) {
                    processMultipleGoals();
                  }
                }
              } else {
                SmartDialog.dismiss();
                ToastUtils.showToast(goalReportListResponse.message ?? "",
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
    }else{
      isLoadingData.value = false;
      comparisonGoalsChartData.clear();
    }
  }

  String getCategoryName(List<GoalReportListResponseData> data) {
    for (var report in data) {
      if (report.details != null && report.details!.isNotEmpty) {
        return report.details![0].goal?.category?.name ?? "";
      }
    }
    return "";
  }

  List<List<ExpandComparisonChartDataModel>> processMultipleGoals() {
    comparisonGoalsChartData.clear();
    if (tabType.value == "one_week") {
      for (var report in goalReportList) {
        RxList<ExpandComparisonChartDataModel> comparisonChartData =
            <ExpandComparisonChartDataModel>[].obs;

        Map<String, List<int>> dailyGoalsGoalOne = {};
        Map<String, List<String>> commentsGoalOne = {};

        DateTime today = DateTime.now();
        DateTime oneWeekAgo = today.subtract(Duration(days: 7));

        for (int i = 1; i <= 7; i++) {
          DateTime date = oneWeekAgo.add(Duration(days: i));
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);

          dailyGoalsGoalOne[formattedDate] = [];
          commentsGoalOne[formattedDate] = [];
        }

        processGoalForMultipleOneWeek(
            report, dailyGoalsGoalOne, commentsGoalOne);

        dailyGoalsGoalOne.forEach((date, valuesGoalOne) {
          double averageGoalOne = valuesGoalOne.isNotEmpty
              ? valuesGoalOne.reduce((a, b) => a + b) / valuesGoalOne.length
              : 0;

          comparisonChartData.add(ExpandComparisonChartDataModel(
            date,
            averageGoalOne.toInt(),
            getCategoryName(report.data!) == "Wellbeing"
                ? kStreaksColor
                : getCategoryName(report.data!) == "Vocational"
                    ? kRACGPExamColor
                    : kDailyGratitudeColor,
          ));
        });
        comparisonGoalsChartData.add(comparisonChartData);
      }
    } else if (tabType.value == "one_month") {
      for (var report in goalReportList) {
        RxList<ExpandComparisonChartDataModel> comparisonChartData =
            <ExpandComparisonChartDataModel>[].obs;
        Map<String, List<int>> dailyGoalsGoalOne = {};
        Map<String, List<String>> commentsGoalOne = {};

        processGoalForMultipleOneMonth(
            report, dailyGoalsGoalOne, commentsGoalOne);

        dailyGoalsGoalOne.forEach((day, valuesGoalOne) {
          double averageGoalOne = valuesGoalOne.isNotEmpty
              ? valuesGoalOne.reduce((a, b) => a + b) / valuesGoalOne.length
              : 0;

          comparisonChartData.add(ExpandComparisonChartDataModel(
            day,
            averageGoalOne.toInt(),
            getCategoryName(report.data!) == "Wellbeing"
                ? kStreaksColor
                : getCategoryName(report.data!) == "Vocational"
                    ? kRACGPExamColor
                    : kDailyGratitudeColor,
          ));
        });
        comparisonChartData.value = comparisonChartData.reversed.toList();
        comparisonGoalsChartData.add(comparisonChartData);
      }
    } else if (tabType.value == "three_month") {
      for (var report in goalReportList) {
        RxList<ExpandComparisonChartDataModel> comparisonChartData =
            <ExpandComparisonChartDataModel>[].obs;
        Map<String, List<int>> monthlyGoalsGoalOne = {};
        Map<String, List<String>> commentsGoalOne = {};

        List<String> lastThreeMonths = _getLastThreeMonthNames();

        // Initialize maps with the names of the last three months
        for (var month in lastThreeMonths) {
          monthlyGoalsGoalOne[month] = [];
          commentsGoalOne[month] = [];
        }

        processGoalForMultipleThreeMonths(
            report, monthlyGoalsGoalOne, commentsGoalOne);

        // Create comparison chart data
        lastThreeMonths.forEach((month) {
          double averageGoalOne = monthlyGoalsGoalOne[month]!.isNotEmpty
              ? monthlyGoalsGoalOne[month]!.reduce((a, b) => a + b) /
                  monthlyGoalsGoalOne[month]!.length
              : 0;
          comparisonChartData.add(ExpandComparisonChartDataModel(
            month,
            averageGoalOne.toInt(),
            getCategoryName(report.data!) == "Wellbeing"
                ? kStreaksColor
                : getCategoryName(report.data!) == "Vocational"
                    ? kRACGPExamColor
                    : kDailyGratitudeColor,
          ));
        });
        comparisonGoalsChartData.add(comparisonChartData);
      }
    } else if (tabType.value == "six_month") {
      for (var report in goalReportList) {
        RxList<ExpandComparisonChartDataModel> comparisonChartData =
            <ExpandComparisonChartDataModel>[].obs;
        Map<String, List<int>> monthlyGoalsGoalOne = {};
        Map<String, List<String>> commentsGoalOne = {};

        // Calculate the last six months
        List<String> lastSixMonths = _getLastSixMonthNames();

        // Initialize maps with the names of the last six months
        for (var month in lastSixMonths) {
          monthlyGoalsGoalOne[month] = [];
          commentsGoalOne[month] = [];
        }

        processGoalForMultipleSizMonths(
            report, monthlyGoalsGoalOne, commentsGoalOne);

        lastSixMonths.forEach((month) {
          double averageGoalOne = monthlyGoalsGoalOne[month]!.isNotEmpty
              ? monthlyGoalsGoalOne[month]!.reduce((a, b) => a + b) /
                  monthlyGoalsGoalOne[month]!.length
              : 0;

          comparisonChartData.add(ExpandComparisonChartDataModel(
            month,
            averageGoalOne.toInt(),
            getCategoryName(report.data!) == "Wellbeing"
                ? kStreaksColor
                : getCategoryName(report.data!) == "Vocational"
                    ? kRACGPExamColor
                    : kDailyGratitudeColor,
          ));
        });
        comparisonGoalsChartData.add(comparisonChartData);
      }
    } else {
      for (var report in goalReportList) {
        RxList<ExpandComparisonChartDataModel> comparisonChartData =
            <ExpandComparisonChartDataModel>[].obs;

        Map<String, List<int>> monthlyGoalsGoalOne = {};
        Map<String, List<String>> commentsGoalOne = {};

        // Calculate the last 12 months
        List<String> lastTwelveMonths = _getLastTwelveMonthNames();

        // Initialize maps with the names of the last 12 months
        for (var month in lastTwelveMonths) {
          monthlyGoalsGoalOne[month] = [];
          commentsGoalOne[month] = [];
        }

        processGoalForMultipleOneYear(
            report, monthlyGoalsGoalOne, commentsGoalOne);

        // Create comparison chart data
        lastTwelveMonths.forEach((month) {
          double averageGoalOne = monthlyGoalsGoalOne[month]!.isNotEmpty
              ? monthlyGoalsGoalOne[month]!.reduce((a, b) => a + b) /
                  monthlyGoalsGoalOne[month]!.length
              : 0;
          comparisonChartData.add(ExpandComparisonChartDataModel(
            month,
            averageGoalOne.toInt(),
            getCategoryName(report.data!) == "Wellbeing"
                ? kStreaksColor
                : getCategoryName(report.data!) == "Vocational"
                    ? kRACGPExamColor
                    : kDailyGratitudeColor,
          ));
        });
        comparisonGoalsChartData.add(comparisonChartData);
      }
    }
    isLoadingData.value = false;
    return comparisonGoalsChartData;
  }

  List<String> _getLastTwelveMonthNames() {
    final DateTime today = DateTime.now();
    List<String> monthNames = [];

    for (int i = 11; i >= 0; i--) {
      final DateTime monthDate = DateTime(today.year, today.month - i, 1);
      final String monthName = DateFormat('MMM yyyy').format(monthDate);
      monthNames.add(monthName);
    }

    return monthNames;
  }

  List<GoalChartDateModel> processGoalForMultipleOneYear(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> monthlyGoals,
      Map<String, List<String>> comments) {
    // Initialize goalReportChart
    List<GoalChartDateModel> goalReportChart = [];

    // Get today's date and calculate the start date for one year ago
    final DateTime today = DateTime.now();
    final DateTime oneYearAgo = DateTime(today.year - 1, today.month, 1);

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      if (report.details != null && report.details!.isNotEmpty) {
        DateTime date = DateTime.parse(report.date!);
        // Filter entries within the last year
        if (date.isAfter(oneYearAgo.subtract(Duration(days: 1))) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          int value = 0;
          if (report.details!.isNotEmpty) {
            // Check if the goal measure is a boolean or a string
            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            // Format the month string with year
            String monthString = DateFormat('MMM yyyy').format(date);

            if (monthlyGoals.containsKey(monthString)) {
              monthlyGoals[monthString]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthString]!.add(comment);
              }
            }
          }
        }
      }
    }

    // Calculate averages and prepare chart data
    monthlyGoals.forEach((month, values) {
      double average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0;
      String comment = comments[month]!.join(', ');
      goalReportChart.add(GoalChartDateModel(month, average, comment));
    });

    return goalReportChart;
  }

  List<String> _getLastSixMonthNames() {
    final DateTime today = DateTime.now();
    List<String> monthNames = [];

    for (int i = 5; i >= 0; i--) {
      final DateTime monthDate = DateTime(today.year, today.month - i, 1);
      final String monthName = DateFormat('MMM').format(monthDate);
      monthNames.add(monthName);
    }

    return monthNames;
  }

  List<GoalChartDateModel> processGoalForMultipleSizMonths(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> monthlyGoals,
      Map<String, List<String>> comments) {
    // Initialize goalReportChart
    List<GoalChartDateModel> goalReportChart = [];

    // Get today's date and calculate the start date for six months ago
    final DateTime today = DateTime.now();
    final DateTime sixMonthsAgo = DateTime(today.year, today.month - 6, 1);

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      if (report.details != null && report.details!.isNotEmpty) {
        DateTime date = DateTime.parse(report.date!);
        // Filter entries within the last six months
        if (date.isAfter(sixMonthsAgo.subtract(Duration(days: 1))) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          int value = 0;
          if (report.details!.isNotEmpty) {
            // Check if the goal measure is a boolean or a string
            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            // Format the month string
            String monthString = DateFormat('MMM').format(date);

            if (monthlyGoals.containsKey(monthString)) {
              monthlyGoals[monthString]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthString]!.add(comment);
              }
            }
          }
        }
      }
    }

    // Calculate averages and prepare chart data
    monthlyGoals.forEach((month, values) {
      double average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0;
      String comment = comments[month]!.join(', ');
      goalReportChart.add(GoalChartDateModel(month, average, comment));
    });

    return goalReportChart;
  }

  List<String> _getLastThreeMonthNames() {
    final DateTime today = DateTime.now();
    List<String> monthNames = [];

    for (int i = 2; i >= 0; i--) {
      final DateTime monthDate = DateTime(today.year, today.month - i, 1);
      final String monthName = DateFormat('MMM').format(monthDate);
      monthNames.add(monthName);
    }

    return monthNames;
  }

  List<GoalChartDateModel> processGoalForMultipleThreeMonths(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> monthlyGoals,
      Map<String, List<String>> comments) {
    // Initialize goalReportChart
    List<GoalChartDateModel> goalReportChart = [];

    // Get today's date and calculate the start date for three months ago
    final DateTime today = DateTime.now();
    final DateTime threeMonthsAgo = DateTime(today.year, today.month - 3, 1);

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      if (report.details != null && report.details!.isNotEmpty) {
        DateTime date = DateTime.parse(report.date!);
        // Filter entries within the last three months
        if (date.isAfter(threeMonthsAgo.subtract(Duration(days: 1))) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          int value = 0;
          if (report.details!.isNotEmpty) {
            // Check if the goal measure is a boolean or a string
            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            // Format the month string
            String monthString = DateFormat('MMM').format(date);

            if (monthlyGoals.containsKey(monthString)) {
              monthlyGoals[monthString]!.add(value);
              if (comment.isNotEmpty) {
                comments[monthString]!.add(comment);
              }
            }
          }
        }
      }
    }

    // Calculate averages and prepare chart data
    monthlyGoals.forEach((month, values) {
      double average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0;
      String comment = comments[month]!.join(', ');
      goalReportChart.add(GoalChartDateModel(month, average, comment));
    });

    return goalReportChart;
  }

  List<GoalChartDateModel> processGoalForMultipleOneMonth(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> dailyGoals,
      Map<String, List<String>> comments) {
    // Initialize goalReportChart
    List<GoalChartDateModel> goalReportChart = [];

    // Get today's date and calculate the start date for one month ago
    final DateTime now = DateTime.now();
    final DateTime startOfMonth =
        now.subtract(Duration(days: 30)); // 30 days ago
    final DateTime endOfMonth = now;

    // Create a map to store the date labels for the last month
    for (int i = 0; i <= 30; i++) {
      DateTime day = now.subtract(Duration(days: i));
      String label = DateFormat('MMM dd').format(day);
      dailyGoals[label] = [];
      comments[label] = [];
    }

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      if (report.details != null && report.details!.isNotEmpty) {
        DateTime date = DateTime.parse(report.date!);

        // Check if the date is within the last 30 days
        if (date.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
            date.isBefore(endOfMonth.add(Duration(days: 1)))) {
          int value = 0;

          // Check if the goal measure is a boolean or a string
          if (report.details!.isNotEmpty) {
            if (report.details![0].type == 'boolean') {
              value = report.details![0].value == 'true' ? 100 : 0;
            } else if (report.details![0].type == 'string') {
              value = int.parse(report.details![0].value!) * 10;
            }

            String comment = report.details![0].comment ?? "";

            // Format the date label
            String dayLabel = DateFormat('MMM dd').format(date);
            if (dailyGoals.containsKey(dayLabel)) {
              dailyGoals[dayLabel]!.add(value);
              if (comment.isNotEmpty) {
                comments[dayLabel]!.add(comment);
              }
            }
          }
        }
      }
    }

    // Calculate averages and prepare chart data
    dailyGoals.forEach((label, values) {
      double average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0;
      String comment = comments[label]!.join(', ');
      goalReportChart.add(GoalChartDateModel(label, average, comment));
    });

    return goalReportChart;
  }

  List<GoalChartDateModel> processGoalForMultipleOneWeek(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> dailyGoals,
      Map<String, List<String>> comments) {
    List<GoalChartDateModel> goalReportChart = [];

    DateTime today = DateTime.now();
    DateTime oneWeekAgo = today.subtract(Duration(days: 7));

    for (int i = 1; i <= 7; i++) {
      DateTime date = oneWeekAgo.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      dailyGoals[formattedDate] = [];
      comments[formattedDate] = [];
    }

    for (var report in goalReportListResponse.data!) {
      if (report.details != null && report.details!.isNotEmpty) {
        DateTime date = DateTime.parse(report.date!);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (!dailyGoals.containsKey(formattedDate)) {
          continue;
        }

        int value = 0;

        if (report.details!.isNotEmpty) {
          if (report.details![0].type == 'boolean') {
            value = report.details![0].value == 'true' ? 100 : 0;
          } else if (report.details![0].type == 'string') {
            value = int.parse(report.details![0].value!) * 10;
          }

          String comment = report.details![0].comment ?? "";

          if (dailyGoals.containsKey(formattedDate)) {
            dailyGoals[formattedDate]!.add(value);
            if (comment.isNotEmpty) {
              comments[formattedDate]!.add(comment);
            }
          }
        }
      }
    }

    List<String> reversedOrder = [];
    for (int i = 1; i <= 7; i++) {
      DateTime date = oneWeekAgo.add(Duration(days: i));
      reversedOrder.add(DateFormat('yyyy-MM-dd').format(date));
    }

    for (var date in reversedOrder) {
      double average = dailyGoals[date]!.isNotEmpty
          ? dailyGoals[date]!.reduce((a, b) => a + b) / dailyGoals[date]!.length
          : 0;
      String comment = comments[date]!.join(', ');

      goalReportChart.add(GoalChartDateModel(date, average, comment));
    }

    return goalReportChart;
  }

  List<GoalChartDateModel> processGoalForMultiple(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> quarters,
      Map<String, List<String>> comments) {
    // Initialize goalReportChart
    List<GoalChartDateModel> goalReportChart = [];

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      DateTime date = DateTime.parse(report.date!);
      int value = 0;
      if (report.details!.isNotEmpty) {
        // Check if the goal measure is a boolean or a string
        if (report.details![0].type == 'boolean') {
          value = report.details![0].value == 'true' ? 100 : 0;
        } else if (report.details![0].type == 'string') {
          value = int.parse(report.details![0].value!) > 5 ? 100 : 10;
        }

        String comment = report.details![0].comment ?? "";

        // Assign to the correct period
        String period;
        if (date.month == 1 || date.month == 2) {
          period = 'Jan - Feb';
        } else if (date.month == 3 || date.month == 4) {
          period = 'Mar - Apr';
        } else if (date.month == 5 || date.month == 6) {
          period = 'May - Jun';
        } else if (date.month == 7 || date.month == 8) {
          period = 'Jul - Aug';
        } else if (date.month == 9 || date.month == 10) {
          period = 'Sep - Oct';
        } else if (date.month == 11 || date.month == 12) {
          period = 'Nov - Dec';
        } else {
          continue; // Skip if date month is invalid
        }

        quarters[period]!.add(value);
        if (comment.isNotEmpty) {
          comments[period]!.add(comment);
        }
      }
    }

    // Calculate averages and prepare chart data
    quarters.forEach((period, values) {
      double average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0;
      String comment = comments[period]!.join(', ');
      goalReportChart.add(GoalChartDateModel(period, average, comment));
    });

    return goalReportChart;
  }
}
