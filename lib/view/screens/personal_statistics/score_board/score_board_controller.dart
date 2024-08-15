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

  RxString graphType = "This week".obs;
  RxString sortBy = "Percentage".obs;
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
    if (graphType.value == "This week") {

      final DateTime today = DateTime.now();
      final DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        if (entryDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            entryDate.isBefore(endOfWeek.add(Duration(days: 1)))) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;
              String achieveType = detail.goal!.achieveType!;
              int achieveXDays = int.parse(detail.goal!.achieveXDays!); // Number of days to achieve
              int goalImportance = int.parse(detail.goal!.goalImportance!);

              // Add or update goal in the list
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () =>
                {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'achieveType': achieveType,
                  'achieveXDays': achieveXDays,
                  'values': [],
                  'importance': goalImportance,
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

      // Calculate the percentage completion
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;
        int achieveDaysPerWeek = goal['achieveXDays'];

        if (goal['measureType'] == 'boolean') {
          List<double> dailyScores = List.generate(7, (index) => 0.0); // Initialize scores for each day of the week

          // Calculate daily scores
          for (int i = 0; i < goal['values'].length; i++) {
            bool isAchieved = goal['values'][i] == 'true';
            int dayOfWeek = DateTime.now().subtract(Duration(days: i)).weekday;
            if (isAchieved) {
              dailyScores[dayOfWeek - 1] += 1;
            }
          }

          // Calculate weekly completion percentage
          for (int i = 0; i < 7; i++) {
            double dailyScore = (dailyScores[i] / achieveDaysPerWeek) * 100;
            dailyScores[i] = dailyScore.clamp(0, 100);
          }

          // Aggregate weekly score
          totalCompletion = dailyScores.reduce((a, b) => a + b) / 7;

        } else {
          // For point scale goals
          List<dynamic> tempValues = goal['values'].map((v) {
            try {
              return double.parse(v.toString());
            } catch (e) {
              return 0.0;
            }
          }).toList();
          List<double> values = tempValues.cast<double>();

          values.sort((a, b) => b.compareTo(a)); // Sort values descending
          List<double> topValues = values.take(achieveDaysPerWeek).toList(); // Top scores
          double average = topValues.isNotEmpty
              ? topValues.reduce((a, b) => a + b) / topValues.length
              : 0.0;

          totalCompletion = average;
        }

        goal['completionPercentage'] = totalCompletion.clamp(0, 100);
      }

      // Sort the goals by completion percentage in descending order
      if(sortBy.value == "Percentage") {
        goalPercentages.sort((a, b) =>
            b['completionPercentage'].compareTo(a['completionPercentage']));
      }else{
        goalPercentages.sort((a, b) =>
            b['importance'].compareTo(a['importance']));
      }

    } else if (graphType.value == "This month") {
      final DateTime today = DateTime.now();
      final DateTime startOfMonth = DateTime(today.year, today.month, 1);
      final DateTime endOfMonth = DateTime(today.year, today.month + 1, 0);
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        if (entryDate.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
            entryDate.isBefore(endOfMonth.add(Duration(days: 1)))) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;
              String achieveType = detail.goal!.achieveType!;
              int achieveXDays = int.parse(detail.goal!.achieveXDays!); // Number of days to achieve
              int goalImportance = int.parse(detail.goal!.goalImportance!);

              // Add or update goal in the list
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () =>
                {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'achieveType': achieveType,
                  'achieveXDays': achieveXDays,
                  'values': [],
                  'importance': goalImportance,
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

      // Calculate the percentage completion
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;
        int achieveDaysPerWeek = goal['achieveXDays'];

        if (goal['measureType'] == 'boolean') {
          // Initialize scores for each week in the month
          List<List<double>> weeklyScores = List.generate(4, (index) => List.generate(7, (index) => 0.0));

          // Calculate weekly scores
          for (int i = 0; i < goal['values'].length; i++) {
            bool isAchieved = goal['values'][i] == 'true';
            DateTime entryDate = DateTime.now().subtract(Duration(days: i));
            int weekOfMonth = ((entryDate.day - 1) / 7).floor();
            int dayOfWeek = entryDate.weekday - 1;

            if (isAchieved) {
              weeklyScores[weekOfMonth][dayOfWeek] += 1;
            }
          }

          // Calculate weekly completion percentages
          List<double> weeklyCompletionPercentages = weeklyScores.map((weekScores) {
            double totalScore = weekScores.reduce((a, b) => a + b);
            return (totalScore / (achieveDaysPerWeek * weekScores.length)) * 100;
          }).toList();

          // Aggregate monthly score
          totalCompletion = weeklyCompletionPercentages.reduce((a, b) => a + b) / weeklyCompletionPercentages.length;

        } else {
          // For point scale goals
          List<dynamic> tempValues = goal['values'].map((v) {
            try {
              return double.parse(v.toString());
            } catch (e) {
              return 0.0;
            }
          }).toList();
          List<double> values = tempValues.cast<double>();

          // Sort values descending
          values.sort((a, b) => b.compareTo(a));

          // Take the top scores based on achieveXDays
          List<double> topValues = values.take(achieveDaysPerWeek).toList();
          double average = topValues.isNotEmpty
              ? topValues.reduce((a, b) => a + b) / topValues.length
              : 0.0;

          totalCompletion = average;
        }

        goal['completionPercentage'] = totalCompletion.clamp(0, 100);
      }

      // Sort the goals by completion percentage in descending order
      if(sortBy.value == "Percentage") {
        goalPercentages.sort((a, b) =>
            b['completionPercentage'].compareTo(a['completionPercentage']));
      }else{
        goalPercentages.sort((a, b) =>
            b['importance'].compareTo(a['importance']));
      }

    } else if (graphType.value == "All") {
      // Iterate through the data to extract goal information

      final DateTime today = DateTime.now();
      final DateTime startOfYear = DateTime(today.year, 1, 1);
      final DateTime endOfYear = DateTime(today.year, 12, 31);
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        if (entryDate.isAfter(startOfYear.subtract(Duration(days: 1))) &&
            entryDate.isBefore(endOfYear.add(Duration(days: 1)))) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;
              String achieveType = detail.goal!.achieveType!;
              int achieveXDays = int.parse(detail.goal!.achieveXDays!); // Number of days to achieve
              int goalImportance = int.parse(detail.goal!.goalImportance!);

              // Add or update goal in the list
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () =>
                {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'achieveType': achieveType,
                  'achieveXDays': achieveXDays,
                  'values': [],
                  'importance': goalImportance,
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

      // Calculate the percentage completion
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;
        int achieveDaysPerWeek = goal['achieveXDays'];

        if (goal['measureType'] == 'boolean') {
          // Initialize scores for each week in the year
          List<List<double>> weeklyScores = List.generate(52, (index) => List.generate(7, (index) => 0.0));

          // Calculate weekly scores
          for (int i = 0; i < goal['values'].length; i++) {
            bool isAchieved = goal['values'][i] == 'true';
            DateTime entryDate = DateTime.now().subtract(Duration(days: i));
            int weekOfYear = ((entryDate.difference(startOfYear).inDays ~/ 7)).toInt();
            int dayOfWeek = entryDate.weekday - 1;

            if (isAchieved) {
              weeklyScores[weekOfYear][dayOfWeek] += 1;
            }
          }

          // Calculate weekly completion percentages
          List<double> weeklyCompletionPercentages = weeklyScores.map((weekScores) {
            double totalScore = weekScores.reduce((a, b) => a + b);
            return (totalScore / (achieveDaysPerWeek * weekScores.length)) * 100;
          }).toList();

          // Aggregate yearly score
          totalCompletion = weeklyCompletionPercentages.reduce((a, b) => a + b) / weeklyCompletionPercentages.length;

        } else {
          // For point scale goals
          List<dynamic> tempValues = goal['values'].map((v) {
            try {
              return double.parse(v.toString());
            } catch (e) {
              return 0.0;
            }
          }).toList();
          List<double> values = tempValues.cast<double>();

          // Sort values descending
          values.sort((a, b) => b.compareTo(a));

          // Take the top scores based on achieveXDays
          List<double> topValues = values.take(achieveDaysPerWeek).toList();
          double average = topValues.isNotEmpty
              ? topValues.reduce((a, b) => a + b) / topValues.length
              : 0.0;

          totalCompletion = average;
        }

        goal['completionPercentage'] = totalCompletion.clamp(0, 100);
      }


      // Sort the goals by completion percentage in descending order
      if(sortBy.value == "Percentage") {
        goalPercentages.sort((a, b) =>
            b['completionPercentage'].compareTo(a['completionPercentage']));
      }else{
        goalPercentages.sort((a, b) =>
            b['importance'].compareTo(a['importance']));
      }

    } else if (graphType.value == "This year") {
      // Get today's date and calculate the start date for one year ago
      final DateTime today = DateTime.now();
      final DateTime startOfYear = DateTime(today.year, 1, 1);
      final DateTime endOfYear = DateTime(today.year, 12, 31);
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      // Iterate through the data
      for (var entry in goalReportListResponse.data!) {
        final DateTime entryDate = dateFormat.parse(entry.date!, true);
        if (entryDate.isAfter(startOfYear.subtract(Duration(days: 1))) &&
            entryDate.isBefore(endOfYear.add(Duration(days: 1)))) {
          for (var detail in entry.details!) {
            if (detail.goal != null) {
              String goalId = detail.goal!.sId!;
              String goalName = detail.goal!.name!;
              String goalCategory = detail.goal!.category!.sId!;
              String goalMeasureType = detail.type!;
              String detailValue = detail.value!;
              String achieveType = detail.goal!.achieveType!;
              int achieveXDays = int.parse(detail.goal!.achieveXDays!); // Number of days to achieve
              int goalImportance = int.parse(detail.goal!.goalImportance!);

              // Add or update goal in the list
              var existingGoal = goalPercentages.firstWhere(
                    (g) => g['id'] == goalId,
                orElse: () =>
                {
                  'id': goalId,
                  'name': goalName,
                  'category': goalCategory,
                  'measureType': goalMeasureType,
                  'achieveType': achieveType,
                  'achieveXDays': achieveXDays,
                  'values': [],
                  'importance': goalImportance,
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

      // Calculate the percentage completion
      for (var goal in goalPercentages) {
        double totalCompletion = 0.0;
        int achieveDaysPerWeek = goal['achieveXDays'];

        if (goal['measureType'] == 'boolean') {
          // Initialize scores for each week in the year
          List<List<double>> weeklyScores = List.generate(52, (index) => List.generate(7, (index) => 0.0));

          // Calculate weekly scores
          for (int i = 0; i < goal['values'].length; i++) {
            bool isAchieved = goal['values'][i] == 'true';
            DateTime entryDate = DateTime.now().subtract(Duration(days: i));
            int weekOfYear = ((entryDate.difference(startOfYear).inDays ~/ 7)).toInt();
            int dayOfWeek = entryDate.weekday - 1;

            if (isAchieved) {
              weeklyScores[weekOfYear][dayOfWeek] += 1;
            }
          }

          // Calculate weekly completion percentages
          List<double> weeklyCompletionPercentages = weeklyScores.map((weekScores) {
            double totalScore = weekScores.reduce((a, b) => a + b);
            return (totalScore / (achieveDaysPerWeek * weekScores.length)) * 100;
          }).toList();

          // Aggregate yearly score
          totalCompletion = weeklyCompletionPercentages.reduce((a, b) => a + b) / weeklyCompletionPercentages.length;

        } else {
          // For point scale goals
          List<dynamic> tempValues = goal['values'].map((v) {
            try {
              return double.parse(v.toString());
            } catch (e) {
              return 0.0;
            }
          }).toList();
          List<double> values = tempValues.cast<double>();

          // Sort values descending
          values.sort((a, b) => b.compareTo(a));

          // Take the top scores based on achieveXDays
          List<double> topValues = values.take(achieveDaysPerWeek).toList();
          double average = topValues.isNotEmpty
              ? topValues.reduce((a, b) => a + b) / topValues.length
              : 0.0;

          totalCompletion = average;
        }

        goal['completionPercentage'] = totalCompletion.clamp(0, 100);
      }

      if(sortBy.value == "Percentage") {
        goalPercentages.sort((a, b) =>
            b['completionPercentage'].compareTo(a['completionPercentage']));
      }else{
        goalPercentages.sort((a, b) =>
            b['importance'].compareTo(a['importance']));
      }

    }
    goalCompletionList.clear();
    goalCompletionList.addAll(goalPercentages);
  }
}
