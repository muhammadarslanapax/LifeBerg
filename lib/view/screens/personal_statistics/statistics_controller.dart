import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_report/details.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response_data.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response_data.dart';

import '../../../constant/color.dart';
import '../../../constant/strings.dart';
import '../../../model/error/error_response.dart';
import '../../../model/goal/goal.dart';
import '../../../model/user/user.dart';
import '../../../model/user/user_response.dart';
import '../../../utils/pref_utils.dart';
import '../../../utils/toast_utils.dart';
import '../../widget/charts_widget/mood_chart.dart';
import 'comparison/comparison.dart';
import 'global_score/gloabl_score_charts/global_score_one_week_chart.dart';
import 'global_score/global_score.dart';
import 'goals/goal_charts/goal_one_week_chart.dart';
import 'goals/goals.dart';

class StatisticsController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final HttpManager httpManager = HttpManager();

  RxBool isLoadingGoalsReport = true.obs;
  RxBool isLoadingMoodHistory = true.obs;
  RxBool isLoadingGoals = true.obs;

  List<MoodHistoryResponseData> moodHistory = [];
  final List<MoodChartDataModel> moodChartData = [];
  List<Map<String, dynamic>> goalCompletionList = [];
  final List<GlobalScoreChartOneWeekDataModel> chartData = [];
  List<Goal> goalsList = [];
  List<int> goalsListIndex = [];
  RxList<GoalReportListResponseData> expandedGoalReport =
      <GoalReportListResponseData>[].obs;
  RxList<GoalReportListResponseData> commentsGoalReport =
      <GoalReportListResponseData>[].obs;
  RxList<GoalReportListResponseData> specificGoalReport =
      <GoalReportListResponseData>[].obs;

  RxList<GoalReportListResponse> firstGoalReport =
      <GoalReportListResponse>[].obs;
  RxList<GoalReportListResponse> secondGoalReport =
      <GoalReportListResponse>[].obs;

  RxList<ComparisonChartDataModel> comparisonChartData =
      <ComparisonChartDataModel>[].obs;

  RxList<GoalChartDateModel> goalReportChart = <GoalChartDateModel>[].obs;
  RxList<GoalChartDateModel> expandedGoalReportChart =
      <GoalChartDateModel>[].obs;

  GoalReportListResponse? goalReportListResponse;

  User? user;
  RxString fullName = "".obs;
  RxString userName = "".obs;
  RxString userProfileImageUrl = "".obs;

  RxInt selectedGoalIndex = 0.obs;
  RxInt selectedFirstGoalIndex = 0.obs;
  RxInt selectedSecondGoalIndex = 0.obs;
  RxInt selectedExpandGoalIndex = 0.obs;
  RxInt selectedCommentExpandGoalIndex = 0.obs;

  RxInt topStreak = 0.obs;
  RxInt perfectDays = 0.obs;
  RxInt goalsAchieved = 0.obs;

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
      getUserDetail();
      getUserGoalsReport();
      getMoodHistory();
      getUserGoals();
    }
  }

  getUserDetail() {
    httpManager
        .getCurrentUserDetail(
      PrefUtils().token,
    )
        .then((response) {
      if (response.error == null) {
        UserResponse userResponse = response.snapshot;
        if (userResponse.success == true) {
          PrefUtils().user = json.encode(userResponse.user);
          getTopStreak();
        }
      } else {
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  getUserGoalsReport({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingGoalsReport.value = true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getAllGoalReports(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalReportListResponse goalReportListResponse = value.snapshot;
          if (goalReportListResponse.success == true) {
            if (goalReportListResponse.data != null) {
              this.goalReportListResponse = goalReportListResponse;
              goalCompletionList.clear();
              chartData.clear();
              getPerfectDays();
              getGoalAchieved();
              goalCompletionList
                  .addAll(calculateGoalPercentages(goalReportListResponse));
              processGoalData(goalReportListResponse);
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
      if (isShowLoading) {
        isLoadingGoalsReport.value = false;
      }
    });
  }

  getMoodHistory({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingMoodHistory.value = true;
      moodHistory.clear();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getAllMoodHistory(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          MoodHistoryResponse moodHistoryResponse = value.snapshot;
          if (moodHistoryResponse.success == true) {
            if (moodHistoryResponse.data != null) {
              moodHistory.addAll(moodHistoryResponse.data!);
              moodChartData
                  .addAll(groupDataByQuarter(moodHistoryResponse.data!));
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(moodHistoryResponse.message ?? "",
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
      if (isShowLoading) {
        isLoadingMoodHistory.value = false;
      }
    });
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

  List<MoodChartDataModel> groupDataByQuarter(
      List<MoodHistoryResponseData> data) {
    // Creating a map to hold the grouped data
    final Map<String, List<int>> groupedData = {
      'Jan-Mar': [],
      'Apr-Jul': [],
      'Aug-Oct': [],
      'Nov-Dec': []
    };

    // Defining date format
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    // Iterating through the data
    for (var entry in data) {
      final DateTime date = dateFormat.parse(entry.date!, true);
      final int mood = int.parse(entry.mood!) * 20;
      final String key = getQuarterKey(date);

      if (key.isNotEmpty) {
        groupedData[key]?.add(mood);
      }
    }

    // Creating MoodChartDataModel instances
    final List<MoodChartDataModel> moodChartData =
        groupedData.entries.map((entry) {
      final String quarter = entry.key;
      final List<int> moods = entry.value;
      final int averageMood = moods.isNotEmpty
          ? (moods.reduce((a, b) => a + b) / moods.length).round()
          : 0;

      return MoodChartDataModel(quarter, averageMood);
    }).toList();

    return moodChartData;
  }

  String getQuarterKey(DateTime date) {
    final int month = date.month;

    if (month >= 1 && month <= 3) {
      return 'Jan-Mar';
    } else if (month >= 4 && month <= 7) {
      return 'Apr-Jul';
    } else if (month >= 8 && month <= 10) {
      return 'Aug-Oct';
    } else if (month >= 11 && month <= 12) {
      return 'Nov-Dec';
    } else {
      return '';
    }
  }

  List<Map<String, dynamic>> generateDynamicPeriods(
      List<GoalReportListResponseData> data) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime minDate = dateFormat.parse(data!.first.date!, true);
    DateTime maxDate = dateFormat.parse(data!.first.date!, true);

    for (var entry in data!) {
      DateTime entryDate = dateFormat.parse(entry.date!, true);
      if (entryDate.isBefore(minDate)) minDate = entryDate;
      if (entryDate.isAfter(maxDate)) maxDate = entryDate;
    }

    List<Map<String, dynamic>> periods = [];
    DateTime currentStart = DateTime(minDate.year, minDate.month, 1);
    DateTime currentEnd = DateTime(currentStart.year, currentStart.month + 3, 1)
        .subtract(Duration(days: 1));

    while (currentStart.isBefore(maxDate)) {
      periods.add({
        'label': DateFormat('MMM').format(currentStart) +
            ' - ' +
            DateFormat('MMM').format(currentEnd),
        'start': currentStart,
        'end': currentEnd
      });

      currentStart = DateTime(currentEnd.year, currentEnd.month + 1, 1);
      currentEnd = DateTime(currentStart.year, currentStart.month + 3, 1)
          .subtract(Duration(days: 1));
    }

    return periods;
  }

  List<GlobalScoreChartOneWeekDataModel> getGlobalScoreReport(String type) {
    if (type == "one_week") {
      Map<String, Map<String, List<double>>> categorizedData = {
        'Mon': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Tue': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Wed': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Thu': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Fri': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Sat': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
        'Sun': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
      };

      DateTime currentDate = DateTime.now();
      DateTime oneWeekAgo = currentDate.subtract(Duration(days: 6));

      for (var report in goalReportListResponse!.data!) {
        DateTime reportDate = DateTime.parse(report.date!);
        if (reportDate.isBefore(oneWeekAgo) ||
            reportDate.isAfter(currentDate)) {
          continue;
        }

        String category = getDayOfWeek(reportDate);

        for (var detail in report.details!) {
          double completionPercentage = 0;

          if (detail.type == 'string') {
            double value = double.parse(detail.value!);
            completionPercentage = (value / 10) * 100;
          } else if (detail.type == 'boolean') {
            bool value = detail.value == 'true';
            completionPercentage = value ? 100 : 0;
          }

          categorizedData[category]?[detail.goal!.category!.name]
              ?.add(completionPercentage);
        }
      }

      List<GlobalScoreChartOneWeekDataModel> chartData = [];
      categorizedData.forEach((day, categoryData) {
        double vocationalAvg = calculateAverage(categoryData['Vocational']!);
        double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
        double personalDevelopmentAvg =
            calculateAverage(categoryData['Personal Development']!);
        double globalAvg =
            (vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3;

        chartData.add(GlobalScoreChartOneWeekDataModel(
          day,
          globalAvg.clamp(0, 100).toInt(),
          wellbeingAvg.clamp(0, 100).toInt(),
          vocationalAvg.clamp(0, 100).toInt(),
          personalDevelopmentAvg.clamp(0, 100).toInt(),
        ));
      });

      return chartData;
    } else {
      return [];
    }
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

  List<GlobalScoreChartOneWeekDataModel> processGoalData(
      GoalReportListResponse data) {
    Map<String, Map<String, List<double>>> categorizedData = {
      'Jan-Feb': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
      'Mar-Apr': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
      'May-Jun': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
      'Jul-Aug': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
      'Sep-Oct': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
      'Nov-Dec': {
        'Vocational': [],
        'Wellbeing': [],
        'Personal Development': []
      },
    };

    // Track total goals and completed goals
    Map<String, int> totalGoals = {
      'Jan-Feb': 0,
      'Mar-Apr': 0,
      'May-Jun': 0,
      'Jul-Aug': 0,
      'Sep-Oct': 0,
      'Nov-Dec': 0
    };
    Map<String, int> completedGoals = {
      'Jan-Feb': 0,
      'Mar-Apr': 0,
      'May-Jun': 0,
      'Jul-Aug': 0,
      'Sep-Oct': 0,
      'Nov-Dec': 0
    };

    for (var report in data.data!) {
      DateTime reportDate = DateTime.parse(report.date!);
      String category = getCategory(reportDate);

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

          categorizedData[category]?[detail.goal!.category!.name]
              ?.add(completionPercentage);

          // Update total and completed goals
          totalGoals[category] = (totalGoals[category] ?? 0) + 1;
          if (completionPercentage == 100) {
            completedGoals[category] = (completedGoals[category] ?? 0) + 1;
          }
        }
      }
    }

    categorizedData.forEach((period, categoryData) {
      double vocationalAvg = calculateAverage(categoryData['Vocational']!);
      double wellbeingAvg = calculateAverage(categoryData['Wellbeing']!);
      double personalDevelopmentAvg =
          calculateAverage(categoryData['Personal Development']!);

      // Calculate global average as the ratio of completed goals to total goals
      double globalAvg = totalGoals[period]! > 0
          ? (completedGoals[period]! / totalGoals[period]!) * 100
          : 0;

      // Debug prints
      print('Period: $period');
      print('Total Goals: ${totalGoals[period]}');
      print('Completed Goals: ${completedGoals[period]}');
      print('Global Avg: $globalAvg');

      chartData.add(GlobalScoreChartOneWeekDataModel(
        period,
        globalAvg.clamp(0, 100).toInt(),
        wellbeingAvg.clamp(0, 100).toInt(),
        vocationalAvg.clamp(0, 100).toInt(),
        personalDevelopmentAvg.clamp(0, 100).toInt(),
      ));
    });

    return chartData;
  }

  double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    double sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  String getCategory(DateTime date) {
    if (date.month <= 2) {
      return 'Jan-Feb';
    } else if (date.month <= 4) {
      return 'Mar-Apr';
    } else if (date.month <= 6) {
      return 'May-Jun';
    } else if (date.month <= 8) {
      return 'Jul-Aug';
    } else if (date.month <= 10) {
      return 'Sep-Oct';
    } else {
      return 'Nov-Dec';
    }
  }

  List<MoodChartDataModel> getMoodHistoryStats(
      List<MoodHistoryResponseData> data, String type) {
    if (type == "one_week") {
      final Map<String, List<int>> groupedData = {
        'Mon': [],
        'Tue': [],
        'Wed': [],
        'Thu': [],
        'Fri': [],
        'Sat': [],
        'Sun': []
      };

      // Define date format
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat dayFormat =
          DateFormat('EEE'); // Abbreviated day name format

      // Get today's date and calculate the date 7 days ago
      final DateTime today = DateTime.now();
      final DateTime weekAgo = today.subtract(Duration(days: 7));

      // Iterate through the data and group by day abbreviation within the last week
      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(weekAgo) && date.isBefore(today)) {
          final String dayName = dayFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (groupedData.containsKey(dayName)) {
            groupedData[dayName]?.add(mood);
          }
        }
      }

      // Create MoodChartDataModel instances for each day in the last week
      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 7; i++) {
        final DateTime date = today.subtract(Duration(days: i));
        final String dayName = dayFormat.format(date);
        final List<int>? moods = groupedData[dayName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(dayName, averageMood));
      }

      return moodChartData.reversed.toList();
    } else if (type == "one_month") {
      final Map<String, List<int>> groupedData = {};

      // Define date format
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat dayFormat =
          DateFormat('MMM dd'); // Format for displaying day

      // Get today's date and calculate the date 30 days ago
      final DateTime today = DateTime.now();
      final DateTime monthAgo = today.subtract(Duration(days: 30));

      // Iterate through the data and group by date within the last month
      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(monthAgo) && date.isBefore(today)) {
          final String dayName = dayFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(dayName)) {
            groupedData[dayName] = [];
          }
          groupedData[dayName]?.add(mood);
        }
      }

      // Create MoodChartDataModel instances for each day in the last month
      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 30; i++) {
        final DateTime date = today.subtract(Duration(days: i));
        final String dayName = dayFormat.format(date);
        final List<int>? moods = groupedData[dayName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(dayName, averageMood));
      }

      return moodChartData.reversed
          .toList(); // Reverse to show chronological order
    } else if (type == "three_month") {
      // Create a map to hold the grouped data by month
      final Map<String, List<int>> groupedData = {};

      // Define date format
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat monthFormat =
          DateFormat('MMM'); // Format for displaying month

      // Get today's date and calculate the start date for three months ago
      final DateTime today = DateTime.now();
      final DateTime threeMonthsAgo = DateTime(today.year, today.month - 2, 1);

      // Iterate through the data and group by month within the last three months
      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(threeMonthsAgo) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          final String monthName = monthFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(monthName)) {
            groupedData[monthName] = [];
          }
          groupedData[monthName]?.add(mood);
        }
      }

      // Create MoodChartDataModel instances for each of the last three months
      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 3; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(monthName, averageMood));
      }

      return moodChartData.reversed
          .toList(); // Reverse to show chronological order
    } else if (type == "six_month") {
      // Create a map to hold the grouped data by month
      final Map<String, List<int>> groupedData = {};

      // Define date format
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat monthFormat =
          DateFormat('MMM'); // Format for displaying month

      // Get today's date and calculate the start date for six months ago
      final DateTime today = DateTime.now();
      final DateTime sixMonthsAgo = DateTime(today.year, today.month - 5, 1);

      // Iterate through the data and group by month within the last six months
      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(sixMonthsAgo) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          final String monthName = monthFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(monthName)) {
            groupedData[monthName] = [];
          }
          groupedData[monthName]?.add(mood);
        }
      }

      // Create MoodChartDataModel instances for each of the last six months
      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 6; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(monthName, averageMood));
      }

      return moodChartData.reversed
          .toList(); // Reverse to show chronological order
    } else {
      final Map<String, List<int>> groupedData = {};
      final DateFormat monthFormat = DateFormat('MMM');

      // Get today's date and calculate the start date for one year ago
      final DateTime today = DateTime.now();
      final DateTime oneYearAgo =
          DateTime(today.year - 1, today.month, today.day);

      for (var entry in data) {
        final DateTime date = DateTime.parse(entry.date!);
        if (date.isAfter(oneYearAgo) && date.isBefore(today)) {
          final String monthName = monthFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(monthName)) {
            groupedData[monthName] = [];
          }
          groupedData[monthName]?.add(mood);
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      // Loop through the last 12 months
      for (int i = 0; i < 12; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(monthName, averageMood));
      }

      return moodChartData.reversed
          .toList(); // Reverse to show chronological order
    }
  }

  String getMonthRange(int month) {
    switch (month) {
      case 1:
      case 2:
        return 'Jan-Feb';
      case 3:
      case 4:
        return 'Mar-Apr';
      case 5:
      case 6:
        return 'May-Jun';
      case 7:
      case 8:
        return 'Jul-Aug';
      case 9:
      case 10:
        return 'Sep-Oct';
      case 11:
      case 12:
        return 'Nov-Dec';
      default:
        return '';
    }
  }

  List<String> getLastThreeMonths() {
    final DateTime today = DateTime.now();
    final DateFormat monthFormat = DateFormat('MMM');

    final List<String> lastThreeMonths = [];
    for (int i = 0; i < 3; i++) {
      final DateTime month = DateTime(today.year, today.month - i, 1);
      lastThreeMonths.add(monthFormat.format(month));
    }

    return lastThreeMonths.reversed.toList(); // Reverse to maintain order
  }

  List<Map<String, dynamic>> calculateGoalPercentages(
      GoalReportListResponse goalReportListResponse) {
    List<Map<String, dynamic>> goalPercentages = [];

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
          var existingGoal =
              goalPercentages.firstWhere((g) => g['id'] == goalId,
                  orElse: () => {
                        'id': goalId,
                        'name': goalName,
                        'category': goalCategory,
                        'measureType': goalMeasureType,
                        'values': []
                      });

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
          if (numericValue > 5) {
            totalCompletion += 1; // Treat it as fully complete
          } else {
            totalCompletion += numericValue / 10.0;
          }
        }
      }

      double percentage = (totalCompletion / goal['values'].length) * 100;
      goal['completionPercentage'] = percentage;
    }

    // Sort the goals by completion percentage in descending order
    goalPercentages.sort((a, b) =>
        b['completionPercentage'].compareTo(a['completionPercentage']));

    // Return the top 5 percentage goals
    return goalPercentages.take(5).toList();
  }

  Color? getCategoryColor(String categoryId) {
    switch (categoryId) {
      case "6628e19cb0f93ad8fddbd7a4":
        return kStreaksColor;
      case "6638bf06584bab76b306e569":
        return kRACGPExamColor;
      case "6628e1ac00b9551011466195":
        return kDailyGratitudeColor;
    }
    return null;
  }

  getUserGoals({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingGoals.value = true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getUserGoalsList(PrefUtils().token, "active").then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalsListResponse goalsListResponse = value.snapshot;
          if (goalsListResponse.success == true) {
            if (goalsListResponse.data != null) {
              goalsList.clear();
              goalsListIndex.clear();
              if (goalsListResponse.data!.wellBeing != null) {
                goalsList.addAll(goalsListResponse.data!.wellBeing!);
              }
              if (goalsListResponse.data!.vocational != null) {
                goalsList.addAll(goalsListResponse.data!.vocational!);
              }
              if (goalsListResponse.data!.personalDevelopment != null) {
                goalsList.addAll(goalsListResponse.data!.personalDevelopment!);
              }
              for (int i = 0; i < goalsList.length; i++) {
                goalsListIndex.add(i);
              }
              if (goalsList.isNotEmpty) {
                selectedFirstGoalIndex.value = 0;
                if (goalsList.length > 1) {
                  selectedSecondGoalIndex.value = 1;
                } else {
                  selectedSecondGoalIndex.value = 0;
                }
                getComparisonGoalReport(true);
                getComparisonGoalReport(false);
                getGoalReport(goalsList.first.sId!, false, false);
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(goalsListResponse.message ?? "",
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
      if (isShowLoading) {
        isLoadingGoals.value = false;
      }
    });
  }

  getTopStreak() async {
    httpManager.getTopStreak(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GenericResponse genericResponse = value.snapshot;
          if (genericResponse.success == true) {
            if (genericResponse.data != null) {
              user = User.fromJson(json.decode(PrefUtils().user));
              if ((user?.currentStreak ?? 0) > (genericResponse.data ?? 0)) {
                topStreak.value = user?.currentStreak ?? 0;
              } else {
                topStreak.value = genericResponse.data ?? 0;
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(genericResponse.message ?? "",
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

  getComparisonGoalReport(bool isForFirst) async {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .getGoalReport(
            PrefUtils().token,
            isForFirst
                ? goalsList[selectedFirstGoalIndex.value].sId!
                : goalsList[selectedSecondGoalIndex.value].sId!)
        .then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalReportListResponse goalReportListResponse = value.snapshot;
          if (goalReportListResponse.success == true) {
            if (goalReportListResponse.data != null) {
              if (isForFirst) {
                firstGoalReport.clear();
                firstGoalReport.add(goalReportListResponse);
              } else {
                secondGoalReport.clear();
                secondGoalReport.add(goalReportListResponse);
              }
              if (firstGoalReport.isNotEmpty && secondGoalReport.isNotEmpty) {
                processMultipleGoals([firstGoalReport[0], secondGoalReport[0]]);
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

  getGoalAchieved() {
    final Map<String, int> goalCompletionTracker = {};

    for (var entry in goalReportListResponse!.data!) {
      var goals = entry.details!;

      for (var goal in goals) {
        if (goal.goal != null) {
          var goalDetails = goal.goal!;
          var goalId = goalDetails.sId!;
          var goalType = goal.type;
          var goalValue = goal.value;

          if (!goalCompletionTracker.containsKey(goalId)) {
            goalCompletionTracker[goalId] = 0;
          }

          if (goalType == 'boolean' && goalValue == 'true') {
            goalCompletionTracker[goalId] =
                (goalCompletionTracker[goalId] ?? 0) + 1;
          } else if (goalType == 'string' && int.parse(goalValue!) > 5) {
            goalCompletionTracker[goalId] =
                (goalCompletionTracker[goalId] ?? 0) + 1;
          }
        }
      }
    }

    int achievedGoalsCount =
        goalCompletionTracker.values.fold(0, (sum, count) => sum + count);
    goalsAchieved.value = achievedGoalsCount;
  }

  getPerfectDays() {
    int fullCompletionDaysCount = 0;

    for (var entry in goalReportListResponse!.data!) {
      var goals = entry.details;
      bool allGoalsCompleted = true;

      for (var goal in goals!) {
        var goalType = goal.type;
        var goalValue = goal.value;

        if (goalType == 'boolean' && goalValue != 'true') {
          allGoalsCompleted = false;
          break;
        } else if (goalType == 'string' && int.parse(goalValue ?? "0") > 5) {
          allGoalsCompleted = false;
          break;
        }
      }

      if (allGoalsCompleted) {
        fullCompletionDaysCount += 1;
      }
    }
    perfectDays.value = fullCompletionDaysCount;
  }

  getGoalReport(String goalId, bool isForExpand, bool isForComments,
      {String type = ""}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getGoalReport(PrefUtils().token, goalId).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalReportListResponse goalReportListResponse = value.snapshot;
          if (goalReportListResponse.success == true) {
            if (goalReportListResponse.data != null) {
              if (isForComments) {
                commentsGoalReport.clear();
                commentsGoalReport.addAll(goalReportListResponse.data!);
              } else {
                if (isForExpand) {
                  expandedGoalReport.clear();
                  expandedGoalReport.addAll(goalReportListResponse.data!);
                  processExpandSpecificGoalChart(goalReportListResponse, type);
                } else {
                  specificGoalReport.clear();
                  specificGoalReport.addAll(goalReportListResponse.data!);
                  processSpecificGoalChart(goalReportListResponse);
                }
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

  List<GoalChartDateModel> processExpandSpecificGoalChart(
      GoalReportListResponse goalReportListResponse, String type) {
    expandedGoalReportChart.clear();
    if (type == "one_week") {
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
            comments[dayOfWeek]!.add(comment);
          }
        }
      }

      days.forEach((day, values) {
        if (values.isNotEmpty) {
          double average = values.reduce((a, b) => a + b) / values.length;
          String comment = comments[day]!.join(', '); // Combine comments
          goalReportChart.add(GoalChartDateModel(day, average, comment));
        } else {
          goalReportChart.add(GoalChartDateModel(day, 0, ''));
        }
      });
    }

    return goalReportChart;
  }

  List<GoalChartDateModel> processSpecificGoalChart(
      GoalReportListResponse goalReportListResponse) {
    goalReportChart.clear();
    Map<String, List<int>> quarters = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    Map<String, List<String>> comments = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    // Iterate over the response data
    for (var report in goalReportListResponse.data!) {
      DateTime date = DateTime.parse(report.date!);
      int value = 0;
      if (report.details!.isNotEmpty) {
        // Check if the goal measure is a boolean or a string
        if (report.details![0].type == 'boolean') {
          value = report.details![0].value == 'true' ? 100 : 0;
        } else if (report.details![0].type == 'string') {
          value =
              int.parse(report.details![0].value!) * 10; // Scale 0-10 to 0-100
        }

        String comment = report.details![0].comment ?? "";

        // Assign to the correct quarter
        if (date.month == 1 || date.month == 2) {
          quarters['Jan - Feb']!.add(value);
          if (comment.isNotEmpty) {
            comments['Jan - Feb']!.add(comment);
          }
        } else if (date.month == 3 || date.month == 4) {
          quarters['Mar - Apr']!.add(value);
          if (comment.isNotEmpty) {
            comments['Mar - Apr']!.add(comment);
          }
        } else if (date.month == 5 || date.month == 6) {
          quarters['May - Jun']!.add(value);
          if (comment.isNotEmpty) {
            comments['May - Jun']!.add(comment);
          }
        } else if (date.month == 7 || date.month == 8) {
          quarters['Jul - Aug']!.add(value);
          if (comment.isNotEmpty) {
            comments['Jul - Aug']!.add(comment);
          }
        } else if (date.month == 9 || date.month == 10) {
          quarters['Sep - Oct']!.add(value);
          if (comment.isNotEmpty) {
            comments['Sep - Oct']!.add(comment);
          }
        } else if (date.month == 11 || date.month == 12) {
          quarters['Nov - Dec']!.add(value);
          if (comment.isNotEmpty) {
            comments['Nov - Dec']!.add(comment);
          }
        }
      }
    }

    quarters.forEach((period, values) {
      if (values.isNotEmpty) {
        double average = values.reduce((a, b) => a + b) / values.length;

        String comment = comments[period]!.join(', ');
        goalReportChart.add(GoalChartDateModel(period, average, comment));
      } else {
        goalReportChart.add(GoalChartDateModel(period, 0, ''));
      }
    });

    return goalReportChart;
  }

  List<ComparisonChartDataModel> processMultipleGoals(
      List<GoalReportListResponse> goalReportListResponses) {
    comparisonChartData.clear();
    Map<String, List<int>> quartersGoalOne = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    Map<String, List<String>> commentsGoalOne = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    Map<String, List<int>> quartersGoalTwo = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    Map<String, List<String>> commentsGoalTwo = {
      'Jan - Feb': [],
      'Mar - Apr': [],
      'May - Jun': [],
      'Jul - Aug': [],
      'Sep - Oct': [],
      'Nov - Dec': []
    };

    // Process each goal response
    if (goalReportListResponses.isNotEmpty) {
      processGoalForMultiple(
          goalReportListResponses[0], quartersGoalOne, commentsGoalOne);
    }
    if (goalReportListResponses.length > 1) {
      processGoalForMultiple(
          goalReportListResponses[1], quartersGoalTwo, commentsGoalTwo);
    }

    quartersGoalOne.forEach((period, valuesGoalOne) {
      double averageGoalOne = valuesGoalOne.isNotEmpty
          ? valuesGoalOne.reduce((a, b) => a + b) / valuesGoalOne.length
          : 0;
      double averageGoalTwo = quartersGoalTwo[period]!.isNotEmpty
          ? quartersGoalTwo[period]!.reduce((a, b) => a + b) /
              quartersGoalTwo[period]!.length
          : 0;
      comparisonChartData.add(ComparisonChartDataModel(
          period, averageGoalOne.toInt(), averageGoalTwo.toInt()));
    });

    return comparisonChartData;
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
          value =
              int.parse(report.details![0].value!) * 10; // Scale 0-10 to 0-100
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
