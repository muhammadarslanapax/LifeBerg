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
import 'package:life_berg/model/top_streak/top_streak_response.dart';
import 'package:life_berg/model/top_streak/top_streak_response_data.dart';

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

  final TextEditingController moodCommentController = TextEditingController();

  RxList<MoodHistoryResponseData> moodHistory = <MoodHistoryResponseData>[].obs;
  final List<MoodChartDataModel> moodChartData = [];
  List<Map<String, dynamic>> goalCompletionList = [];
  List<GlobalScoreChartOneWeekDataModel> chartData = [];
  List<Goal> goalsList = [];
  List<int> goalsListIndex = [];

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
    getUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getUserData({bool isShowLoading = true}) {
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
                  .addAll(calculateScoreboard(goalReportListResponse));
              processGlobalScore(goalReportListResponse);
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
      moodChartData.clear();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getAllMoodHistory(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          MoodHistoryResponse moodHistoryResponse = value.snapshot;
          if (moodHistoryResponse.success == true) {
            if (moodHistoryResponse.data != null) {
              moodHistory.addAll(moodHistoryResponse.data!);
              moodHistory.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
              moodChartData
                  .addAll(processMoodChartData(moodHistoryResponse.data!));
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

  List<GoalChartDateModel> processSpecificGoalChart(
      GoalReportListResponse goalReportListResponse) {
    goalReportChart.clear();

    Map<String, List<int>> dayValues = {};
    Map<String, List<String>> dayComments = {};

    DateTime now = DateTime.now();
    DateTime startOfLastWeek = now.subtract(Duration(days: 7));

    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      dayValues[formattedDate] = [];
      dayComments[formattedDate] = [];
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

      goalReportChart.add(GoalChartDateModel(formattedDate, average, comments));
    }

    return goalReportChart;
  }

  List<MoodChartDataModel> processMoodChartData(
      List<MoodHistoryResponseData> data) {
    final Map<String, int?> groupedData = {};
    final Map<String, String?> commentsMap = {};

    DateTime now = DateTime.now();
    DateTime startOfLastWeek = now.subtract(Duration(days: 7));

    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      groupedData[formattedDate] = null;
      commentsMap[formattedDate] = null;
    }

    for (var entry in data) {
      DateTime date = DateTime.parse(entry.date!);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      if (groupedData.containsKey(formattedDate)) {
        final int mood = int.parse(entry.mood!) * 20;
        groupedData[formattedDate] = mood;
        commentsMap[formattedDate] = entry.comment;
      }
    }

    final List<MoodChartDataModel> moodChartData = [];

    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final int? mood = groupedData[formattedDate];
      final String? comment = commentsMap[formattedDate];
      // if(mood != null) {
      moodChartData.add(MoodChartDataModel(formattedDate, mood ?? -1, comment));
      // }
    }

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

  // List<GlobalScoreChartOneWeekDataModel> processGlobalScore(
  //     GoalReportListResponse data) {
  //   Map<String, Map<String, List<double>>> categorizedData = {
  //     'Mon': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Tue': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Wed': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Thu': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Fri': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Sat': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //     'Sun': {'Vocational': [], 'Wellbeing': [], 'Personal Development': []},
  //   };
  //
  //   Map<String, int> totalGoals = {
  //     'Mon': 0,
  //     'Tue': 0,
  //     'Wed': 0,
  //     'Thu': 0,
  //     'Fri': 0,
  //     'Sat': 0,
  //     'Sun': 0
  //   };
  //
  //   DateTime currentDate = DateTime.now();
  //   int currentDayOfWeek = currentDate.weekday;
  //
  //   // Calculate the start and end of the last week
  //   DateTime startOfLastWeek =
  //       currentDate.subtract(Duration(days: currentDayOfWeek + 7));
  //   DateTime endOfLastWeek = startOfLastWeek.add(Duration(days: 6));
  //
  //   // Determine the order of days from today backwards
  //   List<String> daysOrder = [];
  //   for (int i = 0; i < 7; i++) {
  //     DateTime day = currentDate.subtract(Duration(days: i));
  //     String dayOfWeek = DateFormat('EEE').format(day);
  //     daysOrder.add(dayOfWeek);
  //   }
  //
  //   // Process the reports
  //   for (var report in data.data!) {
  //     DateTime reportDate = DateTime.parse(report.date!);
  //
  //     if (reportDate.isBefore(startOfLastWeek) ||
  //         reportDate.isAfter(endOfLastWeek)) {
  //       continue;
  //     }
  //
  //     String dayOfWeek = getDayOfWeek(reportDate);
  //
  //     for (var detail in report.details!) {
  //       if (detail.goal != null) {
  //         double completionPercentage = 0;
  //
  //         if (detail.type == 'string') {
  //           double value = double.parse(detail.value!);
  //           completionPercentage = value * 10;
  //         } else if (detail.type == 'boolean') {
  //           bool value = detail.value == 'true';
  //           completionPercentage = value ? 100 : 0;
  //         }
  //
  //         categorizedData[dayOfWeek]?[detail.goal!.category!.name]
  //             ?.add(completionPercentage);
  //
  //         // Update total goals
  //         totalGoals[dayOfWeek] = (totalGoals[dayOfWeek] ?? 0) + 1;
  //       }
  //     }
  //   }
  //
  //   for (String day in daysOrder) {
  //     double vocationalAvg =
  //         calculateAverage(categorizedData[day]!['Vocational']!);
  //     double wellbeingAvg =
  //         calculateAverage(categorizedData[day]!['Wellbeing']!);
  //     double personalDevelopmentAvg =
  //         calculateAverage(categorizedData[day]!['Personal Development']!);
  //
  //     double globalAvg = totalGoals[day]! > 0
  //         ? ((vocationalAvg + wellbeingAvg + personalDevelopmentAvg) / 3)
  //         : 0;
  //
  //     // Debug prints
  //     print('Day: $day');
  //     print('Total Goals: ${totalGoals[day]}');
  //     print('Global Avg: $globalAvg');
  //
  //     chartData.add(GlobalScoreChartOneWeekDataModel(
  //       day,
  //       globalAvg.clamp(0, 100).toInt(),
  //       wellbeingAvg.clamp(0, 100).toInt(),
  //       vocationalAvg.clamp(0, 100).toInt(),
  //       personalDevelopmentAvg.clamp(0, 100).toInt(),
  //     ));
  //   }
  //   chartData = chartData.reversed.toList();
  //
  //   return chartData;
  // }

  List<GlobalScoreChartOneWeekDataModel> processGlobalScore(
      GoalReportListResponse data) {
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

    for (var report in data.data!) {
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
      double personalDevelopmentAvg = calculateAverage(
          categorizedData[formattedDate]!['Personal Development']!);

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

    return chartData;
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

  double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
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
      final Map<String, int?> groupedData = {};
      final Map<String, String?> commentsMap = {};

      DateTime now = DateTime.now();
      DateTime startOfLastWeek = now.subtract(Duration(days: 7));

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        groupedData[formattedDate] = null;
        commentsMap[formattedDate] = null;
      }

      for (var entry in data) {
        DateTime date = DateTime.parse(entry.date!);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (groupedData.containsKey(formattedDate)) {
          final int mood = int.parse(entry.mood!) * 20;
          groupedData[formattedDate] = mood;
          commentsMap[formattedDate] = entry.comment;
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 1; i <= 7; i++) {
        DateTime date = startOfLastWeek.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final int? mood = groupedData[formattedDate];
        final String? comment = commentsMap[formattedDate];
        moodChartData.add(MoodChartDataModel(formattedDate, mood ?? -1, comment));
      }
      return moodChartData;
    } else if (type == "one_month") {
      final Map<String, int?> groupedData = {};
      final Map<String, String?> commentsMap = {};

      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat dayFormat = DateFormat('yyyy-MM-dd');

      final DateTime today = DateTime.now();
      final DateTime monthAgo = today.subtract(Duration(days: 30));

      for (int i = 0; i < 30; i++) {
        final DateTime date = today.subtract(Duration(days: i));
        final String dayName = dayFormat.format(date);
        groupedData[dayName] = null;
        commentsMap[dayName] = null;
      }

      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(monthAgo) && date.isBefore(today)) {
          final String dayName = dayFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          groupedData[dayName] = mood;
          commentsMap[dayName] = entry.comment;
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 30; i++) {
        final DateTime date = today.subtract(Duration(days: i));
        final String dayName = dayFormat.format(date);
        final int? moods = groupedData[dayName];
        final String? comment = commentsMap[dayName];

        moodChartData.add(MoodChartDataModel(dayName, moods ?? -1, comment));
      }

      return moodChartData.reversed.toList();
    } else if (type == "three_month") {
      final Map<String, List<int>> groupedData = {};
      final Map<String, String?> commentsMap = {};

      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat monthFormat = DateFormat('MMM');

      final DateTime today = DateTime.now();
      final DateTime threeMonthsAgo = DateTime(today.year, today.month - 2, 1);

      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(threeMonthsAgo) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          final String monthName = monthFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(monthName)) {
            groupedData[monthName] = [];
            commentsMap[monthName] = null;
          }
          groupedData[monthName]?.add(mood);
          commentsMap[monthName] = entry.comment;
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 3; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(
            monthName, averageMood == 0 ? null : averageMood,
            commentsMap[monthName]));
      }

      return moodChartData.reversed
          .toList(); // Reverse to show chronological order
    } else if (type == "six_month") {
      final Map<String, List<int>> groupedData = {};
      final Map<String, String?> commentMap = {};

      final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final DateFormat monthFormat = DateFormat('MMM');

      final DateTime today = DateTime.now();
      final DateTime sixMonthsAgo = DateTime(today.year, today.month - 5, 1);

      for (var entry in data) {
        final DateTime date = dateFormat.parse(entry.date!, true).toLocal();
        if (date.isAfter(sixMonthsAgo) &&
            date.isBefore(today.add(Duration(days: 1)))) {
          final String monthName = monthFormat.format(date);
          final int mood = int.parse(entry.mood!) * 20;

          if (!groupedData.containsKey(monthName)) {
            groupedData[monthName] = [];
            commentMap[monthName] = null;
          }
          groupedData[monthName]?.add(mood);
          commentMap[monthName] = entry.comment;
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 6; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(
            monthName, averageMood == 0 ? null : averageMood,
            commentMap[monthName]));
      }

      return moodChartData.reversed.toList();
    } else {
      final Map<String, List<int>> groupedData = {};
      final Map<String, String?> commentMap = {};

      final DateFormat monthFormat = DateFormat('MMM');

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
            commentMap[monthName] = null;
          }
          groupedData[monthName]?.add(mood);
          commentMap[monthName] = entry.comment;
        }
      }

      final List<MoodChartDataModel> moodChartData = [];

      for (int i = 0; i < 12; i++) {
        final DateTime month = DateTime(today.year, today.month - i, 1);
        final String monthName = monthFormat.format(month);
        final List<int>? moods = groupedData[monthName];
        final int averageMood = moods != null && moods.isNotEmpty
            ? (moods.reduce((a, b) => a + b) / moods.length).round()
            : 0;

        moodChartData.add(MoodChartDataModel(
            monthName, averageMood == 0 ? null : averageMood,
            commentMap[monthName]));
      }

      return moodChartData.reversed.toList();
    }
  }

  List<Map<String, dynamic>> calculateScoreboard(
      GoalReportListResponse goalReportListResponse) {
    List<Map<String, dynamic>> goalPercentages = [];

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

    // Sort and return top 5 goals
    goalPercentages.sort((a, b) =>
        b['completionPercentage'].compareTo(a['completionPercentage']));

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
                getGoalReport(goalsList.first.sId!);
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
          TopStreakResponse topStreakResponse = value.snapshot;
          if (topStreakResponse.success == true) {
            if (topStreakResponse.data != null) {
              user = User.fromJson(json.decode(PrefUtils().user));
              TopStreakResponseData highestScoreObject = topStreakResponse.data!.reduce((a, b) => a.topScore! > b.topScore! ? a : b);
              if ((user?.currentStreak ?? 0) > (highestScoreObject.topScore ?? 0)) {
                topStreak.value = user?.currentStreak ?? 0;
              } else {
                topStreak.value = highestScoreObject.topScore ?? 0;
              }
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(topStreakResponse.message ?? "",
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
        } else if (goalType == 'string' && int.parse(goalValue ?? "0") != 10) {
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

  getGoalReport(String goalId,) async {
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getGoalReport(PrefUtils().token, goalId).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GoalReportListResponse goalReportListResponse = value.snapshot;
          if (goalReportListResponse.success == true) {
            if (goalReportListResponse.data != null) {
              processSpecificGoalChart(goalReportListResponse);
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

  List<ComparisonChartDataModel> processMultipleGoals(
      List<GoalReportListResponse> goalReportListResponses) {
    comparisonChartData.clear();

    Map<String, List<int>> daysGoalOne = {};
    Map<String, List<String>> commentsGoalOne = {};

    Map<String, List<int>> daysGoalTwo = {};
    Map<String, List<String>> commentsGoalTwo = {};

    DateTime currentDate = DateTime.now();
    DateTime startOfLastWeek = currentDate.subtract(Duration(days: 7));

    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      daysGoalOne[formattedDate] = [];
      commentsGoalOne[formattedDate] = [];
      daysGoalTwo[formattedDate] = [];
      commentsGoalTwo[formattedDate] = [];
    }

    if (goalReportListResponses.isNotEmpty) {
      processGoalForMultiple(
          goalReportListResponses[0], daysGoalOne, commentsGoalOne);
    }
    if (goalReportListResponses.length > 1) {
      processGoalForMultiple(
          goalReportListResponses[1], daysGoalTwo, commentsGoalTwo);
    }

    List<String> reversedOrder = [];
    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      reversedOrder.add(DateFormat('yyyy-MM-dd').format(date));
    }

    for (var date in reversedOrder) {
      double averageGoalOne = daysGoalOne[date]!.isNotEmpty
          ? daysGoalOne[date]!.reduce((a, b) => a + b) /
          daysGoalOne[date]!.length
          : 0;
      double averageGoalTwo = daysGoalTwo[date]!.isNotEmpty
          ? daysGoalTwo[date]!.reduce((a, b) => a + b) /
          daysGoalTwo[date]!.length
          : 0;

      comparisonChartData.add(ComparisonChartDataModel(
          date, averageGoalOne.toInt(), averageGoalTwo.toInt()));
    }

    return comparisonChartData;
  }

  List<GoalChartDateModel> processGoalForMultiple(
      GoalReportListResponse goalReportListResponse,
      Map<String, List<int>> days,
      Map<String, List<String>> comments) {
    List<GoalChartDateModel> goalReportChart = [];

    DateTime currentDate = DateTime.now();
    DateTime startOfLastWeek = currentDate.subtract(Duration(days: 7));

    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      days[formattedDate] = [];
      comments[formattedDate] = [];
    }

    for (var report in goalReportListResponse.data!) {
      DateTime date = DateTime.parse(report.date!);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      if (!days.containsKey(formattedDate)) {
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

        days[formattedDate]!.add(value);
        if (comment.isNotEmpty) {
          comments[formattedDate]!.add(comment);
        }
      }
    }

    // Prepare data for output
    List<String> reversedOrder = [];
    for (int i = 1; i <= 7; i++) {
      DateTime date = startOfLastWeek.add(Duration(days: i));
      reversedOrder.add(DateFormat('yyyy-MM-dd').format(date));
    }

    for (var date in reversedOrder) {
      double average = days[date]!.isNotEmpty
          ? days[date]!.reduce((a, b) => a + b) / days[date]!.length
          : 0;
      String comment = comments[date]!.join(', ');

      goalReportChart.add(GoalChartDateModel(date, average, comment));
    }

    return goalReportChart;
  }

  updateUserMood(String date, int mood, String comment,
      Function(bool isSuccess) onAddMood) async {
    SmartDialog.showLoading();
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .updateUserMoodByDate(PrefUtils().token, date, mood, comment)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          GenericResponse genericResponse = value.snapshot;
          if (genericResponse.success == true) {
            onAddMood(true);
          } else {
            onAddMood(false);
            SmartDialog.dismiss();
            ToastUtils.showToast(genericResponse.message ?? "",
                color: kRedColor);
          }
        } else {
          onAddMood(false);
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        onAddMood(false);
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
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
    getUserData(isShowLoading: false);
  }
}
