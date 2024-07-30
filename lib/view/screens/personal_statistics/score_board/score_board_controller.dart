import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';

import '../../../../model/goal_report/goal_report_list_response.dart';
import '../../../../model/user/user.dart';
import '../../../../utils/pref_utils.dart';

class ScoreBoardController extends FullLifeCycleController {
  StatisticsController statisticsController = Get.find<StatisticsController>();

  RxString graphType = "Past week".obs;
  RxBool isLoading = false.obs;
  User? user;
  RxList<Map<String, dynamic>> goalCompletionList =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
    calculateGoalPercentagesForLastWeek(
        statisticsController.goalReportListResponse!);
  }

  @override
  void onClose() {
    super.onClose();
  }

  _getUserData() {
    if (PrefUtils().user.isNotEmpty) {
      user = User.fromJson(json.decode(PrefUtils().user));
    }
  }

  calculateGoalPercentagesForLastWeek(
      GoalReportListResponse goalReportListResponse) {
    List<Map<String, dynamic>> goalPercentages = [];
    if (graphType.value == "Past week") {
      // Get today's date and calculate the start date for one week ago
      final DateTime today = DateTime.now();
      final DateTime oneWeekAgo = today.subtract(Duration(days: 7));
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data to extract goal information
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        // Filter entries within the last week
        if (entryDate.isAfter(oneWeekAgo) && entryDate.isBefore(today)) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;

              // Find the existing goal in the goalPercentages list or create a new one
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () => {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'values': []
                },
              );

              // Add new goal to the list if it's not already present
              if (!goalPercentages.contains(existingGoal)) {
                goalPercentages.add(existingGoal);
              }

              existingGoal['values'].add(detailValue);
            }
          }
        }
      }

      // Calculate the percentage for each goal
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;

        for (var value in goal['values']) {
          if (goal['measureType'] == 'boolean') {
            totalCompletion += value == 'true' ? 1 : 0;
          } else {
            double numericValue = double.parse(value);
            // Set completion to 100% if numeric value is greater than 5
            totalCompletion += numericValue > 5 ? 1 : numericValue / 10.0;
          }
        }

        double percentage = (totalCompletion / goal['values'].length) * 100;
        goal['completionPercentage'] = percentage;
      }

      // Sort the goals by completion percentage in descending order
      goalPercentages.sort((a, b) =>
          b['completionPercentage'].compareTo(a['completionPercentage']));
    } else if (graphType.value == "Past month") {
      // Get today's date and calculate the start date for one month ago
      final DateTime today = DateTime.now();
      final DateTime oneMonthAgo = DateTime(today.year, today.month - 1, today.day);
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data to extract goal information
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);

        // Filter entries within the last month
        if (entryDate.isAfter(oneMonthAgo) && entryDate.isBefore(today)) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;

              // Find the existing goal in the goalPercentages list or create a new one
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () => {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'values': []
                },
              );

              if (!goalPercentages.contains(existingGoal)) {
                goalPercentages.add(existingGoal);
              }

              existingGoal['values'].add(detailValue);
            }
          }
        }
      }

      // Calculate the percentage for each goal
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;

        for (var value in goal['values']) {
          if (goal['measureType'] == 'boolean') {
            totalCompletion += value == 'true' ? 1 : 0;
          } else {
            double numericValue = double.parse(value);
            // Set completion to 100% if numeric value is greater than 5
            totalCompletion += numericValue > 5 ? 1 : numericValue / 10.0;
          }
        }

        double percentage = (totalCompletion / goal['values'].length) * 100;
        goal['completionPercentage'] = percentage;
      }

      // Optionally, sort the goals by completion percentage in descending order
      goalPercentages.sort((a, b) => b['completionPercentage'].compareTo(a['completionPercentage']));

    } else if (graphType.value == "All") {
      // Iterate through the data to extract goal information
      for (var entry in goalReportListResponse.data!) {
        for (var detail in entry.details!) {
          if (detail.goal != null) {
            String goalId = detail.goal!.sId!;
            String goalName = detail.goal!.name!;
            String goalCategory = detail.goal!.category!.sId!;
            String goalMeasureType = detail.type!;
            String detailValue = detail.value!;

            // Find the existing goal in the goalPercentages list or create a new one
            var existingGoal = goalPercentages.firstWhere(
                  (g) => g['id'] == goalId,
              orElse: () => {
                'id': goalId,
                'name': goalName,
                'category': goalCategory,
                'measureType': goalMeasureType,
                'values': []
              },
            );

            // Add the new goal if not already present
            if (!goalPercentages.contains(existingGoal)) {
              goalPercentages.add(existingGoal);
            }

            existingGoal['values'].add(detailValue);
          }
        }
      }

      // Calculate the percentage for each goal
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;

        for (var value in goal['values']) {
          if (goal['measureType'] == 'boolean') {
            totalCompletion += value == 'true' ? 1 : 0;
          } else {
            double numericValue = double.parse(value);
            // Set completion to 100% if numeric value is greater than 5
            totalCompletion += numericValue > 5 ? 1 : numericValue / 10.0;
          }
        }

        double percentage = (totalCompletion / goal['values'].length) * 100;
        goal['completionPercentage'] = percentage;
      }

      // Sort the goals by completion percentage in descending order
      goalPercentages.sort((a, b) => b['completionPercentage'].compareTo(a['completionPercentage']));

    } else if (graphType.value == "Past year") {
      // Get today's date and calculate the start date for one year ago
      final DateTime today = DateTime.now();
      final DateTime oneYearAgo =
      DateTime(today.year - 1, today.month, today.day);
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data to extract goal information
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        // Filter entries within the last year
        if (entryDate.isAfter(oneYearAgo) && entryDate.isBefore(today)) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;

              // Find the existing goal in the goalPercentages list or create a new one
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () => {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'values': []
                },
              );

              // Only add if it's a new goal
              if (!goalPercentages.contains(existingGoal)) {
                goalPercentages.add(existingGoal);
              }

              existingGoal['values'].add(detailValue);
            }
          }
        }
      }

      // Calculate the percentage for each goal
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;

        for (var value in goal['values']) {
          if (goal['measureType'] == 'boolean') {
            totalCompletion += value == 'true' ? 1 : 0;
          } else {
            double numericValue = double.parse(value);
            // Set completion to 100% if numeric value is greater than 5
            totalCompletion += numericValue > 5 ? 1 : numericValue / 10.0;
          }
        }

        double percentage = (totalCompletion / goal['values'].length) * 100;
        goal['completionPercentage'] = percentage;
      }
      // Sort the goals by completion percentage in descending order
      goalPercentages.sort((a, b) => b['completionPercentage'].compareTo(a['completionPercentage']));

    }
    goalCompletionList.clear();
    goalCompletionList.addAll(goalPercentages);
  }
}
