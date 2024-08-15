import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/comparison/comparison.dart';
import 'package:life_berg/view/screens/personal_statistics/comparison/comparison_expand.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/global_score.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/global_score_expand.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goals.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goals_expand.dart';
import 'package:life_berg/view/screens/personal_statistics/mood/mood_expand.dart';
import 'package:life_berg/view/screens/personal_statistics/score_board/score_board.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/screens/settings/settings_screens/points/points_expand.dart';
import 'package:life_berg/view/widget/charts_widget/mood_chart.dart';
import 'package:life_berg/view/widget/charts_widget/points_accural_chart.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/mile_stone_card.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class PersonalStatistics extends StatefulWidget {
  PersonalStatistics({Key? key}) : super(key: key);

  @override
  State<PersonalStatistics> createState() => _PersonalStatisticsState();
}

class _PersonalStatisticsState extends State<PersonalStatistics>
    with SingleTickerProviderStateMixin {
  final StatisticsController statisticsController =
      Get.put(StatisticsController());

  late TabController tabController;
  int currentTab = 0;
  String? data;


  List<String> tabs = [
    'Global Score',
    'Goals',
    'Comparison',
  ];

  List<Widget> tabViews = [
    GlobalScore(),
    Globals(),
    Comparison(),
  ];

  final List<PointAccuralChartDataModel> _pointsAccuralChartData = [
    PointAccuralChartDataModel(
      'Jan - Mar',
      0,
    ),
    PointAccuralChartDataModel(
      'Apr - July',
      2,
    ),
    PointAccuralChartDataModel(
      'Aug - Oct',
      4,
    ),
    PointAccuralChartDataModel(
      'Nov-Jan',
      6,
    ),
    PointAccuralChartDataModel(
      '',
      2,
    ),
  ];

  final List<ChartData> chartData = [
    ChartData(
      'David',
      67,
      kDailyGratitudeColor,
    ),
    ChartData(
      'Steve',
      35,
      kStreaksColor,
    ),
    ChartData(
      'Jack',
      25,
      kRACGPExamColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      currentTab = tabController.index;
    });
  }

  void getCurrentTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void goToExpandScreen(int index) {
    if (index == 0) {
      Get.to(() => GlobalScoreExpand());
    } else if (index == 1) {
      Get.to(() => GoalExpand());
    } else {
      Get.to(() => ComparisonExpand());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Personal Statistics',
        centerTitle: true,
        haveLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Text(data!),
          Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox(
              height: 41,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TabBar(
                        onTap: (index) => getCurrentTab(index),
                        controller: tabController,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: kDayStepColor,
                        indicatorWeight: 4,
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        tabs: List<Tab>.generate(
                          tabs.length,
                          (index) => Tab(
                            child: MyText(
                              text: tabs[index],
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => goToExpandScreen(currentTab),
                    child: Image.asset(
                      Assets.imagesExpandedIcon,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 240,
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: tabController,
              children: tabViews,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 32,
                ),
                Obx(() => statisticsController.isLoadingGoalsReport.value ==
                        true
                    ? SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingActionTile(
                            heading: 'Scoreboard',
                            haveTrailing: true,
                            onTap: () => Get.to(
                              () => ScoreBoard(),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext ctx, index) {
                              return CustomIconTile(
                                title: statisticsController
                                    .goalCompletionList[index]['name'],
                                leadingColor: statisticsController
                                    .getCategoryColor(statisticsController
                                        .goalCompletionList[index]['category']),
                                points: statisticsController
                                    .goalCompletionList[index]
                                        ['completionPercentage']
                                    .toInt(),
                              );
                            },
                            itemCount:
                                statisticsController.goalCompletionList.length,
                          )
                        ],
                      )),
                // CustomIconTile(
                //   title: 'Quiet Time',
                //   leadingColor: kStreaksColor,
                //   points: 100,
                // ),
                // CustomIconTile(
                //   title: 'RACGP Exam',
                //   leadingColor: kRACGPExamColor,
                //   points: 86,
                // ),
                // CustomIconTile(
                //   title: '10 Steps a day',
                //   leadingColor: kDayStepColor,
                //   points: 95,
                // ),
                // CustomIconTile(
                //   title: '20 mins cardio',
                //   leadingColor: kRACGPExamColor,
                //   points: 62,
                // ),
                SizedBox(
                  height: 24,
                ),
                Obx(
                  () => statisticsController.isLoadingMoodHistory.value == true
                      ? SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          children: [
                            HeadingActionTile(
                              heading: 'Mood',
                              haveTrailing: true,
                              onTap: () => Get.to(() =>
                                  MoodExpand()),
                            ),
                            MoodChart(
                              moodChartDataSource:
                                  statisticsController.moodChartData,
                            ),
                          ],
                        ),
                ),
                MainHeading(
                  paddingTop: 26,
                  text: 'Milestones',
                  paddingBottom: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => MilestoneCard(
                          icon: Assets.imagesGoalsAchieve,
                          points: statisticsController.goalsAchieved.value
                              .toString(),
                          title: 'Goals\nAchieved',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Obx(() => MilestoneCard(
                            icon: Assets.imagesBestStreaks,
                            points:
                                statisticsController.topStreak.value.toString(),
                            title: 'Best\nStreaks',
                          )),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Obx(
                      () => MilestoneCard(
                        icon: Assets.imagesPerfectDays,
                        points:
                            statisticsController.perfectDays.value.toString(),
                        title: 'Perfect\nDays',
                      ),
                    )),
                  ],
                ),
                /*MainHeading(
                  paddingTop: 32,
                  text: 'Points Breakdown',
                  paddingBottom: 12,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 180,
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: chartData,
                            radius: '70',
                            pointColorMapper: (ChartData data, Color) =>
                                data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            cornerStyle: CornerStyle.bothFlat,
                            innerRadius: '80%',
                          ),
                        ],
                      ),
                    ),
                    MyText(
                      text: '127',
                      size: 35,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                CustomIconTile(
                  title: 'Daily Reporting',
                  leadingColor: kDailyGratitudeColor,
                  points: 67,
                ),
                CustomIconTile(
                  title: 'Streaks',
                  leadingColor: kStreaksColor,
                  points: 35,
                ),
                CustomIconTile(
                  title: 'Journaling & Development',
                  leadingColor: kRACGPExamColor,
                  points: 25,
                ),
                SizedBox(
                  height: 16,
                ),
                HeadingActionTile(
                  heading: 'Points Accural',
                  haveTrailing: true,
                  onTap: () => Get.to(
                    () => PointsExpand(),
                  ),
                ),
                PointAccuralChart(
                  dataSource: _pointsAccuralChartData,
                  primaryXYAxisMax: 3,
                  primaryXYAxisMin: 0,
                  primaryYAxisMax: 8,
                  primaryYAxisMin: 0,
                ),*/
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.color,
  );

  final String x;
  final double y;
  final Color color;
}
