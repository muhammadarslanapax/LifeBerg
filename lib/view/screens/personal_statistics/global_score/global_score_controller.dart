import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_report/details.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response_data.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response_data.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';

import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';
import 'gloabl_score_charts/global_score_one_week_chart.dart';

class GlobalScoreController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  RxBool isLoadingGoalsReport = true.obs;

  final StatisticsController controller = Get.find<StatisticsController>();

  RxList<GlobalScoreChartOneWeekDataModel> chartData =
      <GlobalScoreChartOneWeekDataModel>[].obs;

  User? user;

  RxBool isGlobalSelected = true.obs;
  RxBool isWellbeingSelected = true.obs;
  RxBool isVocationalSelected = true.obs;
  RxBool isPersonalDevelopmentSelected = true.obs;

  RxString tabType = "one_week".obs;

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
      getGlobalScoreReport();
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

  List<GlobalScoreChartOneWeekDataModel> getGlobalScoreReport() {
    isLoadingGoalsReport.value = true;
    if (tabType.value == "one_week") {
      Map<String, Map<String, List<double>>> categorizedData = {};
      Map<String, int> totalGoals = {};

      DateTime now = DateTime.now();
      DateTime startOfLastWeek = now.subtract(Duration(days: 7));

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        categorizedData[formattedDate] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
        totalGoals[formattedDate] = 0;
      }

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        String formattedDate = DateFormat('yyyy-MM-dd').format(reportDate);

        if (!categorizedData.containsKey(formattedDate)) {
          continue;
        }

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value * 10;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[formattedDate]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            totalGoals[formattedDate] = (totalGoals[formattedDate] ?? 0) + 1;
          }
        }
      }

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        double vocationalAvg =
        calculateAverage(categorizedData[formattedDate]!['Vocational']!);
        double wellbeingAvg =
        calculateAverage(categorizedData[formattedDate]!['Wellbeing']!);
        double personalDevelopmentAvg =
        calculateAverage(categorizedData[formattedDate]!['Personal Development']!);

        double globalAvg = totalGoals[formattedDate]! > 0
            ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
            : 0;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          formattedDate,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      }

    } else if (tabType.value == "one_month") {
      Map<String, Map<String, List<double>>> categorizedData = {};

      DateTime currentDate = DateTime.now();
      DateTime oneMonthAgo = currentDate.subtract(Duration(days: 30));

      for (int i = 0; i <= 30; i++) {
        DateTime date = currentDate.subtract(Duration(days: i));
        String label = DateFormat('MMM dd').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      Map<String, int> totalGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(oneMonthAgo) || reportDate.isAfter(currentDate)) {
          continue;
        }

        String dateLabel = DateFormat('MMM dd').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value * 10;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[dateLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            totalGoals[dateLabel] = (totalGoals[dateLabel] ?? 0) + 1;
          }
        }
      }

      categorizedData.forEach((dateLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg = calculateAverage(categoryData['Personal Development']!);

        double globalAvg = totalGoals.containsKey(dateLabel) && totalGoals[dateLabel]! > 0
            ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
            : 0;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          dateLabel,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });

    } else if (tabType.value == "three_month") {
      Map<String, Map<String, List<double>>> categorizedData = {};

      DateTime currentDate = DateTime.now();
      DateTime threeMonthsAgo = DateTime(currentDate.year, currentDate.month - 2, 1);

      for (int i = 2; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      Map<String, int> totalGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(threeMonthsAgo) || reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value * 10;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg = calculateAverage(categoryData['Personal Development']!);

        double globalAvg = totalGoals.containsKey(monthLabel) && totalGoals[monthLabel]! > 0
            ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
            : 0;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          monthLabel,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });

    } else if (tabType.value == "six_month") {
      Map<String, Map<String, List<double>>> categorizedData = {};

      DateTime currentDate = DateTime.now();
      DateTime sixMonthsAgo = DateTime(currentDate.year, currentDate.month - 5, 1);

      for (int i = 5; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }


      Map<String, int> totalGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(sixMonthsAgo) || reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value * 10;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg = calculateAverage(categoryData['Personal Development']!);

        // Calculate global average based on weighted contributions
        double globalAvg = totalGoals.containsKey(monthLabel) && totalGoals[monthLabel]! > 0
            ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
            : 0;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          monthLabel,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });

    } else {
      Map<String, Map<String, List<double>>> categorizedData = {};

      DateTime currentDate = DateTime.now();
      DateTime twelveMonthsAgo = DateTime(currentDate.year, currentDate.month - 11, 1);

      for (int i = 11; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      Map<String, int> totalGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(twelveMonthsAgo) || reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value * 10;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);
            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
        calculateAverage(categoryData['Personal Development']!);

        double globalAvg = totalGoals.containsKey(monthLabel) && totalGoals[monthLabel]! > 0
            ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
            : 0;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          monthLabel,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });
    }

    if (tabType.value == "one_month") {
      chartData.value = chartData.reversed.toList();
    }
    isLoadingGoalsReport.value = false;
    return chartData;
  }

  double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    double sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  String getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
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
}
