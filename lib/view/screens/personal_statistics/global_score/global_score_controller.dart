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
    chartData.clear();
    if (tabType.value == "one_week") {
      Map<String, Map<String, List<double>>> categorizedData = {
        'Mon': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Tue': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Wed': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Thu': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Fri': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Sat': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Sun': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
      };

      // Track total goals and completed goals for each day
      Map<String, int> totalGoals = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0
      };
      Map<String, int> completedGoals = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0
      };

      DateTime currentDate = DateTime.now();
      DateTime oneWeekAgo = currentDate.subtract(Duration(days: 6));

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(oneWeekAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String dayOfWeek = getDayOfWeek(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value > 50 ? 100 : 0;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[dayOfWeek]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            // Update total and completed goals
            totalGoals[dayOfWeek] = (totalGoals[dayOfWeek] ?? 0) + 1;
            if (completionPercentage == 100) {
              completedGoals[dayOfWeek] = (completedGoals[dayOfWeek] ?? 0) + 1;
            }
          }
        }
      }

      categorizedData.forEach((day, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
            calculateAverage(categoryData['Personal Development']!);

        // Calculate global average as the ratio of completed goals to total goals
        double globalAvg = totalGoals[day]! > 0
            ? (completedGoals[day]! / totalGoals[day]!) * 100
            : 0;

        // Debug prints
        print('Day: $day');
        print('Total Goals: ${totalGoals[day]}');
        print('Completed Goals: ${completedGoals[day]}');
        print('Global Avg: $globalAvg');

        chartData.add(GlobalScoreChartOneWeekDataModel(
          day,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });
    } else if (tabType.value == "one_month") {
      Map<String, Map<String, List<double>>> categorizedData = {};

      DateTime currentDate = DateTime.now();
      DateTime oneMonthAgo = currentDate.subtract(Duration(days: 30));

      // Generate date labels for the last 30 days
      for (int i = 0; i <= 30; i++) {
        DateTime date = currentDate.subtract(Duration(days: i));
        String label = DateFormat('MMM dd').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      // Track total goals and completed goals
      Map<String, int> totalGoals = {};
      Map<String, int> completedGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(oneMonthAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String dateLabel = DateFormat('MMM dd').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value > 50 ? 100 : 0;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[dateLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            // Initialize counters if necessary
            totalGoals[dateLabel] = (totalGoals[dateLabel] ?? 0) + 1;
            if (completionPercentage == 100) {
              completedGoals[dateLabel] = (completedGoals[dateLabel] ?? 0) + 1;
            }
          }
        }
      }

      categorizedData.forEach((dateLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
            calculateAverage(categoryData['Personal Development']!);

        // Calculate global average as the ratio of completed goals to total goals
        double globalAvg = (totalGoals.containsKey(dateLabel) &&
                totalGoals[dateLabel]! > 0)
            ? (completedGoals.containsKey(dateLabel)
                ? (completedGoals[dateLabel]! / totalGoals[dateLabel]!) * 100
                : 0)
            : 0;

        // Debug prints
        print('Date: $dateLabel');
        print('Total Goals: ${totalGoals[dateLabel]}');
        print('Completed Goals: ${completedGoals[dateLabel]}');
        print('Global Avg: $globalAvg');

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
      DateTime threeMonthsAgo =
          DateTime(currentDate.year, currentDate.month - 2, 1);

      // Generate month labels for the last 3 months
      for (int i = 2; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      // Track total goals and completed goals for each month
      Map<String, int> totalGoals = {};
      Map<String, int> completedGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(threeMonthsAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value > 50 ? 100 : 0;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            // Initialize counters if necessary
            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
            if (completionPercentage == 100) {
              completedGoals[monthLabel] =
                  (completedGoals[monthLabel] ?? 0) + 1;
            }
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
            calculateAverage(categoryData['Personal Development']!);

        // Calculate global average as the ratio of completed goals to total goals
        double globalAvg = (totalGoals.containsKey(monthLabel) &&
                totalGoals[monthLabel]! > 0)
            ? (completedGoals.containsKey(monthLabel)
                ? (completedGoals[monthLabel]! / totalGoals[monthLabel]!) * 100
                : 0)
            : 0;

        // Debug prints
        print('Month: $monthLabel');
        print('Total Goals: ${totalGoals[monthLabel]}');
        print('Completed Goals: ${completedGoals[monthLabel]}');
        print('Global Avg: $globalAvg');

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
      DateTime sixMonthsAgo =
          DateTime(currentDate.year, currentDate.month - 5, 1);

      // Generate month labels for the last 6 months
      for (int i = 5; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      // Track total goals and completed goals for each month
      Map<String, int> totalGoals = {};
      Map<String, int> completedGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(sixMonthsAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = value > 50
                  ? 100
                  : 0; // Assuming a goal is considered complete if value > 50
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]
                ?.add(completionPercentage);

            // Initialize counters if necessary
            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
            if (completionPercentage == 100) {
              completedGoals[monthLabel] =
                  (completedGoals[monthLabel] ?? 0) + 1;
            }
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
            calculateAverage(categoryData['Personal Development']!);

        // Calculate global average as the ratio of completed goals to total goals
        double globalAvg = (totalGoals.containsKey(monthLabel) &&
                totalGoals[monthLabel]! > 0)
            ? (completedGoals.containsKey(monthLabel)
                ? (completedGoals[monthLabel]! / totalGoals[monthLabel]!) * 100
                : 0)
            : 0;

        // Debug prints
        print('Month: $monthLabel');
        print('Total Goals: ${totalGoals[monthLabel]}');
        print('Completed Goals: ${completedGoals[monthLabel]}');
        print('Global Avg: $globalAvg');

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
      DateTime twelveMonthsAgo = DateTime(
          currentDate.year, currentDate.month - 11, 1);

      // Generate month labels for the last 12 months
      for (int i = 11; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String label = DateFormat('MMM').format(date);
        categorizedData[label] = {
          'Vocational': [],
          'Wellbeing': [],
          'Personal Development': []
        };
      }

      // Track total goals and completed goals for each month
      Map<String, int> totalGoals = {};
      Map<String, int> completedGoals = {};

      for (var report in controller.goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(twelveMonthsAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String monthLabel = DateFormat('MMM').format(reportDate);

        for (var detail in report.details!) {
          if (detail.goal != null) {
            double completionPercentage = 0;

            if (detail.type == 'string') {
              double value = double.parse(detail.value!);
              completionPercentage = (value / 10) * 100;
            } else if (detail.type == 'boolean') {
              bool value = detail.value == 'true';
              completionPercentage = value ? 100 : 0;
            }

            categorizedData[monthLabel]?[detail.goal!.category!.name]?.add(
                completionPercentage);

            // Initialize counters if necessary
            totalGoals[monthLabel] = (totalGoals[monthLabel] ?? 0) + 1;
            if (completionPercentage == 100) {
              completedGoals[monthLabel] =
                  (completedGoals[monthLabel] ?? 0) + 1;
            }
          }
        }
      }

      categorizedData.forEach((monthLabel, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg = calculateAverage(
            categoryData['Personal Development']!);

        // Calculate global average as the ratio of completed goals to total goals
        double globalAvg = (totalGoals.containsKey(monthLabel) &&
            totalGoals[monthLabel]! > 0)
            ? (completedGoals.containsKey(monthLabel)
            ? (completedGoals[monthLabel]! / totalGoals[monthLabel]!) * 100
            : 0)
            : 0;

        // Debug prints
        print('Month: $monthLabel');
        print('Total Goals: ${totalGoals[monthLabel]}');
        print('Completed Goals: ${completedGoals[monthLabel]}');
        print('Global Avg: $globalAvg');

        chartData.add(GlobalScoreChartOneWeekDataModel(
          monthLabel,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });
    }
    if (tabType.value != "three_month" && tabType.value != "six_month" &&
    tabType.value != "one_year") {
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
